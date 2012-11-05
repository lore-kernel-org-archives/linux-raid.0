From: NeilBrown <neilb@suse.de>
Subject: Re: is "replaceable" in 3.2 considered stable
Date: Mon, 5 Nov 2012 21:53:24 +1100
Message-ID: <20121105215324.434e09dc@notabene.brown>
References: <alpine.DEB.2.00.1211050546420.13802@uplift.swm.pp.se>
	<20121105162227.7bc5c103@notabene.brown>
	<alpine.DEB.2.00.1211050909540.13802@uplift.swm.pp.se>
	<20121105194210.7f053192@notabene.brown>
	<alpine.DEB.2.00.1211050943320.13802@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IfDl3tExf1gEAj7B5ZtA8ZF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1211050943320.13802@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IfDl3tExf1gEAj7B5ZtA8ZF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Nov 2012 09:46:47 +0100 (CET) Mikael Abrahamsson <swmike@swm.pp.s=
e>
wrote:

> On Mon, 5 Nov 2012, NeilBrown wrote:
>=20
> > You want
> >   echo want_replacement > ..../state
> >
> > I changed that from replaceable at some point, so I guess you are looki=
ng at
> > old code :-(
>=20
> I was looking at the LWN article...
>=20
> Still no go though:
>=20
> root:~# echo want_replacement > /sys/block/md0/md/dev-sdh/state
> -bash: echo: write error: Invalid argument
> root:~# cat /sys/block/md0/md/dev-sdh/state
> in_sync
> root:~# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [rai=
d1] [raid10]
> md0 : active raid6 sdi[10](S) sdg[11] sdj[15] sdh[14] sdk[13] sde[12] sdd=
[9] sdb[6] sdf[7] sdc[2]
>        13674601024 blocks super 1.2 level 6, 64k chunk, algorithm 2 [9/9]=
 [UUUUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
>=20

The code actually appears in 3.3, not 3.2.  Sorry.

The email in the lwn.net article does say:

> I hope to submit this together with support for RAID10 (and maybe some
> minimal support for RAID1) for Linux-3.3.=20

It also says:


> The following series - on top of my for-linus branch which should appear =
in
> 3.2-rc1 eventually - implements hot-replace for RAID4/5/6.

which is probably what made you think it was in 3.2.
However is was the "for-linus branch; that would appear in 3.2-rc1, not the
series of patches :-(


So: you need 3.3 or later.

NeilBrown

--Sig_/IfDl3tExf1gEAj7B5ZtA8ZF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJeapDnsnt1WYoG5AQLDxhAAghU5yRDJHRt3cWtf9PwQb0P8ZpFARmYe
+NZPgcyiFu4mDEbQousg4osrIxBk6eDU60OlZnu3/+3N1GisaxhyDXFbDkXLDP0J
GBUtnFoYz9cYZ7xIn20g7hiVb+wxNOEKrL/uNjMjxDzKjzFQcjcUq9wM7/+5EGHF
qjGKL9yfzUByzID6Q3TBor9yItoqjYMkvWxqAKlIxePY7jV/FJkwS6F+zsyPDI42
drc7ciMWUfE/JsnLM4WF3yCtnc0nTGSGXXZreP3f9SmL/gZFOB7K2RyqcCHYUh+x
p/iCvwjQFiR5FHW2h1qSi+5C0PGBYNvWZ5DXWLyKu53zbclleOj8s665OetPT95c
7aeAvvh7+EPxHj9yinX4wdY/dVZprv3gyP9qRmnqK2svB0g/dBM7iSLaS8/Wod+h
iw5A+KxoDgnXgVyh6nck1ZfyuMx2HTotn4IgDbG3VkPz9hA03F+RmsUvTcI74Y+t
k8ft6zFZi4kaV1owSRjx53B4pjJpz30WOdPGf0884GKb57nphz0tMKuTRcMPCwNZ
48COqJMvSL9RfEiehVl3qNpdc2JYCKIffJkpIZKI7qnkOk8ZyFKcjVqSLtnDeW+N
lFZDaRvO7Yo6gvV/pUmyCJA+51SO4qrySYWLLstPUyD5/8tql0oQgIMjwkInQnhV
AG8/yy1215s=
=TBuV
-----END PGP SIGNATURE-----

--Sig_/IfDl3tExf1gEAj7B5ZtA8ZF--
