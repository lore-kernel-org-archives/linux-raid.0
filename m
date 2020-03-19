From: Glenn Greibesland <glenngreibesland@gmail.com>
Subject: Raid6 recovery
Date: Thu, 19 Mar 2020 20:55:25 +0100
Message-ID: <CA+9eyijuUEJ7Y8BuxkKaZ=v8zbPpwixOezngPjtJzaLsBd+A4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi. I need some help with recovering from multiple disk failure on a
RAID6 array.
I had two failed disks and therefore shut down the server and
connected new disks.
After I powered on the server, another disk got booted out of the
array leaving it with only 15 out of 18 working devices, so it won=E2=80=99=
t
start.
I ran an offline test with smartctl and the disk that got thrown out
of the array seems totally fine.

Here is where I think I made a mistake. I use the =E2=80=93re-add command o=
n
the disk. Now it is regarded as spare and the array still won=E2=80=99t sta=
rt.

I=E2=80=99ve been reading on
https://raid.wiki.kernel.org/index.php/RAID_Recovery and I have tried
`=E2=80=93assemble =E2=80=93scan =E2=80=93force =E2=80=93verbose` and manua=
l `=E2=80=93assemble =E2=80=93force` with
specifying each drive. Neither of them works (reporting that 15 out of
18 devices is not enough).

All drives has the same event count and used dev size, but two of the
devices has a lower Avail Dev Size, and a different Data Offset.

After a bit of digging in the manual and on different forums I have
concluded that the next step for me is to recreate the array using
=E2=80=93assume-clean and =E2=80=93data-offset=3Dvariable.
I have tried a dry run of the command (answering no to =E2=80=9CContinue
creating array=E2=80=9D), and mdadm accepts the parameters without any erro=
rs:


mdadm --create --assume-clean --level=3D6 --raid-devices=3D18
--size=3D3906763776s --chunk=3D512K --data-offset=3Dvariable /dev/md0
/dev/sdj1:262144s /dev/sdk1:262144s /dev/sdi1:262144s
/dev/sdh1:262144s /dev/sdo1:262144s /dev/sdp1:262144s
/dev/sdr1:262144s /dev/sdq1:262144s /dev/sdf1:262144s
/dev/sdb1:262144ss /dev/sdg1:262144s /dev/sdd1:262144s
/dev/sdm1:262144s /dev/sdf2:241664s missing missing /dev/sdc2:241664s
/dev/sdc1:262144s
mdadm: /dev/sdj1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdk1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdi1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdh1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdo1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdp1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdr1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdq1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdf1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdb1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: partition table exists on /dev/sdb1 but will be lost or
       meaningless after creating array
mdadm: /dev/sdg1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdd1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdm1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdf2 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdc2 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
mdadm: /dev/sdc1 appears to be part of a raid array:
       level=3Draid6 devices=3D18 ctime=3DWed Nov 14 22:53:28 2012
Continue creating array? N

My only worries now are the size and data-offset parameters. According
to the man page, the size should be specified in KiloBytes. It was
KibiBytes previously.
The Used Device Size of all array members is 3906763776 sectors
(1862.89 GiB 2000.26 GB).

Should I convert the sectors into KiloBytes or does mdadm support
using sectors as unit for =E2=80=93size and data-offset? It is not mentione=
d
in the manual, but I=E2=80=99ve seen it being used on different forum threa=
ds
and mdadm does not blow up if I try using it.

Any other suggestions?
