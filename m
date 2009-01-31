From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
  can see them
Date: Sun, 01 Feb 2009 07:50:09 +1300
Message-ID: <49849D61.5040602@sauce.co.nz>
References: <49402CFE.3080708@gmail.com>	<18759.8246.568849.244513@notabene.brown>	<494AC8BA.7010704@gmail.com> <18762.53424.819087.495066@notabene.brown> <49736C2A.3050108@gmail.com> <49844FD9.2090705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49844FD9.2090705@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tor Arne Vestb=F8 wrote:

> Changed the DEVICE line in my mdadm.conf from:
>=20
>   DEVICE partitions
>=20
> to
>=20
>   DEVICE /dev/sd[bcdef]1
>=20
> Now the array is assembled correctly at boot.

A safer way of acheiving this is to list the array in mdadm.conf by=20
UUID, which will guarantee all the correct devices are used - sd device=
s=20
can move around under some conditions.

eg.

ARRAY /dev/md1 level=3Draid1 num-devices=3D2=20
UUID=3Df6bd7495:52288189:40f44282:1c220686
ARRAY /dev/md0 level=3Draid1 num-devices=3D2=20
UUID=3Df7d720fe:a5d0724c:c9bd10fa:a496ed51

Note each ARRAY entry and UUID are entered as a single line.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
