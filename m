From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Network-based RAID6
Date: Thu, 31 Mar 2011 11:16:13 +0600
Message-ID: <20110331111613.06079a0a@natsu>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
	<20110330144944.3c87185c@natsu>
	<4D933188.30003@hardwarefreak.com>
	<20110330235052.3a803d35@natsu>
	<4D94097A.3030909@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y0dC4J35+VPBE1feXLXnHS_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D94097A.3030909@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Y0dC4J35+VPBE1feXLXnHS_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Mar 2011 23:56:26 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Roman Mamedov put forth on 3/30/2011 12:50 PM:
> > So I guess a viable and interesting solution could be an mdadm stripe o=
ver
> > two or more DRBD mirrors, effectively providing RAID10. Although that's
> > not quite what I am looking for (RAID5/6-levels of overhead and
> > resilience).
>=20
> The mdraid driver sits beneath DRBD.  What you suggest above is impossibl=
e.

I thought DRBD presents just a regular kernel-level block device in /dev, a=
nd
seeing how one can create mdraid out of just any kind of block device,
including those provided by AoE, iSCSI, LVM, dmcrypt or even 'loop', are you
really sure this matters here?=20

--=20
With respect,
Roman

--Sig_/Y0dC4J35+VPBE1feXLXnHS_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2UDh0ACgkQTLKSvz+PZwiEcQCdFQPLrhWpOvk6v3b4UU4cncJ6
1ngAnj+5/N06EUeKtewRlx1+fHjYAcRp
=YoIk
-----END PGP SIGNATURE-----

--Sig_/Y0dC4J35+VPBE1feXLXnHS_--
