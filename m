From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50 boot problems
Date: Mon, 22 Apr 2013 08:10:15 +1000
Message-ID: <20130422081015.206aed16@notabene.brown>
References: <20130419174509.5892c4bd@natsu>
	<6085629.18.1366387086623.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/md_E.TYXavslddsU_oytxC1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6085629.18.1366387086623.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

--Sig_/md_E.TYXavslddsU_oytxC1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2013 17:58:06 +0200 (CEST) Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:

> > On Wed, 17 Apr 2013 20:45:40 +0200
> > Alexander Zvyagin <zvyagin.alexander@gmail.com> wrote:
> >=20
> > > I have almost working RAID50 (two RAID5 forms RAID0) in my
> > > Linux-mint13. When booting the system always ends up in initramfs
> > > shell, saying it cannot find the "root".
> >=20
> > Post a full dmesg of a failed boot-up;
> >=20
> > also try "rootdelay=3D10" kernel command line parameter.
>=20
> Please see http://paste.ubuntu.com/5721934/ for the full list, taken with=
 network console. This is with rootdelay=3D10

The "bind" messages are in random order so presumably udev running 'mdadm -=
I'
on each device as it appear to add it to an array.
However when the md0 and md1 devices appear, udev isn't being run on that.
So it looks like your udev rules file is wrong.
Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention mdadm and
post them.

NeilBrown

--Sig_/md_E.TYXavslddsU_oytxC1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRjxznsnt1WYoG5AQJCxhAAu1Cs1PEbQ36cjjfvmj/8MWWipS065bMx
CmKweMrwRZHuwb5xLIVh19qqs27x4bPEu285gApQKJIcFFUe+8HFQLkgYzQg4gom
SOI8J/3aaEwz7sRn27CatoEs1V73an9YXzFAoYfTNvmsYmjoFkH8xavTla3w03+0
1Aj8iR2NedRHBFeYmEoCeS0n8gYkQwdwlmNT7sc/UetgfheKIgn9OqQu+UQ36YCi
jgKrCsNmomI4NqPz5YOEnL2sYnB/iV/b9eS+jGVEJr/rhJWwue5doNM9COxy3ceF
9nM0QGzJ1nCeyNkvvMkECu8+hrh0T05cWlpBUkWOKWI+osYVp67XqYHF5NdmQOBM
3dUdXJakzxcQiEEWnUP8rC8Ld/8TKeGjYQeTYuDD2yjq0Ptil9v3D4kDdNzFTyHl
WR6Vb3AaxHQyWdMNb/V0E06gqUI7MSxNDHNdSdUOCzQB8CVj4PphDcIksyQCWbvo
1k7K9kqcUMdx/41S+56niOyKV3Zeur16KNAg2LNdfp80lxCRbcqsVcjpfMtFfOEy
dNvYv2mPp0mGvnRqm9HLLcGgaBZlPatM0LfbB8OJMuHmvKH8vGM0P0jTVGjoelET
kPAn5aUdKwyhl8QuTfsB0zcZePbaTDKtS83s+pnjT0xvsKeLt+5pqCUPkxtFgyf5
E+EXHslTJe0=
=Olp1
-----END PGP SIGNATURE-----

--Sig_/md_E.TYXavslddsU_oytxC1--
