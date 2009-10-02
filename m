From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: A few remaining questions about installing to RAID-10
Date: Fri, 2 Oct 2009 10:24:20 -0700
Message-ID: <babafd2f0910021024m5fb72fc4k2304bf57e405f2fc@mail.gmail.com>
References: <babafd2f0910012046i46f77e82lc1a75bbee3b1a6d8@mail.gmail.com>
	<887103.5263.qm@web38801.mail.mud.yahoo.com> <babafd2f0910020754i4818043aw3d4a15e91eec9eb8@mail.gmail.com>
	<20091002151504.GA22207@cthulhu.home.robinhill.me.uk> <babafd2f0910020846o22e7dd30l4a7be554770d0904@mail.gmail.com>
	<20091002155919.GB22207@cthulhu.home.robinhill.me.uk> <babafd2f0910020931i5b38316dpc6351d5d6ed5211@mail.gmail.com>
	<20091002170156.GA21401@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002170156.GA21401@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robin,

On Fri, Oct 2, 2009 at 10:01 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> Depends really - far isn't much slower on writes (the I/O elevator an=
d
> filesystem buffering help). =A0If you know /var will be write-mostly =
(it's
> often the default location for MySQL data files as well) then a near
> layout may be better though.

Ok, that's clear.  /var is typically a mix, it seems.  I may well
create a second set of partitions for read-write on /data & /var/cache
(I already put /tmp in tmpfs/RAM. /home I've mixed feeling about) --
once I've convinced myself that the benefits really show up in the
benchmarks.  And decide whether it's worth the complexity.   And, of
course, then the which FS to use decisions (would prefer ZFS, but n/a.
 brtfs is promising but still experimental afaict.  ext4 &/or xfs may
be my solutions); but that's for a different ML, I guess.

> RAID-1 over N disks can survive N-1 drive failures. =A0Each disk hold=
s a full copy of the data.

I really need to stop confusing RAID-0/1 mirrors & stripes.  THanks.

> Currently only RAID-1,4,5 and 6 support growing arrays (by either add=
ing
> spindles or increasing the capacity of each spindle). =A0There are pl=
ans
> to add this capability to other RAID levels but I'm not sure where th=
is
> sits on the priority list.

Good to know.  With 4x1TB drives, I've got 2TB RAID-10 space to play
with.  More than enough without worrying about the expansion too much.
 For now.

Thanks.

Ben
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
