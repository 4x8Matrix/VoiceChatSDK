# VoiceChatSDK
## About
VoiceChatSDK brings new features to the roblox VoiceChat experience, 
I built this module because as of right now the only control developers actually have over VoiceChat is validation of voice chat. 
This SDK introduces a handle over VoiceChat that the developers can manipulate, there is two sides to this SDK; 
Server & Client which both have accesss to do different things and influence VoiceChat in different ways.

## Installation
Head on over to [Releases](https://github.com/4x8Matrix/VoiceChatSDK/releases/) and follow the instructions on the release page. 

## API Documentation
### Server API
#### Signals
##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerMuted
```

This event will be fired when a player is muted from the server, this even will **not** fire when a client decides to mute someone. 

##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerUnmuted
```

This event will be fired when a player is unmuted from the server, this even will **not** fire when a client decides to unmute someone. 

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

##### VoiceChatSDK.unmutePlayerAsync
```
VoiceChatSDK.unmutePlayerAsync(player<Player: Instance>)
```

This will unmute the selected player for all players (if they have voice chat.)

##### VoiceChatSDK.getActiveVoiceChatPlayers
```
VoiceChatSDK.getActiveVoiceChatPlayers() -> table: { [number]: [player<Player: Instance>] }
```

Will return an array of all participants currently using VoiceChat

#### VoiceChatSDK.isVoiceEnabledForPlayer
```
VoiceChatSDK.isVoiceEnabledForPlayer(player<Player: Instance>) -> boolean
```

Server-Side validation for VoiceChat, roblox as is at this point doesn't allow the server to validate the existant of voice chat on players.

---

### Client API
##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerMuted
```

This event will be fired when a player is muted from the server, this even will **not** fire when a client decides to mute someone. 

##### VoiceChatSDK.onPlayerMuted
```
<RBXScriptSignal> VoiceChatSDK.onPlayerUnmuted
```

This event will be fired when a player is unmuted from the server, this even will **not** fire when a client decides to unmute someone. 

##### VoiceChatSDK.onVoiceChatClientsUpdated
```
<RBXScriptSignal> VoiceChatSDK.onVoiceChatClientsUpdated
```

This event will be fired when a player joins the participants inside of a VoiceChat. (This even will be fired when people who have VoiceChat join/leave the game.)

##### VoiceChatSDK.onPlayerVolumeChanged
```
<RBXScriptSignal> VoiceChatSDK.onPlayerVolumeChanged
```

This event will be fired when a player's voice chat volume is changed

##### VoiceChatSDK.onVoiceClientAdded
```
<RBXScriptSignal> VoiceChatSDK.onPlayerUnmuted
```

This event will be fired when a player has been added to the voice chat participants

##### VoiceChatSDK.onVoiceClientRemoved
```
<RBXScriptSignal> VoiceChatSDK.onVoiceChatClientsUpdated
```

This event will be fired when a player has been removed to the voice chat participants

---
#### Functions
##### VoiceChatSDK.playerHasVoiceChat
```
VoiceChatSDK.playerHasVoiceChat(player<Player: Instance>) -> boolean
```

Validate is that player has VoiceChat enabled

##### VoiceChatSDK.setVoiceChatChannel
```
VoiceChatSDK.setVoiceChatChannel(channel<string: "Left", "Right", "Center">)
```

Modify the stereo channel which the VoiceChat sounds will be heard from, meaning you can play sounds from your right, left and center.

##### VoiceChatSDK.setPlayerEmitter
```
VoiceChatSDK.setPlayerEmitter(emitter<Part: Instance>)
```

Choose an object to emit the VoiceChat audio from, this will allow you to animate certain objects with voice chat.

#### VoiceChatSDK.getClientAsync
```
VoiceChatSDK.getClientAsync(player<Player: Instance>) -> VoiceChatClient
```

More used internally, however you can get the VoiceChatClient which you can call functions such as `:mute` directly on

#### VoiceChatSDK.isPlayerMuted
```
VoiceChatSDK.isPlayerMuted(player<Player: Instance>) -> boolean
```

Will return a boolean depending on weather or not the player is muted.

#### VoiceChatSDK.mutePlayer
```
VoiceChatSDK.mutePlayer(player<Player: Instance>)
```

Will mute a player

#### VoiceChatSDK.unmutePlayer
```
VoiceChatSDK.unmutePlayer(player<Player: Instance>)
```

Will unmute a player

#### VoiceChatSDK.setPlayerVolume
```
VoiceChatSDK.setPlayerVolume(player<Player: Instance>, volume<Number: 0-10>)
```

Set a players volume, 0 being the quietest & 10 being the loudest

#### VoiceChatSDK.getActiveVoiceChatPlayers
```
VoiceChatSDK.getActiveVoiceChatPlayers(player<Player: Instance>) -> table: { [number]: [player<Player: Instance>] }
```

Will return an array of all participants currently using VoiceChat
