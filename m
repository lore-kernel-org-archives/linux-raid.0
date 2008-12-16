From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 reshape stuck
Date: Tue, 16 Dec 2008 13:43:41 +1100
Message-ID: <18759.5597.253477.398427@notabene.brown>
References: <22F91D3D67E34C95B66F6AA0739F22DB@waptak.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yuriy Shkandybin on Friday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Yuriy Shkandybin <jura@netams.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 12, jura@netams.com wrote:
> Hello.
> 
> I've run into next problem:
> 
> there was raid5  md11( 3 of 3) from sdb4,sdg1,sdd1
> i've run
> mdadm /dev/md11 -a /dev/sdc1
> mdadm /dev/md11 -a /dev/sde1
> mdadm /dev/md11 -a /dev/sdf1
> mdadm --grow /dev/md11 --raid-devices=6
> reshape started
> shortly after i realized that sdd1 was too slow , and removed it 
> mdadm /dev/md1 -f /dev/sdd1 -r /dev/sdd1
> and rebooted  in hope to fix sdd speed 
> 
> after that md11_reshape stalled and md11 unaccessible 
> and programms tried to access md11 stuck in D state too
> also strange to see 
>   Delta Devices : 2, (4->6)

Why is this strange?  You are reshaping an array from 4 drives to 6
devices.  The difference (delta) between those numbers is 2.  Hence
the message.

> 
> Any chance get to complete reshape or receive access to md11 at least read-only?
> 
> 
> 
> Below different outputs that might help to identify problem.
> cat /proc/mdstat
> md11 : active raid5 sdb4[0] sde1[5] sdf1[3] sdg1[2] sdc1[1]
>       586073088 blocks super 0.91 level 5, 1024k chunk, algorithm 2 [6/5] [UUUU_U]
                                             ^^^^^

That is a useful clue, together with the stack traces.
To reshape an array, md needs to cache at least 4 full stripes.  With
a chunk size of 1024K, that is 1024 4K pages.
The stripe_cache_size defaults to 256 which is too small.
When you start a reshape, mdadm increases the size of the stripe_cache
to whatever you need.  However when you assemble the array after
a reboot in the middle of a reshape, mdadm doesn't fix the 
stripe_cache_size.  I need to fix that.

You can do it by hand with the command

  echo 1024 > /sys/block/md11/md/stripe_cache_size

That should cause the reshape to start running smoothly.

Thanks,
NeilBrown
