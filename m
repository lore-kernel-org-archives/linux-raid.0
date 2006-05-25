From: Neil Brown <neilb@suse.de>
Subject: Re: iostat messed up with md on 2.6.16.x
Date: Thu, 25 May 2006 15:40:39 +1000
Message-ID: <17525.17239.964716.567877@cse.unsw.edu.au>
References: <1148431824.2377.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pallai Roland on Wednesday May 24
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 24, dap@mail.index.hu wrote:
> 
> Hi,
> 
>  I upgraded my kernel from 2.6.15.6 to 2.6.16.16 and now the 'iostat -x
> 1' permanently shows 100% utilisation on each disk that member of an md
> array. I asked my friend who using 3 boxes with 2.6.16.2 2.6.16.9
> 2.6.16.11 and raid1, he's reported the same too. it works for anyone?
> I don't think that it's exactly a md problem, but only appears with the
> md, so I wrote here
> 
>  I did a basic debugging on evening and I think the problem is the
> double calling of disk->in_flight-- in block/ll_rw_blk.c  -  I dont know
> why, but here's a sample line from /proc/diskstats after a raid array
> assembled:
> 
>     8    0 sda 52 1134 8256 568 3 7 24 16 4294967295 433820 4294534144
>                                           ^^^^^^^^^^ in_flight = -1
> 
>  I wrote an ugly workaround and now the iostat working well [see
> attach#1], but if it's a real bug, someone should find the root cause of
> it, please

http://lkml.org/lkml/2006/5/23/42

might help...

NeilBrown
