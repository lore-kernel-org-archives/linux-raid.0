From: Troy Telford <ttelford.groups@gmail.com>
Subject: RAID-6 disk superblock issue
Date: Tue, 13 Dec 2011 15:42:20 -0700
Message-ID: <jc8kca$mf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID-6 array I'm having trouble with:

md2 : active raid6 sdl1[6] sdh1[0] sdm1[5] sdk1[3] sdj1[2] sdi1[1]
      1953535488 blocks level 6, 128k chunk, algorithm 2 [6/5] [UUUU_U]
      [>....................]  recovery =  0.0% (27164/488383872) 
finish=599.1min speed=13582K/sec

- When the system boots (or when I attempt to build the array), I get a 
message that /dev/sdl and /dev/sdl1 have the same superblock, and that 
I should zero one.
- So, I zero the superblock using 'mdadm --zero-superblock /dev/sdl (or 
/dev/sdl1; doesn't matter which I use).
- I then re-add the device to the array (and the RAID-6 array recovers, 
as above.)
- The next time I boot, I get the exact same error message.


- It doesn't seem to matter which (between the device or the partition) 
that I zero the superblock on.  I get the same error message at boot 
(when the drive is being assembled).
- Since it's redundant data anyway, I've tried dd'ing from /dev/zero 
over the drive, repartitioning the drive, and then adding the drive to 
the array. Same behavior.

- My mdadm.conf just has the array itself, and the array's UUID. It 
doesn't explicitly list devices.

So what am I missing? There's got to be a way I can get the array to 
assemble at boot, instead of having to manually --zero-superblock every 
time.
-- 
Troy Telford


