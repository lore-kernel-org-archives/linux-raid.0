From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: software raid rebuilding and O_DIRECT access (xfs_repair) slowness
Date: Thu, 1 Oct 2009 19:49:42 +0200
Message-ID: <200910011949.42542.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I'm running 2.6.27.35 kernel which oopsed and previously synced softrai=
d array=20
(md3) started to resync.

Now the xfs filesystem that was on md3 turned out to be corrupted. So I=
=20
started xfs_repair while resync was early at few percent.=20

The process took about 10 hours and resync was only at 11%!=20

 [=3D=3D>..................]  resync =3D 11.4% (97538752/855220032)=20
finish=3D2637544.6min speed=3D4K/sec

xfs_repair running was still running but went only to beginning of phas=
e2=20
(there are 7 phases total) and at that time was eating 0% cpu and 45% o=
f ram.=20
Process was in S state.

Total time 10 hours and I was nowhere near the end.

I killed xfs_repair, rebooted machine and:
[>....................]  resync =3D  2.9% (24841088/855220032) finish=3D=
105.6min=20
speed=3D130948K/sec

after it finished resyncing in +-that time I ran xfs_repair which took =
9=20
minutes to go through all 7 phases. Total time ~115minutes.

The question is now why software raid is soo slow when device is access=
ed with=20
O_DIRECT by xfs_repair? (that's hch guess on what's the problem). Is th=
is bug,=20
expected behaviour?

# cat /proc/mdstat
Personalities : [raid10] [raid1]
md3 : active raid10 sda4[0] sdf4[5] sde4[4] sdd4[3] sdc4[2] sdb4[1]
      855220032 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]

md1 : active raid10 sde2[0] sdb2[5] sda2[4] sdd2[3] sdf2[2] sdc2[1]
      6000000 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]

md0 : active raid1 sde1[0] sdb1[5] sda1[4] sdd1[3] sdf1[2] sdc1[1]
      497856 blocks [6/6] [UUUUUU]

md2 : active raid10 sde3[0] sdb3[5] sda3[4] sdd3[3] sdf3[2] sdc3[1]
      74991168 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]

unused devices: <none>

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
