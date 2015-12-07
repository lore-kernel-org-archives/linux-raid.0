From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: I/O errors without erros from underlying device
Date: Mon, 7 Dec 2015 17:05:26 +0100
Message-ID: <201512071705.27177.a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi.

4.3.0 kernel, raid6 array:

md7 : active raid6 sdg[10] sdad1[9] sdac1[8] sdag1[7] sdaf1[6] sdae1[5]=
 sdaj1[4] sdai1[3] sdah1[2] sdn1[1]
      31255089152 blocks super 1.2 level 6, 512k chunk, algorithm 2 [10=
/10] [UUUUUUUUUU]
      bitmap: 1/30 pages [4KB], 65536KB chunk

array had weird failure where many disks went into failed state but
remove && adding these disks "fixed" it (turns out not really fixed it)=
=2E

Unfortunately now some reads fail:

pread(4, 0x1483a00, 4096, 16003680464896) =3D -1 EIO (Input/output erro=
r)

To reproduce used xfs_io
 xfs_io -d -c "pread 16003680464896 4096" /dev/md7
pread64: Input/output error
which does pread exactly as shown above.

write also fails for that area:
xfs_io -d -c "pwrite 16003680464896 4096" /dev/md7
pwrite64: Input/output error

Note that nothing is written in dmesg when that happens.

I've tried various offsets and sizes of pread and at some point that wa=
s logged:
[  848.988518] Buffer I/O error on dev md7, logical block 3907148544, a=
sync page read

but no error from underlying devices.

List of bad blocks:
http://sprunge.us/XSWI

What can I do now?

(loosing data from that few sectors is acceptable if the rest will be r=
eadable)

Thanks,
--=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
