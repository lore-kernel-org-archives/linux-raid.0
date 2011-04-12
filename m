From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Tue, 12 Apr 2011 14:30:25 -0700 (PDT)
Message-ID: <323937.22450.qm@web65109.mail.ac2.yahoo.com>
References: <20110408215000.15c881bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408215000.15c881bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 8/4/11, NeilBrown <neilb@suse.de> wrote:
[...]
> No, it was clearly a disk-drive problem.
> e.g.
> Apr  7 14:42:12 saturn kernel: [231957.756023]
> ata3.00: failed command: READ FPDMA QUEUED
> 
> a READ command sent to a n 'ata' device failed.  i.e.
> disk error.
[...]

Hi Neil,

I think it is either a drive or cable problem.

However, I was wondering if /proc/mdstat could list drives in a more consistent manner.  The C drive has dropped out and affected all 3 RAID partitions.  A quick look at /proc/mdstat suggests that md2 & md1 have the same drive drop out [UUUU_], but a different drive for md0 [UU_UU].  In fact, the list of drives (...sda4[0] sdc4[6](F)...) is not consistent with the [UUUU_] representation even for the same mdN!

# date ; cat /proc/mdstat 
Wed Apr 13 08:40:09 NZST 2011
Personalities : [raid6] [raid5] [raid4] 

md2 : active raid6 sda4[0] sdc4[6](F) sdd4[3] sdb4[5] sde4[1]
      1114745856 blocks super 1.1 level 6, 512k chunk, algorithm 2 [5/4] [UUUU_]
      bitmap: 3/3 pages [12KB], 65536KB chunk

md1 : active raid6 sda2[0] sdc2[5](F) sdd2[3] sde2[2] sdb2[1]
      307198464 blocks level 6, 512k chunk, algorithm 2 [5/4] [UUUU_] 
     
md0 : active raid6 sda3[0] sdb3[4] sdd3[3] sdc3[5](F) sde3[1]
      10751808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UU_UU]      

unused devices: <none>
# 


Regards,
Gavin


