From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Thu, 11 Feb 2016 00:54:28 +0200
Message-ID: <20160210225428.GC2461@reaktio.net>
References: <1670804.QnHtKWfib8@nell>
 <22200.46449.482559.914441@quad.stoffel.home>
 <20160210221345.GB2461@reaktio.net>
 <22203.47103.654951.880508@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22203.47103.654951.880508@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Thomas Fjellstrom <thomas@fjellstrom.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 10, 2016 at 05:21:51PM -0500, John Stoffel wrote:
> >>>>> "Pasi" =3D=3D Pasi K=E4rkk=E4inen <pasik@iki.fi> writes:
>=20
> Pasi> On Mon, Feb 08, 2016 at 10:34:09AM -0500, John Stoffel wrote:
> >>=20
> Thomas> I'm planning on setting up a dual raid5 array for hosting vm'=
s
> Thomas> off LVM, I would like to add an ssd cache to help with typica=
l
> Thomas> server system loads, and some mixed read/write loads for game
> Thomas> servers.
> >>=20
> Thomas> I'm wondering what the "best" route for me to go is. There's =
a
> Thomas> few options that I know of, like flashcache, dm-cache, and
> Thomas> bcache. The question is which of those is better suited to my
> Thomas> use case?
> >>=20
> >> I looked into both bcache and lvmcache and went with lvmcache beca=
use
> >> it made more sense to me.  But one restriction is that the cache L=
Vs
> >> must be in the same VGs as the volume to cache.  So you might need=
 to
> >> partition your SSD(s) and put the partitions into seperate VGs so =
that
> >> you can cache one or more LVs.
> >>=20
> >> I'm using it at home to cache a RAID1 4tb VG, with a pair of mirro=
red
> >> SSDs.  I'm a big believer in mirroring, esp for critical stuff lik=
e
> >> this.
> >>=20
> >> Unfortunately, I don't have a good performance measurements of how
> >> much help this actually gives me.  It *feels* faster, but since I
> >> don't have before/after measurements, I could just have wasted a b=
unch
> >> of money.
> >>=20
> >> So I'd recommend lvmcache overall, since it does seem to help, but
> >> push for better performance metrics and measurement.  Heh, maybe i=
t's
> >> time for me to start writing up lvmcachetop to help measure things=
=2E
>=20
> Pasi> The other day I was benchmarking lvmcache (on CentOS 7.2), but =
I
> Pasi> couldn't get it to give much advantage for writeback caching us=
e
> Pasi> case..  even when I was using fast nvme/pcie cache device.
>=20
> What were you using?  I should spin up fio and see what I can
> find... or maybe even just some kernel compiles, image manipulation,
> etc.
>

Yeah I was benchmarking small random 4 kB writes, using fio.=20
iodepth=3D64 and jobs=3D12.


> Let's see what we can come up with for benchmarking, since it would b=
e
> a big help!  I'm running kernel 4.4-rc7 right now on a Debian Jessie =
system.
>=20
> Pasi> It just wouldn't cache writes properly for me. I tried both the
> Pasi> smq and mq, and played with all of the parameters.. it just
> Pasi> wouldn't help much for my use case.
>=20
> I have both mq and smq compiled into the kernel, so I can't figure ou=
t
> how to change between them to test.
>

Hmm, yeah, I think it was documented on the lvmcache man page.=20
I can't check my notes right now..

=20
> John


-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
