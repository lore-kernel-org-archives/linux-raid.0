From: "Norman Zhang" <nzhang@arkon-group.com>
Subject: Re: RAID1 removal
Date: Mon, 23 Jun 2003 11:35:04 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bd7h8c$2dg$1@main.gmane.org>
References: <bcvdhn$r0f$1@main.gmane.org> <bcvtr9$a3i$1@main.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> system_lists wrote:
>
> Well, u have got that disk out of the Raid so its not in use.
>
> So you must (I THINK BUT I HAVENT DONE ANYTIME ... when I have
> needed to upgrade a Raid I have always programed a shutdown
> in the server):
>
> 1- remove the drive
> 2- remove the drive from the proc (from the kernel)
> 3- add a new drive
> 4- add a new drive in proc (in the kernel)
> 5- do some checks ...
> 6- add the drive into the Raid with 'raidhotadd'

Thanks. I just did a raidhotadd the drives are now back in sync. I see the
drive is in the array again.

Regards,
Norman




