# claude-agent-identity

A Claude Code plugin that gives each new session an agent handle, such as `cc-swift-koala-42`. The handle reaches the model as session context, so the agent can sign commits, pull requests, and messages with a name that identifies the session.

It is the Claude Code counterpart of [pi-agent-identity](https://github.com/elecnix/pi-agent-identity) and draws from the same word lists: 40 adjectives, 40 animals, and a number from 00 to 99.

## Install

The [elecnix/claude-plugins](https://github.com/elecnix/claude-plugins) marketplace lists the plugin. Add that marketplace once, then install the plugin from it:

```sh
claude plugin marketplace add elecnix/claude-plugins
claude plugin install agent-identity@elecnix-plugins
```

The plugin needs `bash` and `jq`.

## What it does

A `SessionStart` hook runs on `startup` and `clear`. It prints JSON that adds one line to the session context:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Your agent handle is cc-swift-koala-42."
  }
}
```

The `cc-` prefix tells a Claude Code handle apart from a pi handle.

## Keeping a handle stable

The hook stores each handle in `~/.claude/handles/<session_id>`. A second run for the same session reads that file instead of drawing again. A draw that matches a stored handle is repeated, up to 10 times.

The hook also creates a marker directory per session and start source. If you list the hook in more than one settings file, only the first run prints the line. The model sees the handle once.

Set `CLAUDE_AGENT_IDENTITY_DIR` to store handles somewhere else.

## Limits

- The hook adds a line to the context. It does not change the system prompt.
- A session that already receives a handle another way, such as in a spawn prompt, sees two handles.
- The draw is random. Two sessions on different machines can pick the same handle.

## License

MIT
