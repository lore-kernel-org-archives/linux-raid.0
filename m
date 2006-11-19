From: dean gaudet <dean@arctic.org>
Subject: Re: Raid 1 (non) performance
Date: Sun, 19 Nov 2006 11:13:22 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611191107590.15092@twinlark.arctic.org>
References: <455B4609.6090905@kite.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <455B4609.6090905@kite.se>
Sender: linux-raid-owner@vger.kernel.org
To: "Magnus Naeslund(k)" <mag@kite.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Nov 2006, Magnus Naeslund(k) wrote:

> # cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sda3[0] sdb3[1]
>       236725696 blocks [2/2] [UU]
> 
> md1 : active raid1 sda2[0] sdb2[1]
>       4192896 blocks [2/2] [UU]
> 
> md0 : active raid1 sda1[0] sdb1[1]
>       4192832 blocks [2/2] [UU]

i see you have split /var and / on the same spindle... if your /home is on 
/ then you're causing extra seek action by having two active filesystems 
on the same spindles.  another option to consider is to make / small and 
mostly read-only and move /home to /var/home (and use a symlink or mount 
--bind to place it at /home).

or just put everything in one big / filesystem.

hopefully your swap isn't being used much anyhow.

try "iostat -kx /dev/sd* 5" and see if the split is causing you troubles 
-- i/o activity on more than one partition at once.


> I've tried to modify the queuing by doing this, to disable the write cache and enable CFQ. The CFQ choice is rather random.
> 
> for disk in sda sdb; do
>   blktool /dev/$disk wcache off
>   hdparm -q -W 0 /dev/$disk

turning off write caching is a recipe for disasterous performance on most 
ata disks... unfortunately.  better to buy a UPS and set up nut or apcupsd 
or something to handle shutdown.  or just take your chances.

-dean
