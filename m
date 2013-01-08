From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How do I tell which disk failed?
Date: Mon, 07 Jan 2013 23:19:25 -0600
Message-ID: <50EBAC5D.8080000@hardwarefreak.com>
References: <1357610701.16366.13.camel@corn.betterworld.us>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357610701.16366.13.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/7/2013 8:05 PM, Ross Boylan wrote:
> I see my array is reconstructing, but I can't tell which disk failed.

> md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
>       96256 blocks [3/3] [UUU]
> 
> md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
>       730523648 blocks [3/3] [UUU]

Your two md/RAID1 arrays are built on partitions on the same set of 3
disks.  You likely didn't have a disk failure, or md0 would be
rebuilding as well.  Your failure, or hiccup, is of some other nature,
and apparently only affected md1.

>       [>....................]  resync =  0.4% (3382400/730523648) finish=14164.9min speed=855K/sec

Rebuilding a RAID1 on modern hardware should scream.  You're getting
resync throughput of less than 1MB/s.  Estimated completion time is 9.8
_days_ to rebuild a mirror partition.  This is insanely high.

Either you've tweaked your resync throughput down to 1MB/s, or you have
some other process(es) doing serious IO, robbing the resync of
throughput.  Consider running iotop to determine if another process(es)
is eating IO bandwidth.

-- 
Stan

