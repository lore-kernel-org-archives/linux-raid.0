From: NeilBrown <neilb@suse.de>
Subject: Re: and again: broken RAID5
Date: Thu, 10 May 2012 20:45:16 +1000
Message-ID: <20120510204516.16571810@notabene.brown>
References: <4FAB7739.9000907@cgv.tugraz.at>
	<20120510192016.49cb9003@notabene.brown>
	<4FAB9632.5010206@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MHcQ8aqr=xx+9PylnyDcY.w"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAB9632.5010206@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Lars Schimmer <l.schimmer@cgv.tugraz.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MHcQ8aqr=xx+9PylnyDcY.w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 11:19:30 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 10/05/2012 10:20, NeilBrown wrote:
> > On Thu, 10 May 2012 10:07:21 +0200 Lars Schimmer<l.schimmer@cgv.tugraz.=
at>
> > wrote:
> [...]
> >> mdadm -E tells me e.g. for md1:
> >>
> >> /dev/sdh1:
> >> Events : 206286
> >>
> >> /dev/sdf1:
> >> Events : 206273
> >>
> >> /dev/sdi1:
> >> Events : 197114
> >>
> >> /dev/sdj1:
> >> Events : 206286
> [...]
> >>
> >>
> >> So all 4 disks see some diff state. Any chance on getting raid5
> >> running again and read some data from it?
> >>
> >> Does the mdadm -C --assume-clean option help me in that case anyhow?
> >
> > Just add --force the to --assemble command.
>=20
> I think I'd assemble from only 3 drives, sdh, sdf and sdj, because sdi's=
=20
> event count is so much lower it must be the one that was knocked out=20
> first and you probably want to resync onto it (or a fresh drive if it's=20
> actually faulty).

correct.  And that is exactly what "mdadm --assemble --force" will decide
too. :-)
It will assemble from h, f, j and exclude i.

NeilBrown

--Sig_/MHcQ8aqr=xx+9PylnyDcY.w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6ucPDnsnt1WYoG5AQJz6Q/8DQ9tyxl7KiLlNxeK0Sh4O02LAXiU7wWB
+4Aspk20vbvk7xXrv7UYl5f3x3peYf66pDDw1LhgB8Jl30kCXFeM9tOqTNoSRUNb
mjsSi1Z9F3fncFjlEyTkOWfR30NvMq/MUrt6OOoU7Z5DCt9bA3R/mpA6OzqxhJ1L
WQjwK04ZQ3rSEesoyj9yqRbqyM3yJ6MKtjBmFtT/S9VqWcrAJDfEbvqGaGTpFFHw
AjGBXdKtJfywQb9avMvxXdJV+PpAu+wCy1RP4NNygvdLtJTKauVJl0Lybt2FbqML
2uSk4WeMDB6muGOnf9S+Nchtq20Ht1ajYc+5kGeLhX7Z86uGiSJjthGGM0pFuMFa
J/H/ukH9CvrtVlt2SBq1QPbDdjFLuwagCCT8DnHojwfPiXp6wuSTd4Y6c31QVKfl
bm6lt7A4pKLEmH29WrKbz5WZWYaXfBfR9RpLSntP75uIGt4ZLp6FxLIyr1Xeh+Du
LY/ULc2JzAzQ+Jr/khMvjwIUpGa7J1ziJfecWCFqIFFuP9xIywtC0CqGKIL9ppB6
uxQBzyTafpS54rxRlF9zPLD6ItB41h6v+hd7br94GcnOIeD1TEWBG0bWW3E8yp8t
hOqNFECy6xDAKivsV2pNp9azec1QlKZnWy5MPALgmXbo/uoQseM4fk/+NeYLxRGz
wW/tkkyZqys=
=yl6W
-----END PGP SIGNATURE-----

--Sig_/MHcQ8aqr=xx+9PylnyDcY.w--
