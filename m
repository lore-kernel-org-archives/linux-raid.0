From: NeilBrown <neilb@suse.de>
Subject: Re: Intent Bitmap size and performance
Date: Fri, 7 Feb 2014 08:21:41 +1100
Message-ID: <20140207082141.0dc67341@notabene.brown>
References: <20140202003915.GB25441@merlins.org>
	<20140202005646.GC25441@merlins.org>
	<20140202172832.30e33c05@notabene.brown>
	<20140206190519.GE25441@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w/aLzO_vWsrilA/FEEg9+n+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140206190519.GE25441@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/w/aLzO_vWsrilA/FEEg9+n+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Feb 2014 11:05:19 -0800 Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Feb 02, 2014 at 05:28:32PM +1100, NeilBrown wrote:
> > On Sat, 1 Feb 2014 16:56:46 -0800 Marc MERLIN <marc@merlins.org> wrote:
> >=20
> > > On Sat, Feb 01, 2014 at 04:39:15PM -0800, Marc MERLIN wrote:
> > > > How can I tell I got the size for my array size?
> > >=20
> > > Aah, the clue seems to be in the kernel logs:
> > > [669348.274368] md7: bitmap file is out of date (0 < 38029) -- forcin=
g full recovery
> > > [669348.299174] created bitmap (15 pages) for device md7
> > > [669348.316720] md7: bitmap file is out of date, doing full recovery
> > > [669348.380555] md7: bitmap initialized from disk: read 1 pages, set =
29809 of 29809 bits
> > >=20
> > > If I got the math right, 30K bits for 8TB is one bit per 266MB.
> > >=20
> > > Given that, I'm going to assume that this is not going to impact syst=
em
> > > performance much for most operations.
> > >=20
> > > Is my assumption and conclusion correct?
> > >=20
> > > Thanks,
> > > Marc
> >=20
> > You can also use "mdadm --examine-bitmap" on one of the component devic=
es to
                                                            ^^^^^^^^^^^^^^^=
^^
> > get more details about the bitmap.
>=20
> Thanks, I had managed to miss this in the man page.
>=20
> Argh, not good then, see:
> gargamel:~# mdadm --examine-bitmap /dev/md5

You wanted something like
    mdadm --examine-bitmap /dev/sda1

The bitmap, like other metadata, lives in the component devices, not in the
array.
You certainly aren't the first to suffer this confusion - maybe I should try
to make mdadm catch that failure mode..

NeilBrown


>         Filename : /dev/md5
>            Magic : 534b554c
> mdadm: invalid bitmap magic 0x534b554c, the bitmap file appears to be cor=
rupted
>          Version : 16826042
> mdadm: unknown bitmap version 16826042, either the bitmap file is corrupt=
ed or you need to upgrade your tools
> gargamel:~# mdadm --examine-bitmap /dev/md8
>         Filename : /dev/md8
>            Magic : 534b554c
> mdadm: invalid bitmap magic 0x534b554c, the bitmap file appears to be cor=
rupted
>          Version : 16826042
> mdadm: unknown bitmap version 16826042, either the bitmap file is corrupt=
ed or you need to upgrade your tools
>=20
> md8 I just created a few weeks ago.
> md5 is old-ish but I just added the bitmap with --grow.
>=20
> kernel: 3.12.7
> gargamel:~# mdadm --version
> mdadm - v3.3 - 3rd September 2013
>=20
> gargamel:~# apt-get install -t unstable mdadm
> Reading package lists... Done
> Building dependency tree      =20
> Reading state information... Done
> mdadm is already the newest version.
>=20
> Is debian unstable too old, or do I have another bug?
>=20
> > My rule-of-thumb (base on zero hard evidence) is that one bit should
> > correspond to approximately 1 second of IO.  Your bits correspond to 2 =
or 3
> > seconds so that is certainly the right ball park.
> >=20
> > As always with RAID, performance is highly dependent on load.
> > It is quite easy to add and remove bitmaps to/from a live md array so
> > testing the effect on a particular workload is not that hard.
> >=20
> > The default mdadm chooses is a bit complex.  It first chooses an amount=
 of
> > space to reserve for the bitmap, the it figures what chunk size will al=
low
> > the bits to fit in the available space.  Then makes sure that it as lea=
st
> > 64Meg.
>=20
> Thanks for explaining.
>=20
> Marc


--Sig_/w/aLzO_vWsrilA/FEEg9+n+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvP85Tnsnt1WYoG5AQLPWA/+J0H1jNxCrSt2cjldzszvMmvdTkfGvaQl
nyxWELh7LuA2XQucjAiFHDxvNeq7U91NZTELcd1w+RaB2I0ZLRLkKA/Kpkup5t+6
XpH/sfwpBNLJevneBgHFVnEJsLKOKx4l+pMoyp0Qezp1a2UHUoXcv7ynlZM49s4B
eJZsHL8H8SgsqwfxvuzUpNR6Zz4Tlvrrh+rr+Sd0VPy9WS9GHRfZCuPGPSF33s9u
dm1wDVKvYLyxyETnYZf7A0sXPYhmBoDCAw1g+EJM4ePI0yUGQYEjpmgPD6Ohn8Dj
BVBTDQdHciI1a/H9UWRjnSw05equ0LJ1QWgiWmDUr00WWICal91pTRPryBnqPuWl
KrWmCLCcPLzdppBCXucVBhs/Ll5vQFf8+Eg3I2B4CQMULZG3Tf3UalXiPP4BEYf1
ex+34FymdkuCo6njgMU2EGI9j/03K2/ZcEbR65XY6DGf0D3cgGKrmXxKBqdMWlXz
OvcJ6q9we0U2O2FAwIASrtR8ciYREg9oXNrdwI1OxfdOHpLdOCHddG5AV5v4NkFo
jdaKlxD2Dp4ppQPNajkEEBtkHqcqzORvABFtVo6EJ2jZHpgWAlZGUUMIKQF0kxKG
0aWA3tzOgh2hK0S9xm6Q+oPuyqND+tyyebG8HBkPcE8AvdFChU8JqsDCzCA/l44b
O9qV83CIyg8=
=H88F
-----END PGP SIGNATURE-----

--Sig_/w/aLzO_vWsrilA/FEEg9+n+--
