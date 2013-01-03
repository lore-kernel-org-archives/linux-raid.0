From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID5 member disks shrunk
Date: Thu, 3 Jan 2013 21:42:36 +0600
Message-ID: <20130103214236.3fe60580@natsu>
References: <op.wqcditj08s54ea@metabuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/clP6C2P3EW2ijbU0n+.ILu1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.wqcditj08s54ea@metabuntu>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Leach <beamesleach@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/clP6C2P3EW2ijbU0n+.ILu1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 03 Jan 2013 15:33:55 -0000
"Alex Leach" <beamesleach@gmail.com> wrote:

>    9. Putting it back together, I accidentally connected one of the good =
=20
> RAID member drives to the SAS controller, and the SAS drive into one of =
=20
> the SATA ports, which has an Intel ICH10R controller.

Try checking if your controller/BIOS have shrunk the disk by establishing an
HPA on it, the easiest way to check if you have any is perhaps with=20

  dmesg | grep HPA

If that is indeed the case, you can control it with "hdparm -N" (see its ma=
n page).

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/clP6C2P3EW2ijbU0n+.ILu1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDlpuwACgkQTLKSvz+PZwjk1QCfXQ5VOUqpDKYKe0uro3adW1mN
nyQAnjoiu3vt5yyeAxn+bHcf248mXeMP
=g56N
-----END PGP SIGNATURE-----

--Sig_/clP6C2P3EW2ijbU0n+.ILu1--
