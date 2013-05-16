From: NeilBrown <neilb@suse.de>
Subject: Re: Kernel crash at md_seq_show of drivers/md/md.c
Date: Thu, 16 May 2013 11:19:05 +1000
Message-ID: <20130516111905.671d02ff@notabene.brown>
References: <74AD8F6BA17DDA4EBE980849BC39C00D02803790@HKGMBOXPRD22.polycom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//s2jAxl=7ZY4j2qzaNslNyC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <74AD8F6BA17DDA4EBE980849BC39C00D02803790@HKGMBOXPRD22.polycom.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mo, Moore" <Moore.Mo@Polycom.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_//s2jAxl=7ZY4j2qzaNslNyC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 May 2013 20:11:52 +0800 "Mo, Moore" <Moore.Mo@Polycom.com> wrote:

> Dear Neil,
>=20
> 	Thank you for your clue. I make deeper trace after that and found anothe=
r suspicion point. Kernel maybe wakeup a mdk_thread which was kfree in fail=
ed case of mddev->pers->run(mddev).
>=20
> 	For make sure my guess, I add some printk in order to get more info. It =
seems that md_seq_show try to wake up a mdk_thread in mddev_unlock() before=
 md_seq_show return, but the thread was kfree already by "out_free_conf" ca=
se of run() function in drivers/md/raid10.c.
>=20
> 	The Oops report as attached.
>=20

I don't really have time for bug reports against ancient kernels - sorry.
If you think you've found a bug, please at least look in the current mainli=
ne
kernel to see if the code has changed, and preferably reproduce against the
current mainline kernel.

In this case the bug was fixed by commit
      01f96c0a9922cd9919baf9d16febdf7016177a12
18 months ago (linux 3.1).

NeilBrown


--Sig_//s2jAxl=7ZY4j2qzaNslNyC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUZQ0CTnsnt1WYoG5AQLtfw/+JcPOlWEhrXb8k/WdrQzrT4ii0laM8LqU
x+/TNf7xaByot28+/JdkDAPTYpH0/Q7q7jdo2tilQ2WqK9P0FlhRJwTUsxy8Bxnm
vhVS86lO17l0UuNt7e3jLAcnRvMnUx59dKQcwDI3Tf9i01c9o/qxwJrhVLh+FblT
uHStML5j/dl6TJN3DMCi/4vcl27iTRxAF5qig6s0p9SCrNB0GilUTB9FDL3BG/gq
Z6i2dhz1lXl7v6uNM7F6oWxPQjhFHhIHMM4Lz/4klWuPc6x1Th1dNfM/xgqXR9rD
Cmcq8WV1qxsV2swa6oRy4dlAprl98xQnBlrbno/vM4ft9Cs50g5W1v7Aq18nfOHY
ATebIGwWYfeAH+6XihZGsxpF0CQmDBjOgTxIDTu7KlQ5yTMvhd9UscyxAqG3sBBH
LhQGtFPXfa6v2DHgzvrp548LnhftD9vlS6hu+iqWblenPAXGNFfVvOqYfhagyjRE
U/eNzkTTlAjDGx0CzIT+44L2qQV4AMRGf5dZiVc1z3MOxoMwz7dGegYsip8Gv4eo
heCCZ1X+hOuyaIvdGTh+tqg/wFY1Xx2IGzDqgglk9LwIzdv1dZXrnJjnng2NRh3s
NGcVYhLZZs9Hd1Vq3wypOzoqIqYdVyW/yD3MvJNPRhHxlB3vKhMfHhWbTsnecHDT
shDLRChD+Q0=
=HIEj
-----END PGP SIGNATURE-----

--Sig_//s2jAxl=7ZY4j2qzaNslNyC--
