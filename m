From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Mon, 5 Nov 2012 09:46:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211050943320.13802@uplift.swm.pp.se>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se> <20121105162227.7bc5c103@notabene.brown> <alpine.DEB.2.00.1211050909540.13802@uplift.swm.pp.se> <20121105194210.7f053192@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121105194210.7f053192@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 5 Nov 2012, NeilBrown wrote:

> You want
>   echo want_replacement > ..../state
>
> I changed that from replaceable at some point, so I guess you are looking at
> old code :-(

I was looking at the LWN article...

Still no go though:

root:~# echo want_replacement > /sys/block/md0/md/dev-sdh/state
-bash: echo: write error: Invalid argument
root:~# cat /sys/block/md0/md/dev-sdh/state
in_sync
root:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid6 sdi[10](S) sdg[11] sdj[15] sdh[14] sdk[13] sde[12] sdd[9] sdb[6] sdf[7] sdc[2]
       13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
       bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
