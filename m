From: 'Keld =?iso-8859-1?Q?J=F8rn?= Simonsen' <keld@dkuug.dk>
Subject: Re: Properly setting up partitions and verbose boot
Date: Wed, 28 Jan 2009 19:13:49 +0100
Message-ID: <20090128181349.GA10524@rap.rap.dk>
References: <001401c97f08$91205150$b360f3f0$@com> <20090126012013.GB28271@rap.rap.dk> <003501c97fd0$0ee0fa00$2ca2ee00$@com> <20090127042608.GA21425@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090127042608.GA21425@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: GeneralNMX <generalmx@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 27, 2009 at 05:26:08AM +0100, 'Keld J=F8rn Simonsen' wrote:
> On Mon, Jan 26, 2009 at 11:06:32AM -0500, GeneralNMX wrote:
> >=20
> > >From my understanding, there is fault tolerance and then there is =
the chance
> > of a disk dying. Obviously, the more disks you have, the greater ch=
ance you
> > have of a disk dying. If we assume all disks start out at some base=
 chance
> > to fail and degrade, putting multiple RAID types on the same disks =
can
> > dramatically increase the wear & tear as the number of disks increa=
se,
> > especially when you have both a raid5 (which doesn't need to write =
to all
> > disks, but will read from all disks) and a raid10 (which probably w=
ill write
> > and read to all disks) on the same physical array of disks. Since f=
ault
> > tolerance is there to decrease the problems with disks dying, my se=
tup is
> > obviously sub-optimal. Whenever I access my RAID10, I'm also ever s=
o
> > slightly degrading my RAID5 and RAID1, and visa-versa.
>=20
> Your arrangement does not increase the wear and tear, as far as I can
> tell. This compared to a solution where you only have one big raid10,=
f2
> raid. Actually your wear and  tear would be lower, because raid5 does
> not write so much if you mainly deal with bigger files, and not datab=
ase
> like operations.
>=20

Compared to raid10,f2, raid5 only writes 1/3 of the data for redundancy=
i
in a 4-drive setup, and it does it in a striping manner, so raid5
is quite fast for sequential writing.

> > Now, as for the I/O Wait, this happens when I try to access both th=
e RAID10
> > and RAID5 at the same time, especially if I'm moving a lot of data =
from the
> > RAID10 to the RAID5.
>=20
> I think this would be the same if you moved the data (copying it) wit=
hin
> the RAID10, or within the RAID5. Please try it out, and I would be
> interested also to hear your results.

Of cause moving around big files is IO bound.  I think the theoretical=20
best performance is sequential read time for the one raid, plus
theoretical write time for the other raid, hoping that random read/writ=
e
can be minimized. The theoretical read performance for raid10,f2 is
almost 4 times nominal read speed, and theoretical write time for the
raid5 is almost 3 times nominal speed, in your 4-drive setup.=20
I tried some of it out with "cp", just on a single normal partititon,
and it looks like "cp" minimizes the random read/write.

I would be interested in hearing some performance fugures from you.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
