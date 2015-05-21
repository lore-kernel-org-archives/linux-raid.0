From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 working correctly, error messages during boot
Date: Thu, 21 May 2015 21:24:47 +1000
Message-ID: <20150521212447.0f6cae8d@notabene.brown>
References: <CE885044-F8E8-4286-9CAC-1D17560F1E79@me.com>
	<20150521212049.6f9cf650@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MLTskUldiBLqaMs0KcuzUkV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150521212049.6f9cf650@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Malissa <hmalissa@me.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/MLTskUldiBLqaMs0KcuzUkV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 21 May 2015 21:20:49 +1000 NeilBrown <neilb@suse.de> wrote:

> Adding the 'md' arg to the "mkinitrd" command might be sufficient, but I
> don't have a 12.2 install lying around that I can play with.

Make that  "mkinitrd -f md".

NeilBrown

--Sig_/MLTskUldiBLqaMs0KcuzUkV
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV3Afznsnt1WYoG5AQIIJQ/8C12hz2dK5ItYyJfTi5WVyw2rCEl+KZhK
9mGk8wD6S6PvOfLI2EnSwkaZOzJe3C3EbQTpwEk9Ew9XNq0jehIkDltNot3JhQXL
porBa0PbzDtJoHKeDgr9Vd7V7Mpo6RSro04P7MkajiCsbw/WVCCXjDgRDJpV9on3
Mj75UvgEEJwknibuqsamw8cj8YwtTcV3eennRYAxU0glnuKt4GRqPMdIBC9lptVA
zWA4PAWT210uBAtlnEPZBvGuutLc8QyUMvbHIWdCGhuWXT22DWnlms+OkflC+RHf
U/PqZBULD6ihCr0ioYCMuWLhRt70Ggw55X6q9TpppMWNJTx2SUFZ4qLgbSmK6IVQ
ireegCkGppSRH9g51Z92+9epW5xkA6mRy1CC6bId7WXlR129qJY/Cd4DLBl64gPo
F+/cEwZzlnCtmAPu1cxJ/ajvomCh5c2HS/ZWtS2gG1VM1q4z6EFjKMqXfgZMNCA8
//EceAnkodzfY1qjGN4xwSdOVOwJRdUiK1Q/ucom13TjIPIFwjk3U8E2JWlyh91b
HviKQ6EROIswXIwoiUbSF8Ww/DEyZfoLUOnyofZ2vuwN+jWOgEERAMsrJ7dz3fmJ
v8ssiqIz3M+Zu3kCfehf00UfgY36IOUXhNBrpLz99g7Ov9T+5v5STNAkvapPnKdW
uenHEu3fuH4=
=wy2s
-----END PGP SIGNATURE-----

--Sig_/MLTskUldiBLqaMs0KcuzUkV--
