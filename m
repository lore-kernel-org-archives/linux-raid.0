From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: lilo -x mbr
Date: Tue, 15 Mar 2005 09:37:13 +0100
Message-ID: <20050315093713.5b0eb734@zrr.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List

I got a question:

Do I need to mount /dev/md0 to /boot before I do a "lilo -x mbr"?

A df gives me:
biggie lilo-22.6 # df
=46ilesystem           1K-blocks      Used Available Use% Mounted on
/dev/md1             877450136 293983020 583467116  34% /
none                    451972         0    451972   0% /dev/shm

I recompiled my Kernel and now I need to run Lilo.

I got a RAID5 on root (/dev/md1) and a RAID1 on /boot (/dev/md0)

Both RAIDS are up an running:
Personalities : [raid1] [raid5] [raid6]=20
md1 : active raid5 sdd3[3] sdc3[2] sdb3[1] sda3[0]
      877509888 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]
     =20
md0 : active raid1 sdd1[3] sdc1[2] sdb1[1] sda1[0]
      40064 blocks [4/4] [UUUU]

Thanks for your help and Feedback.
Zeno

--=20
Mit freundlichen Gr=FCssen / best regards

Zeno Davatz
Verkauf & Akquisition

+41 43 540 05 50

www.ywesee.com > intellectual capital connected > www.oddb.org

pub  1024D/D77B920F 2003-06-24=20
Schl.-Fingerabdruck =3D 0182 6A3A 541E C198 032B  4A92 0840 EBA0 D77B 9=
20F

--=20
Mit freundlichen Gr=FCssen / best regards

Zeno Davatz
Verkauf & Akquisition

+41 43 540 05 50

www.ywesee.com > intellectual capital connected > www.oddb.org

pub  1024D/D77B920F 2003-06-24=20
Schl.-Fingerabdruck =3D 0182 6A3A 541E C198 032B  4A92 0840 EBA0 D77B 9=
20F
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
