From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: 3ware 7500-8 confusion
Date: Sat, 22 Feb 2003 21:08:04 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
List-Id: linux-raid.ids


hi ya Raiders

okay... i confess ... i'm lost and confused ...

we have a dual amd mb + 9 drive bays w/ 200GB drives

the drives are connected to a 3ware 7500-8
and the drives is recognized during bios bootup and linux-2.4.19/20
bootup recognized the controller too

the 3ware bios created the raid array out of the 8 drives
( supposedly .. waited a long time for it to finish )

3dm was installed from the cdrom that came w/ the controller

http://localhost:1080
	- shows the list of drives in the raid
	- shows the other info abut the 3ware card

but now that i wanna use the hw raid, and want to do:
	fdisk /dev/md0
	mke2fsc -j -m 1 /dev/md0
	mount /dev/md0 /Raid

but there is no such thing as /dev/md0 ... *pout*

what is the name of the device ( /dev/xxx ) that 3ware built ??
	- went digging/googling around but didnt find my answer yet

	for freebsd ... i think its /dev/twed

-- if its supposed to be /dev/md0 ... guess some step along the
   way is missing in the steps i did to configure the 3ware 7500-8 card

	-- ie .. i dont see the 3ware bios section that allows
	a JBOD vs raid5 either... so its defaulted to raid5 for now
 
-- after all this is done .. guess i'll have to write up another 
   itty-bitty 3ware-raid-howto

thanx
alvin

