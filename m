From: Danilo Godec <danci@agenda.si>
Subject: Re: some question in SoftRaid
Date: Thu, 23 May 2002 15:48:45 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205231534110.11465-100000@duplo.agenda.si>
References: <OF3F6026D2.567B40AF-ON48256BC2.00308831@legend.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OF3F6026D2.567B40AF-ON48256BC2.00308831@legend.com.cn>
To: lilha@legend.com.cn
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 23 May 2002 lilha@legend.com.cn wrote:

> 1.Raid 0,1,5 must install in differ disk?right?

Not really, you can make Linux SW RAID on any kind of partition - even on
the same disk. It really makes no sense, thouhg.

> RAID-0 and RAID-1 need at lest 2 disk
> RAID-5 need at lest 3 disk,is it right?

Right.

> then is there any requrement about the partition Type(such as
> primary,logical or extend partition )?

I think not. I'm not sure about the extended partitions, but primary and
logical should work.

> 2.can i setup raid0,1,5 in the partition which has different size?
> such as:
> /dev/hda1 500M
> /dev/hdc1 600M
> can i setup raid-0 or raid-1?i try it,but failed.

For RAID0, partitions should be approx. the same size, but it should work
in any case, however the striping will only be performed for the size of
the smaller partition. Maybe there is a treshold when the difference gets
to big...

You should also be able to create a RAID1 array with two different
partition sizes, however the resultin array will be the size of the
smaller partition. I'm not certain, but maybe the order is important - if
the smaller partition is listed first, the bigger will be partially used.
If the bigger is listed first, the smaller will end up being 'too
small'...

I'm not sure about RAID5, but I think the partitions should be the same
size (at least very close). At least that's how I do it.

> 3.how can I remove raid from disk? such as,i have md0(RAID 0),it use
> /dev/hda2 and /dev/hdc2 now i want to these partitions don't use
> raid,i want to release these partition then how can I do?

You can use 'the old' raidsetfaulty - raidhotremove combination, or you
can use the new mdadm. Both do the job.

If you use autodetection, you can also change the partition type from
'0xfd' to something else.

  D.



