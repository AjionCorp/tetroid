# Steam Integration Guide

## 🎮 Overview

This document covers integrating Tetroid with Steam's features including authentication, matchmaking, achievements, leaderboards, and more.

## 📋 Prerequisites

### Required
- **Steam Partner Account** ([partner.steamgames.com](https://partner.steamgames.com))
- **App ID** (Assigned by Steam)
- **Steamworks SDK** (Latest version)
- **Steam Client** installed for testing

### Development Setup
1. Download Steamworks SDK from Steamworks portal
2. Extract to `third_party/steamworks/`
3. Configure App ID in `steam_appid.txt` (for local testing)
4. Install Godot Steam plugin or Unity Steam integration

## 🔑 Authentication

### Steam Account Linking

```gdscript
class_name SteamAuth

signal auth_completed(success: bool, steam_id: int)
signal auth_failed(error: String)

var is_steam_initialized: bool = false
var steam_id: int = 0
var steam_username: String = ""

func initialize_steam() -> bool:
    """Initialize Steam API"""
    if OS.has_feature("standalone"):
        # Check if Steam is running
        if not Steam.isSteamRunning():
            push_error("Steam is not running!")
            return false
        
        # Initialize Steam API
        var init_result = Steam.steamInit()
        if init_result.status != 1:
            push_error("Failed to initialize Steam: " + str(init_result.verbal))
            return false
        
        is_steam_initialized = true
        steam_id = Steam.getSteamID()
        steam_username = Steam.getPersonaName()
        
        print("Steam initialized successfully")
        print("Steam ID: " + str(steam_id))
        print("Username: " + steam_username)
        
        return true
    else:
        push_warning("Steam not available in this build")
        return false

func authenticate_with_backend() -> void:
    """Authenticate with game backend using Steam token"""
    # Get session ticket
    var ticket = Steam.getAuthSessionTicket()
    
    if ticket.ticket_size > 0:
        # Convert ticket to hex string
        var ticket_hex = _bytes_to_hex(ticket.ticket)
        
        # Send to backend for validation
        var http = HTTPRequest.new()
        add_child(http)
        http.request_completed.connect(_on_backend_auth_completed)
        
        var url = BACKEND_URL + "/auth/steam"
        var headers = ["Content-Type: application/json"]
        var body = JSON.stringify({
            "steam_id": steam_id,
            "ticket": ticket_hex
        })
        
        http.request(url, headers, HTTPClient.METHOD_POST, body)
    else:
        emit_signal("auth_failed", "Failed to get auth ticket")

func _on_backend_auth_completed(result, response_code, headers, body):
    if response_code == 200:
        var json = JSON.parse_string(body.get_string_from_utf8())
        if json and json.has("token"):
            # Store JWT token for future API calls
            GlobalAuth.jwt_token = json.token
            emit_signal("auth_completed", true, steam_id)
        else:
            emit_signal("auth_failed", "Invalid response from server")
    else:
        emit_signal("auth_failed", "HTTP " + str(response_code))
```

### Backend Validation (Python)

```python
from steam.webapi import WebAPI
import os

class SteamAuthenticator:
    def __init__(self):
        self.api_key = os.getenv("STEAM_WEB_API_KEY")
        self.api = WebAPI(key=self.api_key)
    
    def validate_ticket(self, steam_id: int, ticket_hex: str) -> bool:
        """
        Validate Steam authentication ticket
        """
        try:
            # Call Steam Web API to verify ticket
            response = self.api.ISteamUserAuth.AuthenticateUserTicket(
                appid=YOUR_APP_ID,
                ticket=ticket_hex
            )
            
            if response.params:
                # Check if steam_id matches
                if int(response.params.steamid) == steam_id:
                    return True
                else:
                    print(f"Steam ID mismatch: {response.params.steamid} != {steam_id}")
                    return False
            else:
                print("Invalid ticket response")
                return False
                
        except Exception as e:
            print(f"Ticket validation error: {e}")
            return False
```

## 🎯 Achievements

### Achievement Definition

```json
// achievements.json
{
  "achievements": [
    {
      "id": "FIRST_BLOOD",
      "name": "First Blood",
      "description": "Win your first match",
      "icon": "achievement_first_blood.jpg",
      "icon_gray": "achievement_first_blood_gray.jpg",
      "hidden": false
    },
    {
      "id": "PERFECTIONIST",
      "name": "Perfectionist",
      "description": "Win a match without taking any damage",
      "icon": "achievement_perfectionist.jpg",
      "icon_gray": "achievement_perfectionist_gray.jpg",
      "hidden": false
    },
    {
      "id": "COMBO_MASTER",
      "name": "Combo Master",
      "description": "Chain 5 block abilities in one match",
      "icon": "achievement_combo_master.jpg",
      "icon_gray": "achievement_combo_master_gray.jpg",
      "hidden": false
    },
    {
      "id": "SECRET_ACHIEVEMENT",
      "name": "???",
      "description": "???",
      "icon": "achievement_secret.jpg",
      "icon_gray": "achievement_secret_gray.jpg",
      "hidden": true
    }
  ]
}
```

### Achievement Implementation

```gdscript
class_name AchievementManager

const ACHIEVEMENTS = {
    "FIRST_BLOOD": {
        "name": "ACH_FIRST_BLOOD",
        "unlocked": false
    },
    "PERFECTIONIST": {
        "name": "ACH_PERFECTIONIST",
        "unlocked": false
    },
    "COMBO_MASTER": {
        "name": "ACH_COMBO_MASTER",
        "unlocked": false
    },
    # ... more achievements
}

func unlock_achievement(achievement_id: String) -> void:
    """Unlock a Steam achievement"""
    if not Steam.isSteamRunning():
        return
    
    if ACHIEVEMENTS.has(achievement_id):
        var ach = ACHIEVEMENTS[achievement_id]
        
        # Check if already unlocked
        if ach.unlocked:
            return
        
        # Unlock on Steam
        Steam.setAchievement(ach.name)
        Steam.storeStats()
        
        # Mark as unlocked locally
        ach.unlocked = true
        
        # Show notification
        _show_achievement_notification(achievement_id)
        
        print("Achievement unlocked: " + achievement_id)

func check_achievement_conditions():
    """Called after match end to check for achievements"""
    var match_data = MatchManager.get_last_match_data()
    
    # Check First Blood
    if match_data.won and not ACHIEVEMENTS["FIRST_BLOOD"].unlocked:
        unlock_achievement("FIRST_BLOOD")
    
    # Check Perfectionist
    if match_data.won and match_data.damage_taken == 0:
        unlock_achievement("PERFECTIONIST")
    
    # Check Combo Master
    if match_data.max_ability_chain >= 5:
        unlock_achievement("COMBO_MASTER")
    
    # ... check more achievements

func get_achievement_progress() -> Dictionary:
    """Get current achievement progress"""
    var progress = {}
    
    for ach_id in ACHIEVEMENTS:
        var unlocked = Steam.getAchievement(ACHIEVEMENTS[ach_id].name)
        progress[ach_id] = {
            "unlocked": unlocked.achieved,
            "unlock_time": unlocked.unlock_time
        }
    
    return progress
```

## 📊 Leaderboards

### Leaderboard Setup

```gdscript
class_name LeaderboardManager

const LEADERBOARDS = {
    "RANKED_1V1": "tetroid_ranked_1v1",
    "RANKED_2V2": "tetroid_ranked_2v2",
    "HIGH_SCORE": "tetroid_high_score",
    "FASTEST_WIN": "tetroid_fastest_win"
}

signal leaderboard_loaded(entries: Array)
signal score_uploaded(success: bool)

func upload_score(leaderboard_id: String, score: int, details: Array = []) -> void:
    """Upload score to Steam leaderboard"""
    if not Steam.isSteamRunning():
        return
    
    var leaderboard_name = LEADERBOARDS[leaderboard_id]
    
    # Find leaderboard
    Steam.findLeaderboard(leaderboard_name)
    await Steam.leaderboard_find_result
    
    # Upload score
    Steam.uploadLeaderboardScore(score, true, details)
    await Steam.leaderboard_score_uploaded
    
    emit_signal("score_uploaded", true)
    print("Score uploaded to leaderboard: " + leaderboard_id)

func download_leaderboard(
    leaderboard_id: String,
    request_type: String = "global",  # "global", "friends", "around_user"
    range_start: int = 0,
    range_end: int = 10
) -> void:
    """Download leaderboard entries"""
    if not Steam.isSteamRunning():
        return
    
    var leaderboard_name = LEADERBOARDS[leaderboard_id]
    
    # Find leaderboard
    Steam.findLeaderboard(leaderboard_name)
    var result = await Steam.leaderboard_find_result
    
    if result.found == 0:
        push_error("Leaderboard not found: " + leaderboard_name)
        return
    
    # Download entries
    match request_type:
        "global":
            Steam.downloadLeaderboardEntries(range_start, range_end, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL)
        "friends":
            Steam.downloadLeaderboardEntries(0, 0, Steam.LEADERBOARD_DATA_REQUEST_FRIENDS)
        "around_user":
            Steam.downloadLeaderboardEntries(-5, 5, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL_AROUND_USER)
    
    var entries_result = await Steam.leaderboard_scores_downloaded
    
    # Process entries
    var entries = []
    for entry in entries_result.entries:
        entries.append({
            "rank": entry.global_rank,
            "steam_id": entry.steam_id,
            "username": Steam.getFriendPersonaName(entry.steam_id),
            "score": entry.score,
            "details": entry.details
        })
    
    emit_signal("leaderboard_loaded", entries)
```

## 👥 Friend System

### Steam Friends Integration

```gdscript
class_name SteamFriendsManager

func get_friends_list() -> Array:
    """Get list of Steam friends"""
    var friends = []
    var friend_count = Steam.getFriendCount(Steam.FRIEND_FLAG_IMMEDIATE)
    
    for i in range(friend_count):
        var friend_id = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
        var friend_name = Steam.getFriendPersonaName(friend_id)
        var friend_status = Steam.getFriendPersonaState(friend_id)
        var game_info = Steam.getFriendGamePlayed(friend_id)
        
        var is_playing_tetroid = false
        if game_info.id == YOUR_APP_ID:
            is_playing_tetroid = true
        
        friends.append({
            "steam_id": friend_id,
            "name": friend_name,
            "status": _get_status_string(friend_status),
            "playing_tetroid": is_playing_tetroid,
            "avatar": Steam.getSmallFriendAvatar(friend_id)
        })
    
    return friends

func invite_friend_to_game(friend_steam_id: int, lobby_id: String) -> void:
    """Send game invite to friend"""
    # Set rich presence for invite
    Steam.setRichPresence("connect", lobby_id)
    
    # Invite friend
    Steam.inviteUserToGame(friend_steam_id, "join_lobby:" + lobby_id)
    
    print("Invited friend " + str(friend_steam_id) + " to lobby " + lobby_id)

func _get_status_string(status: int) -> String:
    match status:
        Steam.PERSONA_STATE_OFFLINE: return "Offline"
        Steam.PERSONA_STATE_ONLINE: return "Online"
        Steam.PERSONA_STATE_BUSY: return "Busy"
        Steam.PERSONA_STATE_AWAY: return "Away"
        Steam.PERSONA_STATE_SNOOZE: return "Snooze"
        _: return "Unknown"
```

## 🎮 Steam Networking

### Lobby System

```gdscript
class_name SteamLobbyManager

signal lobby_created(lobby_id: int)
signal lobby_joined(lobby_id: int)
signal lobby_list_updated(lobbies: Array)

func create_lobby(lobby_type: String, max_players: int) -> void:
    """Create a Steam lobby"""
    var lobby_type_enum
    match lobby_type:
        "private":
            lobby_type_enum = Steam.LOBBY_TYPE_PRIVATE
        "friends_only":
            lobby_type_enum = Steam.LOBBY_TYPE_FRIENDS_ONLY
        "public":
            lobby_type_enum = Steam.LOBBY_TYPE_PUBLIC
        _:
            lobby_type_enum = Steam.LOBBY_TYPE_PUBLIC
    
    Steam.createLobby(lobby_type_enum, max_players)
    var result = await Steam.lobby_created
    
    if result.status == 1:  # Success
        var lobby_id = result.lobby_id
        
        # Set lobby data
        Steam.setLobbyData(lobby_id, "name", "Tetroid Match")
        Steam.setLobbyData(lobby_id, "game_mode", "1v1")
        Steam.setLobbyData(lobby_id, "version", GlobalConfig.GAME_VERSION)
        
        emit_signal("lobby_created", lobby_id)
        print("Lobby created: " + str(lobby_id))
    else:
        push_error("Failed to create lobby")

func join_lobby(lobby_id: int) -> void:
    """Join a Steam lobby"""
    Steam.joinLobby(lobby_id)
    var result = await Steam.lobby_joined
    
    if result.status == 1:  # Success
        emit_signal("lobby_joined", lobby_id)
        print("Joined lobby: " + str(lobby_id))
    else:
        push_error("Failed to join lobby")

func find_lobbies(filters: Dictionary = {}) -> void:
    """Search for available lobbies"""
    # Apply filters
    if filters.has("game_mode"):
        Steam.addRequestLobbyListStringFilter("game_mode", filters.game_mode, Steam.LOBBY_COMPARISON_EQUAL)
    
    if filters.has("has_slots"):
        Steam.addRequestLobbyListNearValueFilter("slots_available", 1)
    
    # Request lobby list
    Steam.requestLobbyList()
    var result = await Steam.lobby_match_list
    
    var lobbies = []
    for i in range(result.lobbies):
        var lobby_id = Steam.getLobbyByIndex(i)
        var lobby_data = {
            "id": lobby_id,
            "name": Steam.getLobbyData(lobby_id, "name"),
            "game_mode": Steam.getLobbyData(lobby_id, "game_mode"),
            "num_members": Steam.getNumLobbyMembers(lobby_id),
            "max_members": Steam.getLobbyMemberLimit(lobby_id)
        }
        lobbies.append(lobby_data)
    
    emit_signal("lobby_list_updated", lobbies)
```

## 📈 Stats Tracking

### Steam Stats

```gdscript
class_name SteamStatsManager

const STATS = {
    "matches_played": "stat_matches_played",
    "matches_won": "stat_matches_won",
    "blocks_placed": "stat_blocks_placed",
    "abilities_used": "stat_abilities_used",
    "total_damage_dealt": "stat_damage_dealt",
    "total_playtime": "stat_playtime_seconds"
}

func update_stat(stat_id: String, value: int, is_increment: bool = true) -> void:
    """Update a Steam stat"""
    if not Steam.isSteamRunning():
        return
    
    var stat_name = STATS[stat_id]
    
    if is_increment:
        # Get current value and add to it
        var current = Steam.getStatInt(stat_name)
        Steam.setStatInt(stat_name, current + value)
    else:
        # Set absolute value
        Steam.setStatInt(stat_name, value)
    
    # Store stats
    Steam.storeStats()

func get_stat(stat_id: String) -> int:
    """Get current value of a stat"""
    if not Steam.isSteamRunning():
        return 0
    
    var stat_name = STATS[stat_id]
    return Steam.getStatInt(stat_name)

func update_match_stats(match_data: Dictionary) -> void:
    """Update stats after a match"""
    update_stat("matches_played", 1)
    
    if match_data.won:
        update_stat("matches_won", 1)
    
    update_stat("blocks_placed", match_data.blocks_placed)
    update_stat("abilities_used", match_data.abilities_used)
    update_stat("total_damage_dealt", match_data.damage_dealt)
    update_stat("total_playtime", int(match_data.duration))
```

## 💾 Cloud Saves

```gdscript
class_name SteamCloudManager

func save_to_cloud(filename: String, data: Dictionary) -> bool:
    """Save player data to Steam Cloud"""
    if not Steam.isSteamRunning() or not Steam.isCloudEnabledForAccount():
        return false
    
    # Convert to JSON
    var json_str = JSON.stringify(data)
    var bytes = json_str.to_utf8_buffer()
    
    # Write to Steam Cloud
    var success = Steam.fileWrite(filename, bytes)
    
    if success:
        print("Saved to Steam Cloud: " + filename)
        return true
    else:
        push_error("Failed to save to Steam Cloud: " + filename)
        return false

func load_from_cloud(filename: String) -> Dictionary:
    """Load player data from Steam Cloud"""
    if not Steam.isSteamRunning():
        return {}
    
    # Check if file exists
    if not Steam.fileExists(filename):
        print("File not found in Steam Cloud: " + filename)
        return {}
    
    # Get file size
    var size = Steam.getFileSize(filename)
    
    if size == 0:
        return {}
    
    # Read file
    var bytes = Steam.fileRead(filename, size)
    var json_str = bytes.get_string_from_utf8()
    
    # Parse JSON
    var data = JSON.parse_string(json_str)
    
    if data:
        print("Loaded from Steam Cloud: " + filename)
        return data
    else:
        push_error("Failed to parse Steam Cloud data: " + filename)
        return {}
```

## 🛠️ Testing Steam Integration

### Test Without Steam

```gdscript
class_name MockSteamAPI

# For testing when Steam is not available
var mock_steam_id: int = 76561198000000000
var mock_username: String = "TestPlayer"
var mock_achievements: Dictionary = {}

func isSteamRunning() -> bool:
    return false  # Force mock mode

func initialize():
    print("Using Mock Steam API")

func getSteamID() -> int:
    return mock_steam_id

func getPersonaName() -> String:
    return mock_username

func setAchievement(name: String) -> void:
    mock_achievements[name] = true
    print("Mock: Achievement unlocked - " + name)
```

### Local Testing

Create `steam_appid.txt` in project root:
```
480  # Use Spacewar (480) for testing
```

## 📋 Checklist for Steam Release

### Pre-Launch
- [ ] Steam Partner account created
- [ ] App ID obtained
- [ ] Store page created
- [ ] Screenshots uploaded (at least 5)
- [ ] Trailers uploaded
- [ ] Achievements defined (icons uploaded)
- [ ] Leaderboards configured
- [ ] Trading cards designed (optional)
- [ ] Community features enabled
- [ ] Age rating obtained
- [ ] Price set for each region
- [ ] Release date scheduled

### Technical
- [ ] Steamworks SDK integrated
- [ ] Authentication working
- [ ] Achievements unlocking
- [ ] Leaderboards functional
- [ ] Cloud saves working
- [ ] Steam Networking tested
- [ ] Overlay working
- [ ] Controller support
- [ ] Big Picture mode tested

### Legal
- [ ] EULA agreed
- [ ] Tax forms submitted
- [ ] Bank information provided
- [ ] Content descriptors filled
- [ ] VAT/GST configured

---

**Last Updated**: 2026-01-05
**Status**: Complete Guide
**Version**: 1.0.0
