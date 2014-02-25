From: NeilBrown <neilb@suse.de>
Subject: Re: md raid6: slow resync if fs is mounted rw
Date: Wed, 26 Feb 2014 10:38:01 +1100
Message-ID: <20140226103801.72e24304@notabene.brown>
References: <530D1F53.5070703@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OBLX8rssOdkVu/O1gOvqX.s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530D1F53.5070703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jakob Unterwurzacher <jakobunt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OBLX8rssOdkVu/O1gOvqX.s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 23:55:15 +0100 Jakob Unterwurzacher <jakobunt@gmail.com>
wrote:

> Dear list,
>=20
> I am seeing a strange performance issue on a 4 x 4TB md raid6 on kernel
> 3.12. Initial resync goes nice and fast at 130MB/s:
>=20
> > # cat /proc/mdstat
> > Personalities : [raid1] [raid6] [raid5] [raid4]
> > md1 : active raid6 sda3[0] sdd3[3] sdc3[2] sdb3[1]
> >       7751269376 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4=
] [UUUU]
> >       [=3D>...................]  resync =3D  7.5% (293925504/3875634688=
) finish=3D458.4min speed=3D130210K/sec
> >=20
> > md0 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]
> >       29280128 blocks super 1.2 [4/4] [UUUU]
> >=20
> > unused devices: <none>
>=20
> ...unless the ext4 filesystem on the array is mounted read-write!
> Then, speed plummets to 1 - 7MB/s. The filesystem is empty and totally
> idle; a simple "mount -o remount,ro" restores the speed to 130MB/s.
>=20
> I dumped the /sys/block/md1/md tree with the filesystem mounted ro and
> rw, the diff looks like this:
>=20
> > # diff -u md.rw md.ro
> > [...]
> > --- md.rw/stripe_cache_active   2014-02-25 17:33:31.250019324 +0100
> > +++ md.ro/stripe_cache_active   2014-02-25 17:33:31.250019324 +0100
> > @@ -1 +1 @@
> > -0
> > +256
> > diff -u md.rw/sync_speed md.ro/sync_speed
> > --- md.rw/sync_speed    2014-02-25 17:33:31.250019324 +0100
> > +++ md.ro/sync_speed    2014-02-25 17:33:31.250019324 +0100
> > @@ -1 +1 @@
> > -1052
> > +126244
>=20
> So, stripe_cache_active is zero if the fs is mounted rw. Hmm.
>=20
> Interestingly, if I increase sync_speed_min to 100MB/s, I do get 100MB/s.
>=20
> Any idea what is going on?
>=20

Simplest explanation would be that ext4 is writing to the array
occasionally.  Maybe 1 block per second.  That would be enough for md to
decide that the array is busy and to back-off the resync.

Try
  blktrace -w 20 /dev/md1

while the filesystem is mounted read-write, then
  blkparse md1.blktrace*

do we if anything writes are going to the array.

NeilBrown

--Sig_/OBLX8rssOdkVu/O1gOvqX.s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw0pWTnsnt1WYoG5AQLlGA//ago8ysbKGoq1L8f6OMl1Jgy8lZo/GZUq
/n3ojAdFIQodAojZSv4357E0cUw/YSxcop8UnBnXMVuk7xum1D9+Eab/v925R7Sr
wX6K9hi6aF9RiiHB5txc4y9EO8mOhs+K8rfEKrzjJqY+tBHoQHZsV/qqW//ior9C
5KsIg6HK81TDnsVMbxct3XIZ2Of2ZgfXB8qjYwYzV/+g52t8hHYkb8O8/UHSwYMs
trLYFjragu4yHuTznSgm20Qof+gZ/TqVqQGEgCgg+3gZTNSOVBvSaBw8pQ9D+Mxv
ktduyyXs79Ki3t8GmsffLyV9ntHPPV0PVPEiEvHzNL13dXsDVcZgPfHALrAr+Mh2
McPWUCQrGZw5dr2FWICAonf3+UFuFIlHl1Xepf136FRc9zop8wu8wqRSy/QBY+Q/
bgSyoc6UUmovKVVWnOwgJ32qk87d4m96sOSwHZOYo/XqngnBBTb/7uDac6ubpfFQ
MaOUK2Nk96EVa9VPI0TGbEEB4zEqCyDfkhIhHp1qGnbkEfg/81ZPTkc4ZK6LTNAC
jI8G/t1S711sERteFfRrIMoXqZyh+U03ZDVoQGPctFn7yjWXmQtjJ4mf8O7YJw8O
edFR2/+aHj3oyZleySM3sHCn+IhYZhMMQWfxRms0yAQ5la4XqFDPBsSp7yMG7bA4
VbrXvjZQu70=
=N0Wi
-----END PGP SIGNATURE-----

--Sig_/OBLX8rssOdkVu/O1gOvqX.s--
