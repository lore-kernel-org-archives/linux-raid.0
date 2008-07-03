From: Doug Ledford <dledford@redhat.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Thu, 03 Jul 2008 01:17:56 -0400
Message-ID: <1215062276.14196.6.camel@firewall.xsintricity.com>
References: <484F9A3E.7020709@rabbit.us>
	 <18512.25940.653867.623185@notabene.brown>  <486BFB03.7060100@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZtXFvckkCLChWO3wpFuM"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <486BFB03.7060100@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-ZtXFvckkCLChWO3wpFuM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 15:02 -0700, H. Peter Anvin wrote:
> Neil Brown wrote:
> > On Wednesday June 11, rabbit+list@rabbit.us wrote:
> >> Hello,
> >>
> >> The subject pretty much says it all - it obviously is not 0xFD, since =
there is=20
> >> nothing to autodetect. Is there some best practice/semi-standard way o=
f=20
> >> marking a raid component partition as such? After reading the specs 0x=
DA=20
> >> (non-fs data) comes to mind, but I figured I'll ask here.
> >>
> >=20
> > I (almost) alway make arrays out of whole devices, not partitions, so
> > I really never thought about this.
> >=20
> > I suspect 0xDA is safest and hence best.
> > I wonder if this should be suggested in the mdadm man page
> > anywhere.... anyone feel like creating a patch?
> >=20
>=20
> Why 0xDA?
>=20
> As far as I know, the closest thing there is to a registry is the list=20
> that aeb at least used to maintain.

Actually, if you are going to use version 1 superblocks anyway, then
just list the partitions as normal linux partitions.  The whole
linux-raid-autodetect partition type was originally only for auto detect
at bootup.  If you weren't using that feature, then standard linux type
was good enough.  And if you use version 1.1 or 1.2 superblocks, then
you really don't have anything to worry about since the location of the
superblock and the data start offset means that the partition won't get
accidentally recognized as a non-raid partition.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-ZtXFvckkCLChWO3wpFuM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhsYQQACgkQTzP9PM7pjw8uPQCcC2M+bOi7cLGi/4Sij7eP7iLx
wmEAnjfgkNZRGmFcEnyQDmmd6LB+UhkE
=X1VK
-----END PGP SIGNATURE-----

--=-ZtXFvckkCLChWO3wpFuM--

