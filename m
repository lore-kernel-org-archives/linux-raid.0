From: NeilBrown <neilb@suse.de>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Fri, 29 Jun 2012 07:36:32 +1000
Message-ID: <20120629073632.61f529a8@notabene.brown>
References: <4FE9BFC1.5070607@xunil.at>
	<20120628163205.2c6a1122@notabene.brown>
	<4FEC1CE7.5010709@xunil.at>
	<4FEC2071.8010504@xunil.at>
	<20120628212257.5ca8fb05@notabene.brown>
	<4FEC7EB7.1000401@xunil.at>
	<4FECA1A8.7090608@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Kn4F3bGy642bVKtYJwv9ZY0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FECA1A8.7090608@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Kn4F3bGy642bVKtYJwv9ZY0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 20:25:44 +0200 "Stefan G. Weichinger" <lists@xunil.at>
wrote:

> Am 28.06.2012 17:56, schrieb Stefan G. Weichinger:
>=20
> > md0 : active raid6 sdb3[4](S) sda3[5] sdc3[2] sdd3[3]
> >       3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]
> >       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>....]  recovery=
 =3D 83.0%
> > (1621636224/1951945600) finish=3D81.5min speed=3D67477K/sec
> >=20
> > I assume it is OK in this state of things that sdb3 is marked as
> > (S)pare ...
>=20
> It seems so, as now it has entered the next stage:
>=20
> md0 : active raid6 sdb3[4] sda3[0] sdc3[2] sdd3[3]
>       3903891200 blocks level 6, 64k chunk, algorithm 2 [4/3] [U_UU]
>       [=3D>...................]  recovery =3D  6.2% (122751744/1951945600)
> finish=3D784.6min speed=3D38854K/sec
>=20
> Somewhat slower, but no (S)pare there anymore.
>=20
> What is the logic behind that?

As you have guessed, it first recovered one device, then recovered the seco=
nd
one.
But it looks like there are no read errors on the two good devices, so
fear-not.

>=20
> What does it do exactly when it re-adds the first disk, what in the
> second round?
>=20
> Should I have added sd[ab]3 in one command?

Had you done that with a very new mdadm, it would have recovered both at on=
ce.
mdadm has to say:
  - disable recovery for now
  - here is one new spare
  - here is another spare
  - ok, you can try recovery now

otherwise as soon as it gets one spare it will start recovery.

>=20
> To me it also seems that I now have good redundancy again already, correc=
t?

Correct.  You have single redundancy and in about 10 hours since your email
you'll have double redundancy.

>=20
> Sorry for all my questions ;-)
> I just like to understand things, at least on my user-level.
>=20
> Stefan

No problem.

NeilBrown


--Sig_/Kn4F3bGy642bVKtYJwv9ZY0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+zOYDnsnt1WYoG5AQIUGhAArsQoEbNUx65POcA7GzQtcj4G+IOa5U/W
2lAjKlDUzhBOgLRWYJIObbqT392ietY0UVuWIRm4ttvQwwGeUR2clOJivLkn2ZdV
HzFmmYVbrijmAZYB2WlqaByCGbtqlpl29cjJl/wxy36IHaV/SjtRW8rE44Yf2lOn
j9XVLzZFft6jA+WvmyDBkL5uo5seXNdBQdWN15J+NjetWSZE1oIRhMggE3XVvV5G
aGVX63z0eONtybTIXRVp/ReRF2vGMX43xauzfBB60k9cDXKwdSv0eXCodpphUU4T
3nbZcOzP+MzpA+b1+p9uqFGnFgrq/L7/16VUALR84HvMZkv9H5pfAgiazWg4RMve
45lNODV79bFIz7k2i3GoEdI7cGYbosqGe/LJswvGfCulXmo3onCK0hn4t/ekFx/p
L9TOVxjXeuOHgmWblT4rLwPl1Ogb8/RrTWKKxGVWslJWUratuG6hds+B6meAI8+Z
gWgvazCoC0EF6ob2lc5KCx3ijUe9/uhNJQBFcZFkpTsgCr2L/KEBGTtJGFBmtoQR
gvoPxmW9EEBcCr8lM8k0K6KcjEB3OFey7UkmS3j6lVX1S3DCKIxeeD4D59W1X+5f
5Fm4EWjqcLDnqlFJh5xHEILbj1SLI9O6Kr5aXKtAzzULGKjA8XcO9ZaYeQNw5XML
1+oyw47ikGw=
=DNUn
-----END PGP SIGNATURE-----

--Sig_/Kn4F3bGy642bVKtYJwv9ZY0--
