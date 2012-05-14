From: NeilBrown <neilb@suse.de>
Subject: Re: Failed, but "md: cannot remove active disk..."
Date: Mon, 14 May 2012 20:22:20 +1000
Message-ID: <20120514202220.5a164eb0@notabene.brown>
References: <1336933308.2831.4.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VHBpuaDrKY6=+1V==UisKUD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1336933308.2831.4.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/VHBpuaDrKY6=+1V==UisKUD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 13 May 2012 20:21:48 +0200 Micha=C5=82 Sawicz <michal@sawicz.net> w=
rote:

> Hey,
>=20
> I've a weird issue with a RAID6 setup, /proc/mdstat says:
>=20
> > md126 : active raid6 sda1[3] sdh1[6] sdg1[0](F) sdf1[5] sdi1[1] sdc[8] =
sdb[7]
> >       9767559680 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6=
] [_UUUUUU]
>=20
> So sdg1 is (F)ailed, yet `mdadm --remove` yields:
>=20
> > md: cannot remove active disk sdg1 from md126 ...

There is a period of time between when a device fails and when the raid456
module finally lets go of it so it can be removed.  You seem to be in this
period of time.
Normally it is very short.  It needs to wait for any requests that have
already been sent to the device to complete (probably with failure) and
very shortly after that it should be released.  So this is normally much le=
ss
than one second but could be several seconds is some excessive retry is
happening.

But I'm guessing you have waited more than a few seconds.

I vaguely recall a bug in the not too distant past whereby RAID456 wouldn't
let go of a device quite as soon as it should.  Unfortunately I don't
remember the details.  You might be able to trigger it to release the drive
by adding a spare - if you have one - or maybe by just
  echo sync > /sys/block/md126/md/sync_action
it won't actually do a sync, but it might check things enough to make
progress.

What kernel are you using?

NeilBrown


>=20
> in dmesg...
>=20
> `mdadm --examine` shows:
>=20
> > /dev/sdg1:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : ff9e032c:446ed0bd:fc9473f3:f8e090ed
> >            Name : media:store  (local to host media)
> >   Creation Time : Tue Sep 13 21:36:43 2011
> >      Raid Level : raid6
> >    Raid Devices : 7
> >=20
> > Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
> >      Array Size : 19535119360 (9315.07 GiB 10001.98 GB)
> >   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : clean
> >     Device UUID : 4bcee8e2:709419b6:fbeb3a8e:5c9bb68a
> >=20
> >     Update Time : Sat May 12 21:57:27 2012
> >        Checksum : ffb03189 - correct
> >          Events : 304564
> >=20
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >=20
> >    Device Role : Active device 0
> >    Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> So that superblock thinks it's active, but that's normal, right? It
> wasn't updated due to fail? Others correctly show:
>=20
> > dev/sdc:
> >           Magic : a92b4efc
> >         Version : 1.2
> >     Feature Map : 0x0
> >      Array UUID : ff9e032c:446ed0bd:fc9473f3:f8e090ed
> >            Name : media:store  (local to host media)
> >   Creation Time : Tue Sep 13 21:36:43 2011
> >      Raid Level : raid6
> >    Raid Devices : 7
> >=20
> >  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
> >      Array Size : 19535119360 (9315.07 GiB 10001.98 GB)
> >   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
> >     Data Offset : 2048 sectors
> >    Super Offset : 8 sectors
> >           State : clean
> >     Device UUID : b713fd2b:eef145b0:ce91de0a:9077554b
> >=20
> >     Update Time : Sat May 12 21:57:57 2012
> >        Checksum : 80345876 - correct
> >          Events : 304581
> >=20
> >          Layout : left-symmetric
> >      Chunk Size : 512K
> >=20
> >    Device Role : Active device 2
> >    Array State : .AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
>=20
> Any ideas?
>=20
> Cheers,


--Sig_/VHBpuaDrKY6=+1V==UisKUD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7Dc7jnsnt1WYoG5AQIxjg//U5/16K+51uVOP8f6WSHuFk96rAuExqLc
7N7iSB2+izvgcmyXcPvW5hUh8CN9nA+SyJkzqw3M5xrRjeWHSkzY1KisnzBjqKzU
dA+V6nfFtK+K0+W0ldwuzTv0ijWSomx4dZDpE4FGhRp+LKgVmz8ZsHhqUomfKJFK
fbwGMOHV1FZ10GQxH8VTCt3uHHLbAMKir/CmN/tdLmUkOAPTZV1dlqaxDHovyH/t
OWTkugOi3hx8LXFz1kTP/hZfCgTREVgy9Wil8lzJIKfyHWb/fzGCxZapu+bgXglA
pkfBlwjZdbWQzp3n4/WrOAoLaiRw/rCoSDPEjjLj1pduhC78F2wUFHKtOBG2ZMl3
hL2/Mrr4dcZxvr4oifglg1HvUzf9K0VIH9bcxA4MOdeMcl0omsk7ndgi6LBDjswl
UR/Dh3T+BfLto/25VAmC7qKU1x4Oh8P/2MkB/tZR7xaYlDdvVBH/qpy4NJyPFy/o
kbkiUSY1sUYhhighDMo2qiXN4rmwi+eZAqgexvEDh3oe7WSrlSotVzcgDKexW79p
bq+j2X8c2029KDgbP1kCKwV7ph7LqUuEPv6Zg692eTeDsoFtwM4VCYJkdkXddOC3
RI+zrmu12N55OuDX9qu4rpBmaiAfZD84+FyHLg0TEq2McqiiMa7yRd8DYAxGz0Cx
W7D24CFWd9k=
=jbdM
-----END PGP SIGNATURE-----

--Sig_/VHBpuaDrKY6=+1V==UisKUD--
