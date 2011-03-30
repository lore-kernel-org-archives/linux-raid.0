From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 23:50:52 +0600
Message-ID: <20110330235052.3a803d35@natsu>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
	<20110330144944.3c87185c@natsu>
	<4D933188.30003@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u_8rKrBYH/eVe9icAv7xRTT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D933188.30003@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/u_8rKrBYH/eVe9icAv7xRTT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Mar 2011 08:35:04 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> If you want true block level replication over a network, look into DRBD.
>  However, it is also limited to mirroring.

So I guess a viable and interesting solution could be an mdadm stripe over =
two
or more DRBD mirrors, effectively providing RAID10. Although that's not qui=
te
what I am looking for (RAID5/6-levels of overhead and resilience).

--=20
With respect,
Roman

--Sig_/u_8rKrBYH/eVe9icAv7xRTT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2TbXwACgkQTLKSvz+PZwiWKgCfQ8XY6zNgpWQ8xVuyGaLEOjLE
Mj8An2YBBxBgBa6L8ld5u9FZ85OGzXug
=cVwj
-----END PGP SIGNATURE-----

--Sig_/u_8rKrBYH/eVe9icAv7xRTT--
