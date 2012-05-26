From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 14:56:54 -0500
Message-ID: <4FC13586.8060408@hardwarefreak.com>
References: <4FBF60D1.80104@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBF60D1.80104@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5/25/2012 5:37 AM, Joe Landman wrote:
> Hi folks:

Hi Joe,

I may be all wet here, but this is the only thing that jumped out at me:

> meta-data=/dev/md20
> data     =                       sunit=8      swidth=56 blks
> log      =internal               sunit=8 blks

8*56KB (or 7*64KB) = 448KB write out

> [root@siFlash ~]# mdadm --detail /dev/md20
> /dev/md20:
>         Version : 1.2
>    Raid Devices : 8

>          Layout : left-symmetric
>      Chunk Size : 32K

7*32KB = 224KB stripe size

> All this said, deletes from this unit are taking 1-2 seconds per file ...

> Anything obvious that we are doing wrong?

Other than your XFS writeout being apparently twice the size of your
RAID stripe, nothing else stands out that I can see.  I'm not a block
layer expert.  And since mkfs.xfs came up with 448KB, apparently this
should be fine.  However, everything in the literature, and the experts
on this list, tells us to always precisely align XFS to the RAID stripe.
 That doesn't seem to be the case here.

-- 
Stan
