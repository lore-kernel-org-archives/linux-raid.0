From: Roman Mamedov <rm@romanrm.net>
Subject: Re: raid1 recoverable after system crash?
Date: Thu, 7 Apr 2016 18:00:04 +0500
Message-ID: <20160407180004.53615913@natsu>
References: <1460033086.27740.145.camel@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/RElC_QomqedTNTNz.VUqh4F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1460033086.27740.145.camel@interlinx.bc.ca>
Sender: linux-raid-owner@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RElC_QomqedTNTNz.VUqh4F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Apr 2016 08:44:46 -0400
"Brian J. Murrell" <brian@interlinx.bc.ca> wrote:

> # cat /proc/mdstat=C2=A0
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=C2=A0
> md0 : active raid1 sdd[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01953514496 blocks [2/1] [U_]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> md1 : active raid0 sdc[1] sdb[0]
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01953524736 blocks super 1.2 512k chun=
ks
...
> Is my only option here to fail/remove /dev/md1 from the array and re-
> add it that way or is there a more graceful recovery possible here?

You do not have a write intent bitmap at md0, so re-add will not work. Seems
like you should --add it now, then after it rebuilds use --grow to add a
bitmap, so that in the future you could use -re-add.

As to why the situation occured in the first place, you should ensure that =
md1
assembles before md0. Perhaps by listing both arrays in /etc/mdadm/mdadm.co=
nf
in the order you need (and don't forget to re-generate initrd.img).

--=20
With respect,
Roman

--Sig_/RElC_QomqedTNTNz.VUqh4F
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlcGWdkACgkQTLKSvz+PZwgTswCfWoYc0fVJSICHDGIbam+uIT/Y
/z4AoI5zH9ptIkZkJbvs4KIqLp75L61K
=yzTA
-----END PGP SIGNATURE-----

--Sig_/RElC_QomqedTNTNz.VUqh4F--
