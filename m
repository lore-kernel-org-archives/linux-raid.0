From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: The huge different performance of sequential read between
 RAID0 and   RAID5
Date: Thu, 28 Jan 2010 08:06:06 +0100
Message-ID: <20100128070606.GD3098@boogie.lpds.sztaki.hu>
References: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: linux-raid@vger.kernel.org, yhxu@wayne.edu
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 10:16:12PM -0500, Yuehai Xu wrote:

> md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>       631353600 blocks level 5, 64k chunk, algorithm 2 [7/6] [UUUUUU_]
[...]
> Then I start IOZONE which starts 10 processes to do the sequential
> read(iozone -i 1). Each process read 640M file on each partition. The
> throughput of RAID0 is about 180M/s, while the throughput of RAID5 is
> just 43M/s. Why the performance between RAID0 and RAID5 is so
> different?

You have a degraded RAID5 array with one drive missing, meaning the data
has to be recalculated from parity all the time. That obviously kills
performance.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
