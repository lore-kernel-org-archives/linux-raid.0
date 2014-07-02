From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 11:07:13 +0100
Message-ID: <20140702110713.Horde.4jCzQvYRo99Ts9nRe3Oy26A@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702155224.072d09ef@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702155224.072d09ef@natsu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Roman,

    Thanks for the reply and the correction on the "dd" command.

    - ext4 is in the kernel as the fs wouldn't mount otherwise and the =
=20
tools are the latest ones ( e2fsprogs 1.42.10 )

    root@nas3:/# fsck.ext4 -V
    e2fsck 1.42.10 (18-May-2014)
    Using EXT2FS Library version 1.42.10, 18-May-2014

   - Doing the correct "dd" command ( dd if=3D/dev/md0  of=3Dteste.txt =
=20
skip=3D458227712 count=3D16 bs=3D4096 ) will net the same dmesg errors =
and a =20
0 bytes file.

dd: reading `/dev/md0': Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000268007 s, 0.0 kB/s

[88623.524481] Buffer I/O error on device md0, logical block 458227712

  - I'm sure this is not a filesystem problem, but something fishy =20
with dm. As all disks are active and synced if one would have bad =20
sectors dm should read the sector from another one, but aparently it =20
is not doing that.

Cheers
Pedro


_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
