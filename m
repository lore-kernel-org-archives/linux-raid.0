From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Performance question, RAID5
Date: Sun, 30 Jan 2011 04:57:06 +0500
Message-ID: <20110130045706.4e8d6fa2@natsu>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oo+1xe+RAUAaTX0lETMt__a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?UTF-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/oo+1xe+RAUAaTX0lETMt__a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Jan 2011 23:44:01 +0000
Mathias Bur=C3=A9n <mathias.buren@gmail.com> wrote:

> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>   SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
> 230x 4 Port SATA-II Controller (rev 02)
>     host6: [Empty]
>     host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>     host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>     host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }

Does this controller support PCI-E 2.0? I doubt it.
Does you Atom mainboard support PCI-E 2.0? I highly doubt it.
And if PCI-E 1.0/1.1 is used, these last 3 drives are limited to 250 MB/sec.
in total, which in reality will be closer to 200 MB/sec.

> It's all SATA 3Gbs. OK, so from what you're saying I should see
> significantly better results on a better CPU? The HDDs should be able
> to push 80MB/s (read or write), and that should yield at least 5*80 =3D
> 400MB/s (-1 for parity) on easy (sequential?) reads.

According to the hdparm benchmark, your CPU can not read faster than 640
MB/sec from _RAM_, and that's just plain easy linear data from a buffer. So=
 it
is perhaps not promising with regard to whether you will get 400MB/sec read=
ing
from RAID6 (with all the corresponding overheads) or not.

--=20
With respect,
Roman

--Sig_/oo+1xe+RAUAaTX0lETMt__a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1EqVIACgkQTLKSvz+PZwgTmACdHPJfvMBbJBPJ8Nr4YcBAifjC
OkEAnRUNrZFapULqL24WO21Mat8rri2+
=GJa0
-----END PGP SIGNATURE-----

--Sig_/oo+1xe+RAUAaTX0lETMt__a--
