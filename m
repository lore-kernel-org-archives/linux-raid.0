From: Peter Kieser <peter@kieser.ca>
Subject: Mixing 512-byte sector, and 4096-byte sector drives
Date: Mon, 22 Mar 2010 16:39:21 -0700
Message-ID: <4BA7FFA9.7040303@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a 6-drive RAID6 of WD15EADS (512-byte sector) drives. One of the 
drives is failing, and I have been forced to buy a WD15EARS (4096-byte 
sector) drive to replace the failing drive, and it has the new "advanced 
format" technology.

Do I need to set the "XP" jumper on pins 7-8 to play nicely with the 
other 512-byte sector drives in my array, or will mdraid be okay with 
the 4096-byte sector drive? Will there be a performance penalty adding 
the drive to my array?

Thank you,

-Peter
