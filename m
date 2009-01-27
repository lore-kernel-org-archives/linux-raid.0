From: 'Keld =?iso-8859-1?Q?J=F8rn?= Simonsen' <keld@dkuug.dk>
Subject: Re: Properly setting up partitions and verbose boot
Date: Tue, 27 Jan 2009 05:26:08 +0100
Message-ID: <20090127042608.GA21425@rap.rap.dk>
References: <001401c97f08$91205150$b360f3f0$@com> <20090126012013.GB28271@rap.rap.dk> <003501c97fd0$0ee0fa00$2ca2ee00$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003501c97fd0$0ee0fa00$2ca2ee00$@com>
Sender: linux-raid-owner@vger.kernel.org
To: GeneralNMX <generalmx@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 26, 2009 at 11:06:32AM -0500, GeneralNMX wrote:
>=20
> >From my understanding, there is fault tolerance and then there is th=
e chance
> of a disk dying. Obviously, the more disks you have, the greater chan=
ce you
> have of a disk dying. If we assume all disks start out at some base c=
hance
> to fail and degrade, putting multiple RAID types on the same disks ca=
n
> dramatically increase the wear & tear as the number of disks increase=
,
> especially when you have both a raid5 (which doesn't need to write to=
 all
> disks, but will read from all disks) and a raid10 (which probably wil=
l write
> and read to all disks) on the same physical array of disks. Since fau=
lt
> tolerance is there to decrease the problems with disks dying, my setu=
p is
> obviously sub-optimal. Whenever I access my RAID10, I'm also ever so
> slightly degrading my RAID5 and RAID1, and visa-versa.

Your arrangement does not increase the wear and tear, as far as I can
tell. This compared to a solution where you only have one big raid10,f2
raid. Actually your wear and  tear would be lower, because raid5 does
not write so much if you mainly deal with bigger files, and not databas=
e
like operations.

It is of cause true that when you use the raid10, then you impede the
raid5 and raid1, but you would not get more out of a single raid10,
given that you have to have the same number of operations, with the
given number of drives.

comparing your setup to a mono-raid setup, you would get about the same
wear & tear out of it. Basically you have the same number of IO
operations, and they will take the same wear and tear. With a setup lik=
e
yours, you most likely will concentrate IO on the / partition which wil=
l
be on the faster parts of the disks, which are probably also more
reliable, and you will reduce arm movement, which is good for speed and
wear and tear. In essence you will get the benefits of your raid types
- speed for raid10,f2, storage size for raid5, and wear and rear will b=
e
as usage determines it from your raid types, I see no dramatic
difference there. I see that you think differently, and I would like us
to get some kind of conclusion on this issue. If you are right we shoul=
d
add info on this in the wiki.

> Now, as for the I/O Wait, this happens when I try to access both the =
RAID10
> and RAID5 at the same time, especially if I'm moving a lot of data fr=
om the
> RAID10 to the RAID5.

I think this would be the same if you moved the data (copying it) withi=
n
the RAID10, or within the RAID5. Please try it out, and I would be
interested also to hear your results.

> While my server was rather old before I upgraded it
> just two days ago using spare parts (was a 1997 Supermicro Dual P3 55=
0MHz
> 1GB SDRAM, now a 2.8GHz P4 w/ HT 1.5GB DDR), I think the I/O Wait was=
 caused
> by trying to negotiate the three different RAID arrays at once, which
> encompass all four disks, while still allowing access to those arrays=
=2E Along
> with critical data, I also use the RAID10 as a staging area for large
> downloads from other servers due to its speed and reliability. Once I
> determine the worth of the data, I usually transfer it to the RAID5, =
which
> does not house critical data (more like it would be annoying if it fa=
iled).

I don't think RAID10 is much more reliable than RAID5. They are both
guaranteed to survive 1 disk crash, and then RAID10 has a further 50 %
of surviving another disk crash. RAID10,f2 would have faster sequential
read, but raid5 is faster for writing, while also having quite fast
sequential read for big files.


> Backups of / (sans large downloads) also go on the RAID5 in case the =
file
> systems become corrupted. Again, it would be better to have the backu=
ps on
> separate physical disks, as corrupt MFTs and seriously corrupt partit=
ions
> could hose the entire setup.

yes, more disks in separate raids would always be better. The question
is how to best use the available number of disks.

> But I just do this all for my own enjoyment and education.

Good! I hope you enjoy it, and you can also help to educate others, by
reporting your findings here.

> I don't implement
> this stuff in production environments. As much as I'd like to convert=
 my
> workplace's Windows XP "Server" using fake raid1 which holds all our
> super-critical data...we literally have to reboot that thing every 2-=
4 hours
> due to problems with other software that's on it.

Sad to hear that. Maybe, for my amusement, you could report the IO of
your windows partititions here.=20

best regards
keld

>=20
>=20
> -----Original Message-----
> From: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]=20
> Sent: Sunday, January 25, 2009 8:20 PM
> To: GeneralNMX
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Properly setting up partitions and verbose boot
>=20
> On Sun, Jan 25, 2009 at 11:18:31AM -0500, GeneralNMX wrote:
> >=20
> > Currently I have a very stupid setup on my home server (not a produ=
ction
> > machine). I have four hard drives with three different types of RAI=
D
> > (1,5,10) on them setup through mdadm. I've been using this for a wh=
ile
> and,
> > as you can guess, I/O Wait is a big issue for me, especially when m=
oving
> > from different RAID types. I ordered four new hard drives to setup =
a
> proper
> > RAID10 by itself and I'm scrapping the RAID1, instead just consolid=
ating /
> > into the RAID10. /boot gets its own tiny IDE HDD in a hotswap bay. =
The
> RAID5
> > will consume the 4 old hard drives.=20
>=20
> Why do you think it is stupid?
>=20
> I have a similar setup described in a howto at:
>=20
> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_dis=
k
>=20
> How big is the iowait issue for you?
>=20
> What are the performance of your raids?
>=20
> > With my stupid setup, each partition gets its own /dev/mdX device. =
This is
> > the only way I know how to do it. On the RAID10, I will need at lea=
st two
> > partitions: / and swap. This means it cannot simply partition the e=
ntire
> > disk Would this cause sub-optimal performance? Is there a way to ma=
ke an
> > underlying single RAID10 partition and place the file partitions on=
 top?
>=20
> I dont think it would be suboptimal. But try it out, both solutions a=
nd
> see for yourself and report to the list your findings!).
>=20
> I don't think having two raid10.f2 partitions, one for / and one for
> swap, will be suboptimal, given the number of drives involved. Each=20
> raid will do its best for the IO, and the difference between haveing =
it
> all on one raid, vs having it on two raids, would to be be
> insignificant. Where  should the extra overhead come from? I even thi=
nk
> the elevator algorithm would be the same, as the elevator is per driv=
e
> (As far as I understand it).
>=20
> do you think that the different raid  types make performance problems=
?
>=20
> I think you can partition a MD device into more partitions.=20
> I have not tried it out for production, though and I dont know how it
> performs.
>=20
> I am in the process of setting up two quad-core machines with 8 GB ra=
m=20
> for use as virtual servers, and intend to have rai10,f2 in the buttom=
 of
> the dom0, and then let the different virtual machines have partitions=
 on
> the raid10 array. Is this recommendable? I was thinkin of problems of
> both dom0 and domu doing IO, and thus copying io buffers twice.
>=20
> Best regards
> keld
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
