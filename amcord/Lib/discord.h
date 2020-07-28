//
//  discord.h
//  DiscordRCPSwift
//
//  Created by Lucas Gusmão on 16/05/20.
//  Copyright © 2020 Lucas Alves Gusmão. All rights reserved.
//

#ifndef discord_h
#define discord_h

#include <stdio.h>
#include <stdbool.h>

void initializeDiscordSDK(void);
bool isDiscordSDKInitialized(void);
void destroyDiscordSDK(void);
void setSong(char songName[], char albumName[], char artistName[]);
void pauseSong(void);

#endif /* discord_h */
