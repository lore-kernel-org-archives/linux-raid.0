From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 16:21:27 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302021621110.17543-100000@router.windsormachine.com>
References: <00f601c2cafe$4f4dd500$6701a8c0@bc.hsia.telus.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00f601c2cafe$4f4dd500$6701a8c0@bc.hsia.telus.net>
To: Adam J Morand <Adam.Morand@midnightmoon.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 2 Feb 2003, Adam J Morand wrote:

> Mike,
>
> I could not get the md0 to resync / reinitialize
> raidstop / raidstart / etc...
>
> so I am unable to do fsck /dev/md0
> I was thinking if I could get one drive to work I could wipe the other one,
> and then rebuild the pair, no??
>
> aj

Can you list your /etc/raidtab, and what errors you were getting?

mike

