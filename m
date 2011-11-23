From: NeilBrown <neilb@suse.de>
Subject: Re: md device io request split
Date: Thu, 24 Nov 2011 06:30:51 +1100
Message-ID: <20111124063051.33cdad37@notabene.brown>
References: <20111122093634.105520@gmx.net>
	<20111123133124.2042c1f4@notabene.brown>
	<20111123132216.162860@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yOj.FKrBE/3vRxDlRer.=sn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111123132216.162860@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon =?ISO-8859-1?B?U2No9m5ib3Ju?= <RSchoenborn@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yOj.FKrBE/3vRxDlRer.=sn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 14:22:16 +0100 "Ramon Sch=F6nborn" <RSchoenborn@gmx.net>
wrote:

> =20
> > RAID1 will only limit requests to 4K if the device beneath it is
> > non-contiguous - e.g. a striped array or LVM arrangement were consecuti=
ve
> > blocks might be on different devices.
>=20
> how does it know if a device is non-contiguous? Is there a way to have a =
dm device "marked" like that or force md to use bigger requests?
> Lets assume a host with about 20 raid1 devices consisting of dm-devices w=
ith the mentioned overhead - do you think that not splitting the requests c=
ould lead to a noticeable performance improvement?
>=20
> Thanx for your help,
> Ramon Sch=F6nborn

If the device provide a "merge_bvec_fn", then it is assumed to not be
contiguous.
dm always sets this on its devices.

I really have no idea what sort of overhead this creates.  You would need to
test it.
I assume you are using dm simply as a partitioning tool with a single linear
mapping per device.
If this is the case it should be safe for testing to remove the line

	blk_queue_merge_bvec(md->queue, dm_merge_bvec);

from drivers/md/dm.c and see how that change performance.  If you have any =
dm
targets more simple than a single linear mapping with will almost certainly
cause IO failure at some point so this should only be used for testing.

NeilBrown


--Sig_/yOj.FKrBE/3vRxDlRer.=sn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTs1J8Tnsnt1WYoG5AQJY3Q/+P+QVQlYCT2dIDKnrkDQ5SbMJI/UKW/JH
isyMV7tYSxqQKCj0igcEHX9zz12T/W9FczZsdZnTlJCuwRN2WzVU90mFdc0XpESc
aEAar3Ufd+8yB1qkMzc+k+tXtY4x83vWehu6AaAi+f4Bph7dMEptK8hkfSf42SQR
oR+k45Fd3zBEpBdCcP9Of8bo4DCFn5cBrzKml07hQ3fLUUMeDAuNbK1NEZBZSPF4
6xE86QrnbNk3nJ5tMONoWHVB4sjMhc1BptANIf53EjVqE/RkIvhv1aYPMynzCnYI
+aZU7fgP82FB8wvaEpN1cao1cqaOynaGUH/GgERLXxtO2RKaegBpwJGnsh8+1JBu
OJnSGTGMCF57d1yLns92v/Gwkl2xQA1RlY1GGqp2Mk8C5iOJQCUzmSpFRcLckeUP
wfjDWHDttHxYCn0Yrzh+Jd7pFmD5EVkN/j/hsAVIAzEypmRvHZpbkXzV9V1YKXVJ
AnZyIhLbEO3u3z5P7qwpAMYa13DVj7l+YPJzHlCTQd14B7ceeVPX+Zcg/0kOvJTR
pbVF8rZMxvX0fqpi+IMyJUviNDn296r3VOfbMx/V33jmy9bnbMriSKEEDRrRI9Ej
Bu0/Xz8FJkt2bX9+pziy/6mJpLJG+DYM0kp6P8J6zHo+MpmwLBbfCpG3wKMwMjO3
hKR+9T6yr7A=
=DgOn
-----END PGP SIGNATURE-----

--Sig_/yOj.FKrBE/3vRxDlRer.=sn--
