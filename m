From: "BO MOON" <bmoon@anthologysolutions.com>
Subject: RE: new superblock and raid10 support in mdadm
Date: Wed, 22 Dec 2004 14:30:49 -0800
Message-ID: <000201c4e875$e654c7b0$6d01a8c0@asitest>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@cse.unsw.edu.au>, 'rich turner' <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again,

I will re-iterate my question for raid10 or raid01.
1.  Is raid10.c in ONLY linux2.6.xx? no support for 2.4.xx?
2.  Does raid10.c support for RAID10 only? Or for both raid10 and
raid01?
3.  we can build raid10 or raid01 on linux2.4.xx without raid10.c code.
    What issues or bugs does this code take care of?
4.  What rev of mdadm should be used for raid10? Mdadm1.7 or greater?


Thx,

Bo

-----Original Message-----
From: BO MOON [mailto:bmoon@anthologysolutions.com] 
Sent: Wednesday, December 22, 2004 10:59 AM
To: 'Neil Brown'; 'rich turner'
Cc: 'linux-raid@vger.kernel.org'
Subject: RE: new superblock and raid10 support in mdadm

Hello,

I noticed some discussions on last September email log,
But I am not sure.

I tried to make RAID10 or RAID01. I could make it but
Problem is that I could not assemble it by "mdadm -As"
When the system is rebooted.

My "mdadm.conf" is

    DEVICE /dev/hd*
    ARRAY /dev/md0 level=raid1 num-devices=2 devices=/dev/hda4,/dev/hdc4
    ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/hde4,/dev/hdg4
    ARRAY /dev/md2 level=raid0 num-devices=2 devices=/dev/md0,/dev/md1

My S/W revs are:

Linux 2.4.20
Mdadm 1.2.0

My HDD size are all greater than 120 GB.

I tried it manually, too: first assemble the RAID1: md0 and md1.
Then tried to assemble "md2" but it said "could not find devices for
md2"

We do not support RAID10 or RAID01 on linux2.4.xx?  
or any issues on mdadm? 

Please provide me any clues or advices,

Bo


