From: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 13:01:33 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00f601c2cafe$4f4dd500$6701a8c0@bc.hsia.telus.net>
References: <Pine.LNX.4.33.0302021607270.17543-100000@router.windsormachine.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike,

I could not get the md0 to resync / reinitialize
raidstop / raidstart / etc...

so I am unable to do fsck /dev/md0
I was thinking if I could get one drive to work I could wipe the other one,
and then rebuild the pair, no??

aj




----- Original Message -----
From: "Mike Dresser" <mdresser_l@windsormachine.com>
To: "Adam J Morand" <Adam.Morand@illuminatedtechnologies.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, February 02, 2003 1:08 PM
Subject: Re: RAID 1 / Power Loss / No SuperBlock



On Sun, 2 Feb 2003, Adam J Morand wrote:

> The error I get
> [aj@r2d2 aj]$ fsck /dev/hdd1

Why would you be modifying the /dev/hdd device?

You're lucky this isn't working, you want to do a fsck /dev/md0 or
whatever your raid1 device is numbered.

Never touch the original partitions.

Mike

