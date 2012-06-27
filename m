From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Add "BlockedBadBlocks" flag when waitting rdev
 to be unlocked.
Date: Wed, 27 Jun 2012 13:55:07 +1000
Message-ID: <20120627135507.115e32f7@notabene.brown>
References: <201206181113442039690@gmail.com>
	<20120627134513.2a67fbb0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nxh1dhYm04pwb+DD7/14n7f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120627134513.2a67fbb0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/nxh1dhYm04pwb+DD7/14n7f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jun 2012 13:45:13 +1000 NeilBrown <neilb@suse.de> wrote:


> Thanks for finding this.  However I don't think your patch is quite corre=
ct.
> It would re-introduce a hang fixed by commit 43220aa0f22cd3ce5b3.
>=20
> I've applied the following instead.
>=20
....
> +		else
> +			/* Internal metadata will immediately
> +			 * be written by raid5d, so we don't
> +			 * need to wait here.
> +			 */
> +			rdev_dec_pending(rdev, mddev);
> +	}

... which is clearly wrong.  That last line is now

                        rdev_dec_pending(s.blocked_rdev, conf->mddev);

NeilBrown


> =20
>  	if (s.handle_bad_blocks)
>  		for (i =3D disks; i--; ) {


--Sig_/nxh1dhYm04pwb+DD7/14n7f
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+qEGznsnt1WYoG5AQJJaA//XWUCSg1NqHvgYNcbGb13nhtVzMu6c9C9
AJSNPxwQIRVC64lvQc1QNv5DcNBHRUGMKw2SwEr9FIJNsrGWw2NdNoJ6EcuGkmGe
9n7MskbR0R5cPSx2BduXhaRyfW45W8uFo9fRtm9DZf7rQJS0r5SSBvOM3+p7PtCG
BssROX3AT5uC6pDiSzOSAfVpYprLBxoJ24MvnaAhz1ObjwpbxvbTJbRPnP74Uu6D
U28TFh5RgTOLe76P0bjDg+lONkJjFsLmCwx1K/9wXIxgolXQhuONgNDPRnKZn561
TGt+CNOkedZj+6RHGOlDNRBiC0VHbgT7CLg9RR4G/llcdkwovJIXBT3HAy65vI+K
g1sbYobrFQnNjiKlA/N0EHmKAiA0FY5Dj3+fsM1zqornhDRlPA21hzUR9k5hbcTt
mgi/ItzEMpT384m4jytBIcJOV1pPySWGvgCkq0xrF/7ckGfSp2vtBnfDYMqf8JJE
4aprNZ2Y+HRD8hegpnZEMiyQR8r7FHDeA9MspBJAId1EG3xh7WP7xc/pYsx7Wgi+
xZHkY0pDdSAXMjgqsVaFubOtnuSjwfaDSTWOo7wMPI2CRGPUexTZlXIwWDbwEMac
TxBwzl7d2/kQJ6y5sO44I/fm93Sma2pIWJBStvfv3QTfPtyGbVRyNIY2ivX/L7+A
7/nOgESI8GI=
=I9GZ
-----END PGP SIGNATURE-----

--Sig_/nxh1dhYm04pwb+DD7/14n7f--
