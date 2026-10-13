---
name: arc-agi-toolkit
description: How to interact with ARC-AGI-3 games through the official arc-agi Python toolkit - discover, play, inspect animations, record, and score a game. Use for any ARC-AGI-3 game run.
version: 1.0.0
build-system: Generated. Edit the source file, not this file.
source-repo: https://github.com/ngaurav/ng-skills
---

# ARC-AGI-3 toolkit

Use the official `arc-agi` SDK from **one long-lived Python process**. Keep the `Arcade`, environment, observation, and scorecard ID alive across calls; recreating them starts a new game.

- AgentR: use its persistent Python kernel.
- Codex and other shell-based harnesses: start an interactive `python3 -i` session in your shell tool, keep it running, and send each step to that same session.

Follow the [toolkit overview](https://docs.arcprize.org/toolkit/overview), and consult the [Arcade](https://docs.arcprize.org/toolkit/arc_agi) and [environment](https://docs.arcprize.org/toolkit/environment_wrapper) references for less common methods.

## Setup

The process needs Python 3.12 or newer. Install into **that interpreter**, not an unrelated project environment:

```python
import importlib.util, subprocess, sys
assert sys.version_info >= (3, 12)
if importlib.util.find_spec("arc_agi") is None:
    subprocess.run(["uv", "pip", "install", "--python", sys.executable, "arc-agi"], check=True)

from arc_agi import Arcade, OperationMode
from arcengine import GameAction, GameState
```

For an individually scored online game, use `OperationMode.ONLINE`. Set `ARC_API_KEY` in the environment when the game or account requires it; never print the key. `OFFLINE` runs local games without an online scorecard. `COMPETITION` is for the restricted aggregate leaderboard run, not a single-game experiment.

## Play and score one game

Replace `<game>` with the game ID prefix, e.g. `wa30`.

```python
arc = Arcade(operation_mode=OperationMode.ONLINE)
games = [g.game_id for g in arc.get_environments() if g.game_id.startswith("<game>")]
assert games, "<game> is unavailable to this SDK session"
card_id = arc.open_scorecard(tags=["<game>"])
env = arc.make("<game>", scorecard_id=card_id, save_recording=True, include_frame_data=True)
assert env is not None
obs = env.observation_space
assert obs is not None
print(env.environment_info.game_id, env.action_space, obs.state, len(obs.frame))
```

If a scorecard ID is provided to you, pass it to `arc.make` instead of opening a new one.

Choose actions from `env.action_space` based on the game. `env.step(GameAction.ACTION1)` is a simple action; a complex action such as `ACTION6` needs coordinates: `env.step(GameAction.ACTION6, data={"x": 32, "y": 32})`. Use the actual intended coordinates, not the example values. `env.step(...)` and `env.reset()` return an observation or `None`; check before reading it. Inspect `obs.state` (including `GameState.WIN` and `GameState.GAME_OVER`) and `obs.levels_completed` after each step.

**Animations:** `obs.frame` is a list of *all* frames returned for that step. Inspect the sequence, not only `obs.frame[-1]`. For visual inspection, render a PNG contact sheet from the frame arrays and view it with the harness's image tool (AgentR: `attach_image`; Codex: `view_image`). Animated GIFs can be flattened. `include_frame_data=True` saves frames in the JSONL recording when `save_recording=True`; it does not control the frames returned in `obs`.

When the game ends or the attempt is stopped, keep the scorecard ID and recording, then call `arc.get_scorecard(card_id)` and `arc.close_scorecard(card_id)`. Report whether the game was won, levels completed, actions used, and whether the attempt ended early. A single-game online scorecard is not the aggregate competition result.
