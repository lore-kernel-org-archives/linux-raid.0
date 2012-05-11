From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: and again: broken RAID5
Date: Fri, 11 May 2012 09:27:39 +0200
Message-ID: <4FACBF6B.1050006@cgv.tugraz.at>
References: <4FAB7739.9000907@cgv.tugraz.at> <20120510192016.49cb9003@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120510192016.49cb9003@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2012-05-10 11:20, NeilBrown wrote:
> On Thu, 10 May 2012 10:07:21 +0200 Lars Schimmer
> <l.schimmer@cgv.tugraz.at> wrote:

>> Does the mdadm -C --assume-clean option help me in that case
>> anyhow?
>=20
> Just add --force the to --assemble command.

Thank to all, mdadm worked like a charm and I could read out data.
=46ine solution.

> NeilBrown
>=20

MfG,
Lars Schimmer
- --=20
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+sv2oACgkQmWhuE0qbFyOmCACfc+BNDJvZ7N31Ef15HNUhalYk
GagAmwSY/RQYaQ4WE4Ma1bbTsfxSaDuF
=3DTaRt
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
