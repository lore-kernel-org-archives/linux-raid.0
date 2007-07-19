From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: Slow Soft-RAID 5 performance
Date: Thu, 19 Jul 2007 14:32:38 +0200
Message-ID: <469F59E6.3050105@cgv.tugraz.at>
References: <469DE3BB.9070604@grupopie.com> <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707180626481.7659@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Justin Piszcz wrote:
>=20
>=20
> On Wed, 18 Jul 2007, Rui Santos wrote:
>=20
>> Hi,
>>
>> I'm getting a strange slow performance behavior on a recently instal=
led
>> Server. Here are the details:
>>
>> Server: Asus AS-TS500-E4A
>> Board: Asus DSBV-D (
>> http://uk.asus.com/products.aspx?l1=3D9&l2=3D39&l3=3D299&l4=3D0&mode=
l=3D1210&modelmenu=3D2
>>
>> )
>> Hard Drives: 3x Seagate ST3400620AS (
>> http://www.seagate.com/ww/v/index.jsp?vgnextoid=3D8eff99f4fa74c010Vg=
nVCM100000dd04090aRCRD&locale=3Den-US
>>
>> )
>> I'm using the AHCI driver, although with ata_piix, the behavior is t=
he
>> same. Here's some info about the AHCI controler:
>>
>=20
> With three disks, if everything was perfect yeah 120MB/s writes.  Whe=
n I
> had started out with 4 raptors I was getting 164MB/s read and write. =
 By
> default with no optimizations you will not get good speed.
>=20
> With no optimizations with 10 raptors I get 180-200MB/s, with
> optimizations, 464MB/s write and 622MB/s read.
>=20
> 1. Use XFS if you wan't speed.
> 2. Use 128k, 256k or 1MiB chunk size.
> 3. Use 8192k, 16384k stripe_cache_size.
> 4. Use 65536 readahead size.
>=20
> These are only some of the optimizations I use.

One question in between, which option of these I can set after RAID5 is
filled with data?
E.G. I setup a 9 disk SOFT-RAID5 with XFS and 3125669888 blocks level 5=
,
128k chunk, algorithm 2 [9/9] [UUUUUUUUU].
Speed is not really fast, I assume it could be faster.


> Justin.


MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGn1nmmWhuE0qbFyMRAoOVAJ9Yx9SAuGATJ84V4HPUpQOfX/tO1wCeLJt/
a4fi6VR1K/PudBUg4pUHHEw=3D
=3DLR6r
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
