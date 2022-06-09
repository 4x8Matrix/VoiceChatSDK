# VoiceChatSDK
## About
VoiceChatSDK brings new features to the roblox VoiceChat experience, I built this module because as of right now the only control developers actually have over VoiceChat is validation of voice chat. 
This SDK introduces a handle over VoiceChat that the developers can manipulate, there is two sides to this SDK; Server & Client which both have accesss to do different things and influence VoiceChat in different ways.

## Installation
<...>

## API Documentation
### Server API
#### Signals
##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerMuted
```

This event will be fired when a player is muted from the server, this even will **not** fire when a client decides to mute someone. 

---
##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerUnmuted
```

This event will be fired when a player is unmuted from the server, this even will **not** fire when a client decides to unmute someone. 

---
##### VoiceChatSDK.onVoiceChatClientsUpdated
```
<RBXScriptSignal> VoiceChatSDK.onVoiceChatClientsUpdated
```

This event will be fired when a player joins the participants inside of a VoiceChat. (This even will be fired when people who have VoiceChat join/leave the game.)

---
#### Functions
##### VoiceChatSDK.mutePlayerAsync
```
VoiceChatSDK.mutePlayerAsync(player<Player: Instance>)
```

This will mute the selected player for all players (if they have voice chat.)

---
##### VoiceChatSDK.unmutePlayerAsync
```
VoiceChatSDK.unmutePlayerAsync(player<Player: Instance>)
```

This will unmute the selected player for all players (if they have voice chat.)

---
##### VoiceChatSDK.getActiveVoiceChatPlayers
```
VoiceChatSDK.getActiveVoiceChatPlayers() -> table: { [number]: [player<Player: Instance>] 
```

Will return an array of all participants currently using VoiceChat

---
##### VoiceChatSDK.isVoiceEnabledForPlayer
```
VoiceChatSDK.isVoiceEnabledForPlayer(player<Player: Instance>) -> boolean
```

Server-Side validation for VoiceChat, roblox as is at this point doesn't allow the server to validate the existant of voice chat on players.

---

### Client API
<...>
