From: Roman Mamedov <rm@romanrm.net>
Subject: Re: interesting MD-xfs bug
Date: Fri, 10 Apr 2015 09:43:36 +0500
Message-ID: <20150410094336.33cdba6b@natsu>
References: <5526E8E9.3030805@gmail.com>
	<20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com>
	<20150409225322.GH13731@dastard>
	<20150409231035.GI13731@dastard>
	<20150410093652.73204748@notabene.brown>
	<20150410013156.GH15810@dastard>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZzbDQ9jto2x/hOQhWcnDrTf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150410013156.GH15810@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: NeilBrown <neilb@suse.de>, Joe Landman <joe.landman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>
List-Id: linux-raid.ids

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 11:31:57 +1000
Dave Chinner <david@fromorbit.com> wrote:

> RAID 0 on different sized devices should result in a device that is
> twice the size of the smallest devices

> Oh, "RAID0" is not actually RAID 0 - that's the size I'd expect from
> a linear mapping.

> it's actually a stripe for the first 10GB, then some kind of
> concatenated mapping of the remainder of the single device.

It might be not what you expected, but it's also not a bug of any kind, just
the regular behavior of mdadm RAID0 with different sized devices (man md):

       If devices in the array are not all the same size, then once the sma=
ll=E2=80=90
       est device has been  exhausted,  the  RAID0  driver  starts  collect=
ing
       chunks  into smaller stripes that only span the drives which still h=
ave
       remaining space.

Once or twice this came VERY handy for me in real life usage.

--=20
With respect,
Roman

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUnVPgACgkQTLKSvz+PZwjkbwCeIoi2jyzrVKBj9c2u+Fsaom4e
9b0An157JtrqUfIAAtWz6bCp5RjJ11z0
=Un6C
-----END PGP SIGNATURE-----

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf--
