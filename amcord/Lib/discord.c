#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <unistd.h>
#include "discord_game_sdk.h"

#define DISCORD_REQUIRE(x) assert(x == DiscordResult_Ok)

struct Application {
    struct IDiscordCore* core;
    struct IDiscordActivityManager* activities;
    struct IDiscordApplicationManager* application;
    struct IDiscordActivityManager* activity_manager;
    DiscordUserId user_id;
};

void callbackData() {
    
}

void callback() {
    
}

struct Application app;
struct DiscordActivity activity;

char song[128];
char album[128];
char artist[128];
bool isInitialized = false;

char* safeString(char string[]) {
    if (strlen(string) > 128) {
        string[127] = '\0';
    }
    
    return string;
}

char* addEllipsis(char string[]) {
    string[126] = '.';
    string[125] = '.';
    string[124] = '.';
    
    return string;
}

void initializeDiscordSDK() {
    memset(&app, 0, sizeof(app));

    struct IDiscordActivityEvents activities_events;
    memset(&activities_events, 0, sizeof(activities_events));

    struct DiscordCreateParams params;
    DiscordCreateParamsSetDefault(&params);
    params.client_id = 711229975189127219;
    params.flags = DiscordCreateFlags_Default;
    params.event_data = &app;
    params.activity_events = &activities_events;
    
    memset(&activity, 0, sizeof(activity));
    strcpy(activity.assets.large_text, "made by @lucasalgus ❤️");
    strcpy(activity.assets.large_image, "amico");

    DiscordCreate(DISCORD_VERSION, &params, &app.core);

    app.activities = app.core->get_activity_manager(app.core);
    app.application = app.core->get_application_manager(app.core);
    app.activity_manager = app.core->get_activity_manager(app.core);
    
    printf("SDK Initialized ✅\n");
    isInitialized = true;
}

bool isDiscordSDKInitialized() {
    return isInitialized;
}

void destroyDiscordSDK() {
    app.core->destroy(app.core);
    printf("SDK Destroyed 🚫\n");
    isInitialized = false;
}

void updateSong(bool isPaused) {
    char songStr[1024];
    char artistStr[1024];
    if (isPaused) {
        strcpy(songStr, "⏸ ");
    } else {
        strcpy(songStr, "▶️ ");
    }
    strcat(songStr, song);
    strcat(songStr, " - ");
    strcat(songStr, album);
    
    strcpy(artistStr, "🥁 ");
    strcat(artistStr, artist);
    
    strcpy(activity.details, addEllipsis(safeString(songStr)));
    strcpy(activity.state, addEllipsis(safeString(artistStr)));
    
    app.activity_manager->update_activity(app.activity_manager, &activity, callbackData, callback);
    app.core->run_callbacks(app.core);
}

void setSong(char songName[], char albumName[], char artistName[], bool isPaused) {
    strcpy(song, safeString(songName));
    strcpy(album, safeString(albumName));
    strcpy(artist, safeString(artistName));

    updateSong(isPaused);
    printf("Song set 🎵\n");
}
