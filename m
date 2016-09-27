From: Roman Mamedov <rm@romanrm.net>
Subject: Re: WARNING: mismatch_cnt is not 0 on <array device>
Date: Tue, 27 Sep 2016 21:36:24 +0500
Message-ID: <20160927213624.739f80ba@natsu>
References: <26b91420-97c9-f405-aa71-16cd5cda3a67@gmail.com>
        <409d9f5f-6f72-a399-93ab-2b10323f4122@fnarfbargle.com>
        <c72d3567-7c9c-39dc-c2e1-722bc267bdd6@gmail.com>
        <74e5712f-e89e-97af-8aa4-ae2948c02e94@turmel.org>
        <c7bfde3e-0605-96d0-4e3d-fb76a9a8c724@gmail.com>
        <27577b8a-1b63-8f1a-9b68-b056622a5268@fnarfbargle.com>
        <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/RBriPU5._2Otn_utBLtv84I"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41c176d2-0235-6ff0-996c-b32dc95d487d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/RBriPU5._2Otn_utBLtv84I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2016 11:27:13 -0500
Benjammin2068 <benjammin2068@gmail.com> wrote:

> I think I did find the problem. The card was running hot due to airflow.
> That's been remedied (I hope) -- the temp sensor on the heat-sink for the
> PCIe controller now sits around 45'C which is fine. Before it was >=3D
> 60'C . :O

I wouldn't trust such controller anyway. 15 degrees difference and it
(allegedly) gives you silent data corruption? What if you have a particular=
ly
hot day, and/or the AC is out for a few hours.
There is a lot of better failure modes than this (honestly reported read or
CRC errors for a start, or heck, even complete lock-up of the controller wo=
uld
be more preferrable).

--=20
With respect,
Roman

--Sig_/RBriPU5._2Otn_utBLtv84I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfqoAoACgkQTLKSvz+PZwjmWQCfRZP5wUTjh2CuFfyPdCFvoaUr
i9UAn07n0EhllNAimrRH6h/9shPLEa4S
=Xe44
-----END PGP SIGNATURE-----

--Sig_/RBriPU5._2Otn_utBLtv84I--
