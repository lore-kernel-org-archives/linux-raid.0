From: NeilBrown <neilb@suse.de>
Subject: Re: repartitioning disks
Date: Tue, 17 May 2011 20:39:44 +1000
Message-ID: <20110517203944.65d8114e@notabene.brown>
References: <BANLkTim5A1HEiPrRMxiUFZ4PGuyc4pbG-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim5A1HEiPrRMxiUFZ4PGuyc4pbG-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 17 May 2011 12:20:50 +0400 CoolCold <coolthecold@gmail.com> wrote:

> Wiki says: "Never NEVER never re-partition disks that are part of a
> running RAID. If you must alter the partition table on a disk which is
> a part of a RAID, stop the array first, then repartition. " -
> https://raid.wiki.kernel.org/index.php/Tweaking,_tuning_and_troubleshooting#Pitfalls
> 
> Is it really true for situations like - I have 2x1Tb drives, which are
> already partitioned like /dev/sd{a,b}1 - 500mb, /boot & /dev/sd{a,b}2
> - 20gb, / and are assembled in RAID1 arrays md0 & md1 accordingly. So,
> if I want to create one more RAID1 array , say md3 from the rest of
> the drives.
> So i take my cfdisk ,add new partition with some space 100-150mb from
> the end, do write changes & partprobe the drives, then creating new
> array.
> 
> Is it bad? To be honest i'm doing this all the time and can't
> understand how this gonna hurt md. Neil and/or others, please clarify
> this.
> 
> 

There shouldn't be any problem with that as long as you are careful (and if
you aren't careful, there are plenty of other ways to destroy your data).

I wasn't aware of partprobe.    Just telling the kernel to reread the
partition table won't work when a partition is in use.
But partprobe seems to just tell the kernel about the partitions that have
changed, using a different ioctl, and that seem to work.

NeilBrown
