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

void initializeDiscordSDK(void);
void destroyDiscordSDK(void);
void playSong(char songName[], char albumName[], char artistName[]);
void pauseSong(void);

#endif /* discord_h */
