From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 16:57:08 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302021650520.17543-100000@router.windsormachine.com>
References: <016501c2cb01$e7811f00$6701a8c0@bc.hsia.telus.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <016501c2cb01$e7811f00$6701a8c0@bc.hsia.telus.net>
To: Adam J Morand <Adam.Morand@midnightmoon.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2 Feb 2003, Adam J Morand wrote:

> right now it is all gibbled, I do not have a copy of the proc when it was
> working, but says this
>
> cat /proc/mdstat
> Personalities : [raid0] [raid1]
> read_ahead 1024 sectors
> md0 : active raid0 hda3[1] hdb3[0]
>       26619520 blocks 64k chunks
>
> md2 : active raid1 hdb1[0]
>       5116544 blocks [2/1] [_U]
>
> md1 : active raid1 hda2[1]
>       20482752 blocks [2/1] [U_]
>
> unused devices: <none>

Just printed out the two files for me to look at side by side.


You've got md0 set in /etc/raidtab, to use hdd3, and hdb3.

It's actually using hda3 and hdb3.

You've got md1 set in /etc/raidtab, to use hdd2 and hdb2

It's actually using hda2 and nothing.

you've got md2 set in /etc/raidtab, to use hdd1 and hdb1

It's actually using hdb1 and nothing.



Top of my head guess, is that your /dev/hdd has become /dev/hda.

Now, how that's possible, I'm really not sure because that implies a
cable change to move from the second controller to the first.  It looks
like your md0 found the new drive location just fine, but the md1 and md2
weren't able to?

Check your cabling.

Mike



