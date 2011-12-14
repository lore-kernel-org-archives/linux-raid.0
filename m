From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID-6 disk superblock issue
Date: Wed, 14 Dec 2011 14:01:01 -0500
Message-ID: <4EE8F26D.7010608@turmel.org>
References: <jc8kca$mf$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <jc8kca$mf$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Troy Telford <ttelford.groups@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Troy,

On 12/13/2011 05:42 PM, Troy Telford wrote:
> I have a RAID-6 array I'm having trouble with:
> 
> md2 : active raid6 sdl1[6] sdh1[0] sdm1[5] sdk1[3] sdj1[2] sdi1[1]
>      1953535488 blocks level 6, 128k chunk, algorithm 2 [6/5] [UUUU_U]
>      [>....................]  recovery =  0.0% (27164/488383872) finish=599.1min speed=13582K/sec
> 
> - When the system boots (or when I attempt to build the array), I get a message that /dev/sdl and /dev/sdl1 have the same superblock, and that I should zero one.
> - So, I zero the superblock using 'mdadm --zero-superblock /dev/sdl (or /dev/sdl1; doesn't matter which I use).
> - I then re-add the device to the array (and the RAID-6 array recovers, as above.)
> - The next time I boot, I get the exact same error message.
> 
> 
> - It doesn't seem to matter which (between the device or the partition) that I zero the superblock on.  I get the same error message at boot (when the drive is being assembled).
> - Since it's redundant data anyway, I've tried dd'ing from /dev/zero over the drive, repartitioning the drive, and then adding the drive to the array. Same behavior.
> 
> - My mdadm.conf just has the array itself, and the array's UUID. It doesn't explicitly list devices.
> 
> So what am I missing? There's got to be a way I can get the array to assemble at boot, instead of having to manually --zero-superblock every time.

Let me guess:  You have version 0.90 superblock, and sdl1 covers the whole device?

Short term, change your mdadm.conf to only accept device names that end with a digit.  Like so:

DEVICE /dev/sd[a-z][1-9]

Then rebuild your initramfs to include the new mdadm.conf.

Long term, rebuild your array with v1.x metadata.

HTH,

Phil
