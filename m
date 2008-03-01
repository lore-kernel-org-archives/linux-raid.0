From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 1 Mar 2008 22:10:30 +0100
Message-ID: <20080301211030.GB17192@rap.rap.dk>
References: <1204195554.16924.16.camel@franck-gusty> <loom.20080228T223023-79@post.gmane.org> <20080301204020.GC10278@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080301204020.GC10278@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <nat@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 01, 2008 at 09:40:20PM +0100, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 28, 2008 at 10:36:22PM +0000, Nat Makarevitch wrote:
> > Franck Routier <franck.routier <at> axege.com> writes:
> >=20
> > > database (postgresql) server.
> >=20
> > AFAIK if the average size of an I/O operation as long as the corres=
ponding
> > variance are low... go for a single RAID10,f2 with a stripe size sl=
ightly
> > superior to this average. This way you will have most requests mobi=
lizing only a
> > single spindle and all your spindles acting in parallel. If this av=
erage size
> > varies upon tables one may create a RAID (with the adequate stripe =
size) per
> > database partition.
>=20
> I believe that a full chunk is read for each read access.
> Or, at least, if one operation can be done within one chunk,
> not more than that chunk is operated upon.
>=20
> And chunks are recommended to be between 256 kiB and 1 MiB.
> Most random database reads are much smaller than 256 kiB.
> So the probability that one random read can be done with just one=20
> seek + read operation is very high, as far as I understand it.
>=20
> This would lead to that it is not important whether to use=20
> two arrays of 6 disks each, or 3 arrays of 4 disks each.=20
> Or for that sake 1 array of 12 disks.
>=20
> Some other factors may be more important: such as the ability to surv=
ive
> disk crashes. raid10,f2 is good for surviving 1 disk crash. If you ha=
ve
> 3 raids of 4 disks, it can survive a disk crash in each of these raid=
s.
> Furthermore some combinations of crashes of 2 disks within a raid can
> also be survived. There are 16 combinations of failing disksi, with 0=
 to
> 4 disks failing:
>=20
>    0000 Y  0001 Y 0010 Y  0011 N 0100 Y 0101 N 0110 Y 0111 N
>    1000 Y  1001 Y 1010 N  1011 N 1100 N 1101 N 1110 N 1111 N
>=20
> So if 2 disks fails, then in 2 out of 6 cases this would be ok,
> given a succes rates of 1.33 for surviving one or two disk crashes.
> For 3 raid sets of 4 drives each, this should be able to survive 4
> (3 * 1.33) disks malfunctioning on average, while it is only guarante=
ed
> to survive 1 bad disk.
>=20
> With more disks in the array, more combinations would be possible to
> survive. I do not have a formula for it, but surely it should exist.
> Maybe arrays with an odd number of drives would have better chances o=
f
> surviving, given that in the 4-drive example a number of combinations
> of failing drives were fatal because all even chunks were distributed=
 on
> disks 1 and 3, while odd chunks were on disks 2 and 4).=20
> I would like to know if somebody could come up with a
> formula, and what results one would get for  a 2 x 6 disk array, and =
1 x
> 12 disks array.=20

I would actually think that for a 12 disk raid, it would be hard to
survive more than 2 disk in average. For 2 times 6 disks the probabilit=
y
of surviving about 3 bad disks is possible. But I would like a formula.

So smaller raid sizes are good here. For example with 6 sets of
raid10,f2 raids, you can loose 1 disk in each array, thus surviving
about 6 bad disks on average. Again, if just 2 disks fail, in the same=20
raid, you are lost. So no guarantees on surviving 6 bad disks.

> Another more important item could be speed: especially for average se=
ek
> times. More disks in an array would for raid10,f2 reduce the max and
> average seek times as searching on each disks would be reduced in tim=
e,
> for n disks in a raid only 1/n of each disk will be used for reading.=
=20

Speed would also improve with bigger arrays, as IO bandwidth per
operation would become bigger. Eg. if you traverse all entries in a
table, you can have IO to all 12 disks at the same time. Having it all
in one big array make the system automatically distribute the database
accesses to all 12 disks, while you need to do the distribution by hand
between the arrays if you make 3 sets of 4 disks.

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
