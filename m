From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH RESEND] Fix and extend raid6check repair
Date: Mon, 10 Sep 2012 17:39:25 +1000
Message-ID: <20120910173925.3e995909@notabene.brown>
References: <2586585.1GSuNNC3Ge@peanut>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dJjqZpW_RodBnFf8/kKpuE0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2586585.1GSuNNC3Ge@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Buchholz <robert.buchholz@goodpoint.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dJjqZpW_RodBnFf8/kKpuE0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012 14:55:43 +0200 Robert Buchholz
<robert.buchholz@goodpoint.de> wrote:

> Hello,
>=20
> this is a resend of my patches dated Jul 20th in the "Find mismatch in=20
> data blocks during raid6 repair" thread.
>=20
> Currently, the raid6check tool does not compile (due to the xmalloc=20
> changes) and my initial set of repair patches are faulty.  Please merge=20
> and see my original emails for extended comments
> http://thread.gmane.org/gmane.linux.raid/38922/focus=3D39454
> http://thread.gmane.org/gmane.linux.raid/38922/focus=3D39460
>=20
>=20
>=20
> Cheers
>=20
> Robert

Hi,
 sorry for the long delay in getting to these.
They mostly look OK.  However:

1/ They way you added 'autorepair' as a new, final positional parameter is
not good.  I understand why you did it (it was easy) but I think we really
need to bite the bullet and introduce proper "getopt" parameter parsing.

2/ your new test scripts (thanks for including them!!) call=20
   blockdev --flushbufs $md0
  after
    mdadm -S $md0
  This is pointless. Once $md0 is stopped, there can be no bufs to flush.
  I don't think there is any point in the 'udevadm settle' 'flushbufs' and
  'drop_caches' at the end.

I've applied your patches but if you could send updates to address those
issues, I'd appreciate it.

Also: please send one patch per email, preferably in-line (not an
attachment).  It makes it easier to reply to and also easier to apply.

Thanks,
NeilBrown

--Sig_/dJjqZpW_RodBnFf8/kKpuE0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE2ZLTnsnt1WYoG5AQLZSQ/+KkaQVB+lLioo/6rfuXTxEn/F6pakx+2q
cHG0na/E0hkS2pX4t28MT5w1UwQ5KBKImHNjai5PFNX6PEJ1l5f8A3owiUnKzvIC
+xZzzym24q2wOKDXcSkCLGJUacUzPQhqt86rYPtVWVcnCzkOwq9cI4m1KUcUZT9K
2K2LGkcOhIg6Ri2aeldXBT0MYbEYltnnwlUQfmizZeM4gQBwyIHrRX7WShP/tXj1
PFsZ5Npaxb+W8b7GX4RkrkX8/f8cFVrJOY+SF5kwqfHZzToUtSk2iAa15kGXPhIB
5f/basCAdVal+u5Ru6264jmTejvUYWeYr3wLSNh+pqgGJSvS+p2cy/AiUoO7JNBR
lcjpoIk2xLuWCLFFXRvLU1W/ePkHPbCaIACUMtlCQk27fSGuv80aDG+eOelvDYgR
Jgp0wQtey67ao/CwznZbA/e32TGD/DvzYl88rMvDrZ2+HdLPfX3MiW0DmamAncXZ
S0E8RWq2laRPMDjfrvuAMKQcJjNSausVmPeijYjb4jQ2BBkKkB4hmpIJI8R/hFnm
NraSZP4UWtu/1rd4589ySsYWH0UisT0hxd4S3p7eh3DbFH0u0SnDY0kdHmzD4qYn
jxlcypBpcDZAbOlhYTarZjEvzgkr0oZFSx7plt8tnG7E/qVvQlw3RdWOC4ByJa9f
Bw0BKHODvvc=
=j1Cb
-----END PGP SIGNATURE-----

--Sig_/dJjqZpW_RodBnFf8/kKpuE0--
