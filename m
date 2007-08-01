From: ymerej@yerot.com
Subject: possibility of using raid5 to detect hd corruption?
Date: Wed, 1 Aug 2007 16:28:09 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0708011627090.22394@yerot.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Raid Gurus,

I have a need to determine whether a linux partion has been corrupted (say 
by s/w running amok on a window partition).  I think that it should be 
possible to detect this by having two raid5 linux partitions attempt to 
sync and then check whether any error was reported via a mismatching 
parity.     I'm using mdadm 1.6 (CentOS 4.4).  Can someone tell me what 
commands could be used for this?

If my linux raid5 drives are /dev/sda1 and /dev/sdb1

Would something like the following work?

#force resync
mdadm --fail /dev/md0 /dev/sdb1
mdadm --remove /dev/md0 /dev/sdb1
mdadm --add /dev/md0 /dev/sdb1

#then check for an error?
/sys/block/md0/stat

Since the raid drive is configured for auto checking during boot-up would 
that set any flag in the /sys/block/md0/stat file that I could use?

I'm just trying to avoid creating a bunch of checksums... (takes about 10 
minutes to create/check checksums on my 20GB drive).

Regards
