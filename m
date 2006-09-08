From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: RAID5 fill up?
Date: Fri, 08 Sep 2006 15:41:40 +0200
Message-ID: <45017314.1080506@cgv.tugraz.at>
References: <45013873.5040006@cgv.tugraz.at> <450142AC.8010304@tls.msk.ru> <45016177.8080604@cgv.tugraz.at> <45016867.7080800@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45016867.7080800@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Tokarev wrote:
> Lars Schimmer wrote:
> []
>>>> mdadm --grow is your friend.
>> Oh, damn, right. I was focussed on --grow to add a new HD to the RAI=
D....
>> But isn=B4t there a switch to grow to max possible value?
>> Do I always have to search for the biggest value and type it in by h=
and?
>=20
> How about actually reading the fine manual? ;-P
>=20
>   -z, --size=3D
>=20
>               This value can be set with --grow for RAID level 1/4/5/=
6. If the
>               array  was created with a size smaller than the current=
ly active
>               drives, the extra space can be accessed using --grow.  =
The  size
>               can  be given as max which means to choose the largest =
size that
>               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^
>               fits on all current drives.

*damn* This must be the friday... Or I=B4m in weekend to fast.

THANKS so far.

> /mjt


MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFAXMUmWhuE0qbFyMRAtqjAJ96irdwtHjIEpvXbrq60a01VLAsMQCdHhCn
YIPwr2pZQ7cErVc9NxenxGA=3D
=3DKgy0
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
