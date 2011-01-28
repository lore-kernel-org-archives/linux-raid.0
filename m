From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: sub-array kicked out of raid6 on each reboot.
Date: Sat, 29 Jan 2011 01:21:56 +0500
Message-ID: <20110129012156.00a935ec@natsu>
References: <20110128211534.697017aa@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q0lRh44Qr5NuYppYBIJmBbf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110128211534.697017aa@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q0lRh44Qr5NuYppYBIJmBbf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Jan 2011 21:15:34 +0100
Janek Kozicki <janek_listy@wp.pl> wrote:

> Is it possible that the order in which the arrays were created,
> matters? Because when it worked I created the sub-array first, and
> then I created the BIG array. And currently the sub-array is created
> after the BIG one.

I believe the order in which they are listed in mdadm.conf matters here.
And after changing that file, you may need to rebuild your initramfs
(on current Debian, "update-initramfs -k all -u").

--=20
With respect,
Roman

--Sig_/Q0lRh44Qr5NuYppYBIJmBbf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1DJWQACgkQTLKSvz+PZwgS0gCgiMOjbJBozk4woXrA4yfkR9n+
CMYAnj8rbT/jI/7+561R6llFjEeufrF0
=AEA1
-----END PGP SIGNATURE-----

--Sig_/Q0lRh44Qr5NuYppYBIJmBbf--
