From: Scott Sinno <sinno@sinno.net>
Subject: RAID6 won't reassemble after disk controller failure
Date: Wed, 25 Mar 2015 11:19:58 -0400
Message-ID: <5512D21E.1010506@sinno.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Vaughan, Garrison (GSFC-606.2)[INTERNATIONAL TECHNOLOGY COALITION, INC]" <garrison.r.vaughan@nasa.gov>
List-Id: linux-raid.ids

     JBOD controller failed this morning - we've replaced it, and all
drives are being presented to the system again, however 'mdadm' refuses
to assemble the ARRAY.  I've tried assembling with '--force' flags but
it still won't...any help most appreciated.  I'm guessing I'll need to
recreate with '--assemble-clean'

[root@dsfs01 ~]cat /etc/redhat-release
CentOS release 6.6 (Final)
[root@dsfs01 ~]mdadm --version
mdadm - v3.3 - 3rd September 2013
[root@dsfs01 ~]uname -r
3.14.33

[root@dsfs01 ~]mdadm -A --force --verbose /dev/md10 /dev/sdbj /dev/sdbk
/dev/sdbl /dev/sdbm /dev/sdbn /dev/sdbo /dev/sdbp /dev/sdbq /dev/sdbi
/dev/sdbr /dev/sdbs /dev/sdbt
mdadm: looking for devices for /dev/md10
mdadm: /dev/sdbj is identified as a member of /dev/md10, slot 0.
mdadm: /dev/sdbk is identified as a member of /dev/md10, slot 1.
mdadm: /dev/sdbl is identified as a member of /dev/md10, slot 2.
mdadm: /dev/sdbm is identified as a member of /dev/md10, slot 3.
mdadm: /dev/sdbn is identified as a member of /dev/md10, slot 4.
mdadm: /dev/sdbo is identified as a member of /dev/md10, slot 5.
mdadm: /dev/sdbp is identified as a member of /dev/md10, slot 6.
mdadm: /dev/sdbq is identified as a member of /dev/md10, slot 7.
mdadm: /dev/sdbi is identified as a member of /dev/md10, slot 8.
mdadm: /dev/sdbr is identified as a member of /dev/md10, slot 9.
mdadm: /dev/sdbs is identified as a member of /dev/md10, slot 10.
mdadm: /dev/sdbt is identified as a member of /dev/md10, slot 11.
mdadm: added /dev/sdbk to /dev/md10 as 1
mdadm: added /dev/sdbl to /dev/md10 as 2
mdadm: added /dev/sdbm to /dev/md10 as 3
mdadm: added /dev/sdbn to /dev/md10 as 4
mdadm: added /dev/sdbo to /dev/md10 as 5
mdadm: added /dev/sdbp to /dev/md10 as 6 (possibly out of date)
mdadm: added /dev/sdbq to /dev/md10 as 7 (possibly out of date)
mdadm: added /dev/sdbi to /dev/md10 as 8 (possibly out of date)
mdadm: added /dev/sdbr to /dev/md10 as 9 (possibly out of date)
mdadm: added /dev/sdbs to /dev/md10 as 10 (possibly out of date)
mdadm: added /dev/sdbt to /dev/md10 as 11 (possibly out of date)
mdadm: added /dev/sdbj to /dev/md10 as 0

mdadm -E /dev/sdbj
/dev/sdbj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : clean
    Device UUID : 3bd0e7f2:cfc24add:122a7354:049efe95

    Update Time : Wed Mar 25 08:21:34 2015
       Checksum : 4a952f6a - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAAAA...... ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbk
/dev/sdbk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : clean
    Device UUID : 4ebd5ec0:24367c71:bd5d3b52:3910ebcb

    Update Time : Wed Mar 25 08:21:34 2015
       Checksum : dfec35ad - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 1
   Array State : AAAA........ ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbl
/dev/sdbl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : clean
    Device UUID : 8cf70b24:9cd55339:08f408d7:7719469b

    Update Time : Wed Mar 25 08:21:34 2015
       Checksum : 5f99aeed - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 2
   Array State : AAAA........ ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbm
/dev/sdbm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : clean
    Device UUID : 59816854:0a6eb50b:b8cb756e:497c2d77

    Update Time : Wed Mar 25 08:21:34 2015
       Checksum : d5ac0baa - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 3
   Array State : AAAA........ ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbn
/dev/sdbn:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 52c08937:e782b635:05d7f31c:7e7fa2ae

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : c8e56e1f - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbo
/dev/sdbo:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 2902c7b0:e0e0b31e:70e94404:1d8f10c4

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : 27df2ffb - correct
         Events : 7641

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbp
/dev/sdbp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : d83bf256:a2f59330:e3209784:ee201d00

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : 9c4947ad - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 6
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbq
/dev/sdbq:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : d2556b61:a6fa2608:7ad69e55:ff09a3f7

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : 46e30555 - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 7
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbi
/dev/sdbi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 4a19a417:b2c5909e:496d5266:23228c19

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : c62242cc - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 8
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbr
/dev/sdbr:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 1074ca9b:d9db5522:17055a3c:b6e69869

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : f422101b - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 9
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbs
/dev/sdbs:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 13afb79f:7d24a231:b5e165ab:6faff1c7

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : d4c0391b - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 10
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
mdadm -E /dev/sdbt
/dev/sdbt:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 903cfc6d:921b0a84:c0b4bc7e:27e28c86
           Name : dsfs01:10  (local to host dsfs01)
  Creation Time : Tue Nov  5 03:37:14 2013
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
     Array Size : 39068871680 (37258.98 GiB 40006.52 GB)
  Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=688 sectors
          State : active
    Device UUID : 3cc36ae5:6965ba18:d5ed98bb:ec757657

    Update Time : Wed Mar 25 08:21:30 2015
       Checksum : a14360ce - correct
         Events : 7638

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 11
   Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' ==
replacing)

