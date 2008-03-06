From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: 16 HDDs too much for RAID6?
Date: Thu, 6 Mar 2008 10:01:28 +0100
Message-ID: <20080306100128.8daad6bd.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo!

Here we have another problem with our RAID6 and 16 HDDs:

monosan:~ # mdadm -V
mdadm - v2.6.2 - 21st May 2007
monosan:~ # mdadm -C /dev/md4 -l6 -n 16 -x 0 /dev/dm-*
mdadm: /dev/dm-0 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-1 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-10 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-11 appears to contain an ext2fs file system
    size=3D-2147483648K  mtime=3DThu Jan  1 01:00:00 1970
mdadm: /dev/dm-11 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-12 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-13 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-14 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-2 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-3 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-4 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-5 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-6 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
mdadm: /dev/dm-7 appears to be part of a raid array:
    level=3Draid6 devices=3D15 ctime=3DWed Feb 13 10:38:52 2008
Continue creating array? y
mdadm: array /dev/md4 started.

monosan:~ # mdadm --detail --scan| fgrep md4 >> /etc/mdadm.conf=20

monosan:~ # mdadm -S /dev/md4
mdadm: stopped /dev/md4

monosan:~ # mdadm -A /dev/md4
mdadm: WARNING /dev/dm-9 and /dev/dm-8 appear to have very similar supe=
rblocks.
      If they are really different, please --zero the superblock on one
      If they are the same or overlap, please remove one from the
      DEVICE list in mdadm.conf.

This happens _always_ when the arreay is reassembled. The actual device=
s with the duplicated superblocks differ sometimes.

Are 16 drives too much for RAID6?

Thanks
Lars

--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
