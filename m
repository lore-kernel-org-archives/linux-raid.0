From: "GeneralNMX" <generalmx@gmail.com>
Subject: RE: Properly setting up partitions and verbose boot
Date: Mon, 26 Jan 2009 11:06:32 -0500
Message-ID: <003501c97fd0$0ee0fa00$2ca2ee00$@com>
References: <001401c97f08$91205150$b360f3f0$@com> <20090126012013.GB28271@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090126012013.GB28271@rap.rap.dk>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?'Keld_J=F8rn_Simonsen'?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


=46rom my understanding, there is fault tolerance and then there is the=
 chance
of a disk dying. Obviously, the more disks you have, the greater chance=
 you
have of a disk dying. If we assume all disks start out at some base cha=
nce
to fail and degrade, putting multiple RAID types on the same disks can
dramatically increase the wear & tear as the number of disks increase,
especially when you have both a raid5 (which doesn't need to write to a=
ll
disks, but will read from all disks) and a raid10 (which probably will =
write
and read to all disks) on the same physical array of disks. Since fault
tolerance is there to decrease the problems with disks dying, my setup =
is
obviously sub-optimal. Whenever I access my RAID10, I'm also ever so
slightly degrading my RAID5 and RAID1, and visa-versa.

Now, as for the I/O Wait, this happens when I try to access both the RA=
ID10
and RAID5 at the same time, especially if I'm moving a lot of data from=
 the
RAID10 to the RAID5. While my server was rather old before I upgraded i=
t
just two days ago using spare parts (was a 1997 Supermicro Dual P3 550M=
Hz
1GB SDRAM, now a 2.8GHz P4 w/ HT 1.5GB DDR), I think the I/O Wait was c=
aused
by trying to negotiate the three different RAID arrays at once, which
encompass all four disks, while still allowing access to those arrays. =
Along
with critical data, I also use the RAID10 as a staging area for large
downloads from other servers due to its speed and reliability. Once I
determine the worth of the data, I usually transfer it to the RAID5, wh=
ich
does not house critical data (more like it would be annoying if it fail=
ed).
Backups of / (sans large downloads) also go on the RAID5 in case the fi=
le
systems become corrupted. Again, it would be better to have the backups=
 on
separate physical disks, as corrupt MFTs and seriously corrupt partitio=
ns
could hose the entire setup.

But I just do this all for my own enjoyment and education. I don't impl=
ement
this stuff in production environments. As much as I'd like to convert m=
y
workplace's Windows XP "Server" using fake raid1 which holds all our
super-critical data...we literally have to reboot that thing every 2-4 =
hours
due to problems with other software that's on it.


-----Original Message-----
=46rom: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]=20
Sent: Sunday, January 25, 2009 8:20 PM
To: GeneralNMX
Cc: linux-raid@vger.kernel.org
Subject: Re: Properly setting up partitions and verbose boot

On Sun, Jan 25, 2009 at 11:18:31AM -0500, GeneralNMX wrote:
>=20
> Currently I have a very stupid setup on my home server (not a product=
ion
> machine). I have four hard drives with three different types of RAID
> (1,5,10) on them setup through mdadm. I've been using this for a whil=
e
and,
> as you can guess, I/O Wait is a big issue for me, especially when mov=
ing
> from different RAID types. I ordered four new hard drives to setup a
proper
> RAID10 by itself and I'm scrapping the RAID1, instead just consolidat=
ing /
> into the RAID10. /boot gets its own tiny IDE HDD in a hotswap bay. Th=
e
RAID5
> will consume the 4 old hard drives.=20

Why do you think it is stupid?

I have a similar setup described in a howto at:

http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

How big is the iowait issue for you?

What are the performance of your raids?

> With my stupid setup, each partition gets its own /dev/mdX device. Th=
is is
> the only way I know how to do it. On the RAID10, I will need at least=
 two
> partitions: / and swap. This means it cannot simply partition the ent=
ire
> disk Would this cause sub-optimal performance? Is there a way to make=
 an
> underlying single RAID10 partition and place the file partitions on t=
op?

I dont think it would be suboptimal. But try it out, both solutions and
see for yourself and report to the list your findings!).

I don't think having two raid10.f2 partitions, one for / and one for
swap, will be suboptimal, given the number of drives involved. Each=20
raid will do its best for the IO, and the difference between haveing it
all on one raid, vs having it on two raids, would to be be
insignificant. Where  should the extra overhead come from? I even think
the elevator algorithm would be the same, as the elevator is per drive
(As far as I understand it).

do you think that the different raid  types make performance problems?

I think you can partition a MD device into more partitions.=20
I have not tried it out for production, though and I dont know how it
performs.

I am in the process of setting up two quad-core machines with 8 GB ram=20
for use as virtual servers, and intend to have rai10,f2 in the buttom o=
f
the dom0, and then let the different virtual machines have partitions o=
n
the raid10 array. Is this recommendable? I was thinkin of problems of
both dom0 and domu doing IO, and thus copying io buffers twice.

Best regards
keld

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
