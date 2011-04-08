From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Fri, 8 Apr 2011 15:17:51 +0600
Message-ID: <20110408151751.5e2b61f1@natsu>
References: <4D9EC097.7010600@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lLySOTH3YsnnHK+uuBiFDF/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9EC097.7010600@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Yann Ormanns <yann-ormanns@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lLySOTH3YsnnHK+uuBiFDF/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Apr 2011 10:00:23 +0200
Yann Ormanns <yann-ormanns@web.de> wrote:
=20
> So I put the following lines into /etc/mdadm.conf (I had forgot this
> before):
> "DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
> ARRAY /dev/md8
> devices=3D/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1"

After you do various changes to your mdadm.conf, don't forget to update your
initrd. AFAIK mdadm.conf is copied into the compressed initrd image to be u=
sed
early at boot, and this copy has to be kept in sync with your version in /e=
tc.

Typically you can update initrd for all installed kernels by running someth=
ing
like:

  update-initramfs -k all -u

--=20
With respect,
Roman

--Sig_/lLySOTH3YsnnHK+uuBiFDF/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2e0r8ACgkQTLKSvz+PZwjuGACfV2gYQx/mjsmt2GNmcL6ts3hp
XnsAoJWGvzskypuRH0JMgAIlBaFgI6h4
=CQEo
-----END PGP SIGNATURE-----

--Sig_/lLySOTH3YsnnHK+uuBiFDF/--
