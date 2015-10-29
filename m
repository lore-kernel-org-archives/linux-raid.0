From: Clement Parisot <clement.parisot@inria.fr>
Subject: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Thu, 29 Oct 2015 16:59:41 +0100 (CET)
Message-ID: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr>
References: <404650428.13997384.1446132658661.JavaMail.zimbra@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <404650428.13997384.1446132658661.JavaMail.zimbra@inria.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

we've got a problem with our old RAID 6.
root@ftalc2.nancy.grid5000.fr(physical):~# uname -a
Linux ftalc2.nancy.grid5000.fr 2.6.32-5-amd64 #1 SMP Mon Sep 23 22:14:4=
3 UTC 2013 x86_64 GNU/Linux

root@ftalc2.nancy.grid5000.fr(physical):~# cat /etc/debian_version=20
6.0.8

root@ftalc2.nancy.grid5000.fr(physical):~# mdadm -V
mdadm - v3.1.4 - 31st August 2010

After an electrical maintenance, 2 of our HDD came in fail state. An al=
ert was sent that said everything was reconstructing.

g5kadmin@ftalc2.nancy.grid5000.fr(physical):~$ cat /proc/mdstat=20
Personalities : [raid1] [raid6] [raid5] [raid4]=20
md2 : active raid6 sda[0] sdp[15] sdo[14] sdn[13] sdm[12] sdl[11] sdk[1=
8] sdj[9] sdi[8] sdh[16] sdg[6] sdf[5] sde[4] sdd[17] sdc[2] sdb[1](F)
      13666978304 blocks super 1.2 level 6, 128k chunk, algorithm 2 [16=
/15] [U_UUUUUUUUUUUUUU]
      [>....................]  resync =3D  0.0% (916936/976212736) fini=
sh=3D16851.9min speed=3D964K/sec
     =20
md1 : active raid1 sdq2[0] sdr2[2]
      312276856 blocks super 1.2 [2/2] [UU]
      [=3D=3D=3D>.................]  resync =3D 18.4% (57566208/3122768=
56) finish=3D83.2min speed=3D50956K/sec
     =20
md0 : active raid1 sdq1[0] sdr1[2]
      291828 blocks super 1.2 [2/2] [UU]
     =20
unused devices: <none>

md1 reconstruction works but md2 failed as a 3rd HDD seems to be broked=
=2E A new disk has been successfully added to replace a failed one.
All of the disks of md2 changed to Spare state. We rebooted the server =
but it was worse.
mdadm --detail command show that 13 disks left on the array and 3 are r=
emoved.=20

/dev/md2:
        Version : 1.2
  Creation Time : Tue Oct  2 16:28:23 2012
     Raid Level : raid6
  Used Dev Size : 976212736 (930.99 GiB 999.64 GB)
   Raid Devices : 16
  Total Devices : 13
    Persistence : Superblock is persistent

    Update Time : Wed Oct 28 13:46:13 2015
          State : active, FAILED, Not Started
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : ftalc2.nancy.grid5000.fr:2  (local to host ftalc2.nan=
cy.grid5000.fr)
           UUID : 2d0b91e8:a0b10f4c:3fa285f9:3198a918
         Events : 5834052

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       8       16        2      active sync   /dev/sdb
      17       8       32        3      active sync   /dev/sdc
       4       8       48        4      active sync   /dev/sdd
       5       8       64        5      active sync   /dev/sde
       6       0        0        6      removed
      16       8       96        7      active sync   /dev/sdg
       8       8      112        8      active sync   /dev/sdh
       9       8      128        9      active sync   /dev/sdi
      18       8      144       10      active sync   /dev/sdj
      11       8      160       11      active sync   /dev/sdk
      13       8      192       13      active sync   /dev/sdm
      14       8      208       14      active sync   /dev/sdn

As you can see, RAID is in "active, FAILED, Not Started" State. We trie=
d to add the new disk, re-add the previously removed disks as they appe=
ars to have no errors.
2/3 of the disks should still contains the datas. We want to recover it=
=2E

But there is a problem, devices /dev/sda and /dev/sdf can't be re-added=
:
mdadm: failed to add /dev/sda to /dev/md/2: Device or resource busy
mdadm: failed to add /dev/sdf to /dev/md/2: Device or resource busy
mdadm: /dev/md/2 assembled from 13 drives and 1 spare - not enough to s=
tart the array.

I tried procedure on RAID_Recovery wiki
  mdadm --assemble --force /dev/md2 /dev/sda /dev/sdc /dev/sdd /dev/sde=
 /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sd=
m /dev/sdn /dev/sdo /dev/sdp
but it failed.
mdadm: failed to add /dev/sdg to /dev/md2: Device or resource busy
mdadm: failed to RUN_ARRAY /dev/md2: Input/output error
mdadm: Not enough devices to start the array.


Any help or tips on how to diagnose better the situation or solve it wo=
uld be higly appreciated :-)

Thanks in advance,
Best regards,

Cl=E9ment and Marc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
