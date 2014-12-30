From: Xiao Ni <xni@redhat.com>
Subject: Can't reshape raid0 to raid10
Date: Mon, 29 Dec 2014 22:13:41 -0500 (EST)
Message-ID: <484995116.1735572.1419909221275.JavaMail.zimbra@redhat.com>
References: <1718053393.1731733.1419906625563.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1718053393.1731733.1419906625563.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

   When I try to reshape a raid0 to raid10, it'll fail like this:

[root@dhcp-12-133 mdadm-3.3.2]# lsblk=20
NAME                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                       8:0    0 111.8G  0 disk=20
=E2=94=9C=E2=94=80sda1                    8:1    0  1000M  0 part /boot
=E2=94=9C=E2=94=80sda2                    8:2    0  29.3G  0 part /
=E2=94=9C=E2=94=80sda3                    8:3    0   512M  0 part [SWAP=
]
=E2=94=9C=E2=94=80sda4                    8:4    0     1K  0 part=20
=E2=94=9C=E2=94=80sda5                    8:5    0   102M  0 part=20
=E2=94=94=E2=94=80sda6                    8:6    0  10.1G  0 part=20
  =E2=94=94=E2=94=80VolGroup00-LogVol00 254:0    0   9.9G  0 lvm =20
sdb                       8:16   0 111.8G  0 disk=20
=E2=94=9C=E2=94=80sdb1                    8:17   0     2G  0 part=20
=E2=94=94=E2=94=80sdb2                    8:18   0    10G  0 part=20
sdc                       8:32   0 186.3G  0 disk=20
=E2=94=9C=E2=94=80sdc1                    8:33   0     2G  0 part=20
=E2=94=94=E2=94=80sdc2                    8:34   0    10G  0 part=20
sdd                       8:48   0 111.8G  0 disk=20
=E2=94=9C=E2=94=80sdd1                    8:49   0     2G  0 part=20
=E2=94=94=E2=94=80sdd2                    8:50   0    10G  0 part=20
[root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb1 /d=
ev/sdc1 /dev/sdd1=20
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/sdb2=
 /dev/sdc2 /dev/sdd2=20
mdadm: level of /dev/md0 changed to raid10
mdadm: add new device failed for /dev/sdb2 as 6: No space left on devic=
e

  =20
   But if I reshape the raid0 to raid5, reshape raid5 to raid0, then re=
shape raid0 to raid10 use
the same command it'll succeed.=20

[root@dhcp-12-133 mdadm-3.3.2]# mdadm -CR /dev/md0 -l0 -n3 /dev/sdb1 /d=
ev/sdc1 /dev/sdd1
[root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l5
[root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]=20
md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
      6285312 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [=
UUU_]
     =20
unused devices: <none>

[root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l0
[root@dhcp-12-133 mdadm-3.3.2]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0] [raid10]=20
md0 : active raid0 sdd1[2] sdc1[1] sdb1[0]
      6285312 blocks super 1.2 512k chunks
     =20
unused devices: <none>
[root@dhcp-12-133 mdadm-3.3.2]# mdadm --grow /dev/md0 -l10 -a /dev/sdb2=
 /dev/sdc2 /dev/sdd2=20
mdadm: level of /dev/md0 changed to raid10
mdadm: added /dev/sdb2
mdadm: added /dev/sdc2
mdadm: added /dev/sdd2

    So I guess it's the problem add the disk to raid10 after the reshap=
ing. In the function
super_1_validate, it'll set the  mddev->dev_sectors using the superbloc=
k read from disks.=20
If it's raid0, the le64_to_cpu(sb-size) is 0. So when add disk to raid1=
0 bind_rdev_to_array
return -ENOSPC.

    When create raid0, it doesn't write give the value to s->size. So t=
he sb-size is 0.
I modify the code about Create.c. I'm not sure whether it's right to do=
 so. But it can resolve=20
the problem.

diff --git a/Create.c b/Create.c
index 330c5b4..f3135c5 100644
--- a/Create.c
+++ b/Create.c
@@ -489,7 +489,7 @@ int Create(struct supertype *st, char *mddev,
                        pr_err("no size and no drives given - aborting =
create.\n");
                        return 1;
                }
-               if (s->level > 0 || s->level =3D=3D LEVEL_MULTIPATH
+               if (s->level >=3D 0 || s->level =3D=3D LEVEL_MULTIPATH
                    || s->level =3D=3D LEVEL_FAULTY
                    || st->ss->external ) {
                        /* size is meaningful */



  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
