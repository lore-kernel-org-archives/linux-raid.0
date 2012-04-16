From: NeilBrown <neilb@suse.de>
Subject: Re: question about raid10 near copy info in man mdadm.
Date: Mon, 16 Apr 2012 16:01:10 +1000
Message-ID: <20120416160110.4bde6ee1@notabene.brown>
References: <201204161328097657740@gmail.com>
	<20120416154126.2fb059da@notabene.brown>
	<201204161346407034012@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C3l9_ZNdUKGdBZWwuRYyw.i"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204161346407034012@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/C3l9_ZNdUKGdBZWwuRYyw.i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 13:46:46 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> This is the man md about:
> 		When 'near' replicas are chosen, the multiple copies of a given chunk a=
re laid out consecutively  across
>        the  stripes  of  the  array,  so the two copies of a datablock wi=
ll likely be at the same offset on two
>        adjacent devices.

"likely" is different from "certainly".  In most cases they are the same
offset.  In some cases they are different offsets.  I think "likely"
describes that well enough.

>=20
> I think the word "similar" is the same.=20

"similar" is not the same as "same", though it is similar .....

"same" means there is no difference.
"similar" means there might be a difference, but it is not a big difference.

Does that clear it up?

NeilBrown



--Sig_/C3l9_ZNdUKGdBZWwuRYyw.i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4u1pznsnt1WYoG5AQKWnA/9GaLj1fCaQraTbpwNN3tDeeYelxv0PcJE
NvmSP6Sttu+ZKvxFbeYej4U9tJOE87KvupTCSprkPEzph4/DwUxvEkqh00pRVWUd
nvDZJBoxl8ddBOEXNp7WOIFX46QuISZt+1gRuqq9PTFS2PvRbYhvS09Lazh3JxYU
lb4vECKgPxYPhWJtpCOAc+2ohtOzX/sScOzmqjCSXVpzRW2SFP7crEesjyvoqZEv
k//jNoQ00590vqS+7s+DMfuF4G0+5gmVPsCvzPTaiipbjV1OuBucrc0RlDtcFB9v
ZrNgcx1YBUk6DXaHxGZkT09Om3JXtu5kdjzRIyqueLoBzoigulrIxLpHZivAROWX
qKAKFxpWIm7X4Rudd4SH0SFCi6C6w325JDRuamNZ2mpUHpEHQY+eSwMXn8A4wi92
0G2OFy57jVnEVDLj/Bgjn0NJugmHAKGc0vT3yu3/hPDPlUtXeHPVLhm92OjPRtCd
HBpfBZVpVrODlEnd299Ik7ImfypbV81ndaEGhAfFe7l0S/DHTJUG/Rh9SvWYSRrQ
0a/q0H6XKnHf4lj58Ed0ldgCjoVJx+sToTZbM2HJWQ7R2wcxEptLx5comFKZBEhp
26HSiRrTWJ8e0b0tHkP5N/n7snSHwB15cpCO2JzhWikUrVTlxrKISnUiO2eEodjx
Z0jdU9bpN8k=
=WGiA
-----END PGP SIGNATURE-----

--Sig_/C3l9_ZNdUKGdBZWwuRYyw.i--
