From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: partitioned mirror vs. mirrors of partitions?
Date: Fri, 9 May 2008 19:37:32 +0100
Message-ID: <18468.39404.548362.679829@tree.ty.sabi.co.uk>
References: <4823A238.4080205@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4823A238.4080205@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It looks like I could mirror sda and sdb, and partition the resulting
> md_d0.  Or, I could partition sda and sdb, and create mirrors md0, md1,
> etc from the partitions on the underlying disks.

> Is there any technical reason to choose one method vs the other?

In the Linux case, several, because the partitioning/RAID
operators don't commute. It is in general better to RAID
partitions than to partition RAIDs because:

* Partitioning is a special operation that historically has only
  been available for real disks, not any block device. You can
  partition RAID block devices but the mechanisms are a bit
  annoying (e.g. they are only recognized after the RAID is
  assembled and then only in request and the device names are
  not so nice, ...).

* Partitioning a RAID greatly obscures alignment and offset
  issues. In your case it does not matter because you used
  RAID1, but in general...

* In the general case, not for RAID1, arrays can be much bigger
  than a single disk, for example larger than 2TiB, and in that
  case the traditional MS-DOS style partitions don't work, and
  another less universally supported partitioning scheme should
  be used.

In your simple case keep things simple with nice partitions that
get recognize immediately by the Linux kernel as it boots,
thanks to RAID1 if set up nicely each partition can be used in
an emergecy without its mirror, and so on.

> It seems to me that perhaps on a system with several
> active partitions from the same disk, partitioning a single
> large raid device might allow better read balancing?

That is nearly irrelevant. Read balancing depends on the
physical distribution of data on disk (that would be much
similar) and on the elevators.

It is not clear to me what is the interaction between RAID and
request queueing and elevators (I am still investigating the
ridiculous '--seta 65536' situation), but I hope it does not
matter that much whether the disk queues are fed from one or
several RAID devices.
