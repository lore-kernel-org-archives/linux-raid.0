From: Rick Bragg <lists@gmnet.net>
Subject: fsck problems.  Can't restore raid
Date: Fri, 25 Dec 2009 20:33:47 -0500
Message-ID: <1261791227.10448.88.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a raid 10 array and for some reason the system went down and I
can't get it back.  

during re-boot, I get the following error:

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate
superblock:
    e2fsck -b 8193 <device>

I have tried everything I can think of and I can't seem to do an fsck or
repair the file system.

what can I do?

Thanks
Rick



