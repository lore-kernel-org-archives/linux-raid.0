From: "Eric Wood" <eric@interplas.com>
Subject: Converting a non-RAID RedHat System to run on Software RAID
Date: Tue, 9 Sep 2003 14:17:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <107a01c376fe$a29bdc00$9100000a@intgrp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I frequently want to convert an existing single drive install of RH linux
into a mirrored RAID-1 set.  So I thought I found the holy grail:

http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-4.html#ss4.14

However, it is slightly out dated (RH 7.1 days).  Since I'm trying to mirror
RH 9, I have several questions based on this HOWTO:

1. Sect. 4.14.6: /dev/md0 already existed while in rescue mode.  Ignored it,
no problem
2. Sect. 4.14.7: I could not umount /mnt/sysimage to save my life.  Looking
at what was mounted, I seen that I needed to also umount
/mnt/sysimage/dev/pts.  I cd'd into the / directory to make sure I wasn't
holding the unmount up.  So I could not proceed with the howto.

3. Sect. 4.14.11,12 should be updated to include grub.

4. Sect. 4.14.14.  Do I first have to convert from ext3 back to ext2? Since
I use ext3 does this step still apply or does mkraid at the second
superblock in an acceptable manor for ext3?  Do I still have to resize2fs
the md devices?

Any info I gather, I will relay to the howto author and hopefully he'll come
out with an update.
thanks,
-eric wood

