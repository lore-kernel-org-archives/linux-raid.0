From: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Subject: Help recovering an interrupted raid0 reshape
Date: Fri, 3 Apr 2015 19:22:15 -0700
Message-ID: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid0 array whose component devices are raid1 arrays. In an
attempt to expand the pre-existing raid0 array, I created a new raid1
device and then added it, growing the raid0 array.
But then the system lost power shortly after the reshaping began.

After rebooting the original two components are listed as spares in an
inactive raid4 array and the new component is not listed in
/proc/mdstat:


Personalities : [raid6] [raid5] [raid4] [raid1] [raid10] [raid0]
[linear] [multipath]
md124 : inactive md126[0](S) md127[1](S)
      3907022200 blocks super 1.2

md0 : active raid1 sda5[0] sdb2[1]
      107652416 blocks [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md125 : active raid1 sdh1[0] sdg1[1]
      2930134016 blocks super 1.2 [2/2] [UU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

md126 : active raid1 sdc1[0] sdd1[1]
      1953512312 blocks super 1.2 [2/2] [UU]

md127 : active raid1 sde1[2] sdf1[1]
      1953512312 blocks super 1.2 [2/2] [UU]

unused devices: <none>


Looking at the details of the inactive array shows that it is in a
reshape between raid0 and raid4:


/dev/md124:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 2
    Persistence : Superblock is persistent

          State : inactive

  Delta Devices : -1, (1->0)
      New Level : raid4
  New Chunksize : 512K

           Name : hordern:hordern1  (local to host hordern)
           UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
         Events : 14013

    Number   Major   Minor   RaidDevice

       -       9      126        -        /dev/md/beta
       -       9      127        -        /dev/md/alpha


And examining each component shows that they have a consistent view of
where in that reshape they are (based on the reshape position), but
not consistent in the size of the array:

/dev/md/alpha:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
           Name : hordern:hordern1  (local to host hordern)
  Creation Time : Fri Jan  2 09:59:40 2009
     Raid Level : raid4
   Raid Devices : 3

 Avail Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
     Array Size : 3907021824 (3726.03 GiB 4000.79 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=752 sectors
          State : active
    Device UUID : 63aaa2e4:2a09f495:8372c7f9:eb2f2773

  Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
  Delta Devices : -1 (4->3)

    Update Time : Sun Mar 29 15:11:35 2015
       Checksum : 8be5e0e6 - correct
         Events : 14013

     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/md/beta:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
           Name : hordern:hordern1  (local to host hordern)
  Creation Time : Fri Jan  2 09:59:40 2009
     Raid Level : raid4
   Raid Devices : 3

 Avail Dev Size : 3907022576 (1863.01 GiB 2000.40 GB)
     Array Size : 3907021824 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=752 sectors
          State : clean
    Device UUID : 6e6dce14:3ebb2bb5:187aa292:403a55f6

  Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
  Delta Devices : -1 (4->3)

    Update Time : Sun Mar 29 15:11:35 2015
       Checksum : f7526add - correct
         Events : 14013

     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/md/gamma:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6
     Array UUID : 1f4979ba:c49a77c0:59e689c2:bcc21c0a
           Name : hordern:hordern1  (local to host hordern)
  Creation Time : Fri Jan  2 09:59:40 2009
     Raid Level : raid4
   Raid Devices : 4

 Avail Dev Size : 5860265984 (2794.39 GiB 3000.46 GB)
     Array Size : 5860532736 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907021824 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 86403072 sectors
   Unused Space : before=1960 sectors, after=1953244160 sectors
          State : active
    Device UUID : 782873ea:e265ecd4:5cc80ddf:035ba2b4

  Reshape pos'n : 129067008 (123.09 GiB 132.16 GB)
  Delta Devices : 1 (3->4)

    Update Time : Sun Mar 29 00:05:29 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 710dc078 - correct
         Events : 673

     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)


When I stop the inactive array and try to assemble it from all three
components, I get an error about the superblock on the third component
not matching the other two components (which makes sense since the
array sizes are different):

hordern ~ # mdadm --verbose --verbose --assemble /dev/md/hordern1
/dev/md/alpha /dev/md/beta /dev/md/gamma
mdadm: looking for devices for /dev/md/hordern1
mdadm: UUID differs from /dev/md0.
mdadm: UUID differs from /dev/md/alpha.
mdadm: UUID differs from /dev/md/beta.
mdadm: UUID differs from /dev/md/gamma.
mdadm: UUID differs from /dev/md0.
mdadm: UUID differs from /dev/md/alpha.
mdadm: UUID differs from /dev/md/beta.
mdadm: UUID differs from /dev/md/gamma.
mdadm: UUID differs from /dev/md0.
mdadm: UUID differs from /dev/md/alpha.
mdadm: UUID differs from /dev/md/beta.
mdadm: UUID differs from /dev/md/gamma.
mdadm: superblock on /dev/md/gamma doesn't match others - assembly aborted


First, what could cause the initial two components to have a different
superblock than the newly added component? And can I convince them to
be the same?

Second, is there documentation anywhere about the internal process of
growing a raid0 array? Why does it convert to a raid4 array? And what
do the Delta Devices lines mean?

Third, is it possible to resume the reshape? If not, can it be reverted?

-- 
Jon
