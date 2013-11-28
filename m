From: Roman Mamedov <rm@romanrm.net>
Subject: Re: =?UTF-8?B?562U5aSN77yabWQ=?= raid5 performace 6x SSD RAID5
Date: Thu, 28 Nov 2013 10:46:25 +0600
Message-ID: <20131128104625.54a5fc94@natsu>
References: <1385118796.8091.31.camel@bews002.euractiv.com>
	<528FBBE5.80404@hardwarefreak.com>
	<1385369796.2076.16.camel@bews002.euractiv.com>
	<5293EF32.9090301@hardwarefreak.com>
	<20131126025210.GL8803@dastard>
	<52941C5D.1000305@hardwarefreak.com>
	<20131126061458.GM8803@dastard>
	<36ffd6f7-bfb0-4298-a18c-f45b07cab326@aliyun.com>
	<5296C98D.8000302@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y=vKWhxr_wBpPj8nO15LN2T"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5296C98D.8000302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: lilofile <lilofile@aliyun.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/y=vKWhxr_wBpPj8nO15LN2T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Nov 2013 22:41:49 -0600
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> > when the stripe_cache_size is set 4096.=20
...
> 2.  A 4KB stripe cache is too small for 6 SSDs, try 8KB

The stripe cache size setting is specified not in KB, but in pages per disk,
so a value of 4096 on x86 systems means 4096*4096*6 =3D 96 MB of cache for =
the
whole array.

--=20
With respect,
Roman

--Sig_/y=vKWhxr_wBpPj8nO15LN2T
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKWyqEACgkQTLKSvz+PZwgTIgCeOIwIBedGd1gx9rS9PIFKRfNN
3LMAmweg0RdOc96mlwheWpLnH5NmgEEc
=u8fl
-----END PGP SIGNATURE-----

--Sig_/y=vKWhxr_wBpPj8nO15LN2T--
