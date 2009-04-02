From: estr4ng3d <e5tr4ng3d@yahoo.com>
Subject: RAID5 volumes suddenly lost superblock and show weird hexdump
 patterns
Date: Thu, 2 Apr 2009 07:25:57 -0700 (PDT)
Message-ID: <22849175.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I got some of my RAID5 array volumes damaged. I have no idea what happened, I
was simply trying to manually assemble them after a reboot, only to discover
they are no longer recognized by mdadm as containing a superblock.

What's interesting and really weird (to my humble knowledge at least) is
that hexdumps show interesting patterns. http://pastebin.com/m494e69c0
Obviously far from being random garbage (hence I'm ruling out media damage).
Does RAID create this sort of data sequences as part of its operation? Could
this have been deliberate overwriting of my volumes?

I'm desperately trying to recover data on this array. Any help/pointers
appreciated!

Thanks
-- 
View this message in context: http://www.nabble.com/RAID5-volumes-suddenly-lost-superblock-and-show-weird-hexdump-patterns-tp22849175p22849175.html
Sent from the linux-raid mailing list archive at Nabble.com.

