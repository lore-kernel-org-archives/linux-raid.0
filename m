From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Highpoint 1820A
Date: Sat, 17 Sep 2005 07:19:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0509170714560.21650@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.

I have struggled with an 1820A for a while, trying to verify it's properly 
functioning and failing. Does anyone have a success story with this card 
under linux?

Quite a long story.

First I download the linux package, flash the controller with the attached 
BIOS, compile the driver etc, everything looks fine. I create the raid, I 
sync it up, write to it, everything looks fine and dandy. Then I pull a 
drive, it's properly detected, I replug it and that's also detected. I 
start a rebuild in the CLI under linux and it starts resyncing. After 
resyuncing the computer just freezes, the very instant after it says 
"rebuild complete". After some contact with support@highpoint I end up 
installing XP and trying it there. I have to reflash into a windows 
BIOS on the 1820A, but then it works perfectly.

I then re-install linux and run the linux driver on the windows BIOS. Now 
it's rebuild properly, but after I try to use the verify command, it says 
"inconsistant" and starts rebuilding again. This can be done three times 
in a row, it never seems to be consistant.

That's my current situation. I am currently trying software RAID5 instead, 
we'll see if that works better.

I would be very happy to hear from anyone with good experience with this 
and their open source driver, and hear what configuration you're using and 
if you had to do anything special.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
