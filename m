From: Joe Landman <joe.landman@gmail.com>
Subject: Question on how to mark drives on a particular raid as being good
	after a "failure"
Date: Mon, 19 Apr 2010 14:56:37 -0400
Message-ID: <t2n9f5edc121004191156r8dac06e5v4b9db17cf21d013c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks:

  We've seen a "failure" ... whereby something like 10 drives
simultaneously dropped out of a RAID6 array.  The drives haven't
failed, we can see them, see the metadata on them, see the RAID
partitions ... what we can't do is reassemble it into a RAID, as some
of the drives are note listed as "Active"


root@dv4:~# mdadm -v --assemble /dev/md0
mdadm: looking for devices for /dev/md0

...

mdadm: /dev/sdr3 is identified as a member of /dev/md0, slot 14.
mdadm: /dev/sdy3 is identified as a member of /dev/md0, slot 15.
mdadm: /dev/sdx3 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdw3 is identified as a member of /dev/md0, slot 21.
mdadm: /dev/sdv3 is identified as a member of /dev/md0, slot 20.
mdadm: /dev/sdu3 is identified as a member of /dev/md0, slot 19.
mdadm: /dev/sdt3 is identified as a member of /dev/md0, slot 18.
mdadm: /dev/sds3 is identified as a member of /dev/md0, slot 17.
mdadm: /dev/sdq3 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdp3 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdo3 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdn3 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdm3 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdl3 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdk3 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdj3 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc3 is identified as a member of /dev/md0, slot 9.
mdadm: /dev/sdi3 is identified as a member of /dev/md0, slot 16.
mdadm: /dev/sdh3 is identified as a member of /dev/md0, slot 13.
mdadm: /dev/sdg3 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdf3 is identified as a member of /dev/md0, slot 12.
mdadm: /dev/sde3 is identified as a member of /dev/md0, slot 11.
mdadm: /dev/sdd3 is identified as a member of /dev/md0, slot 10.
mdadm: /dev/sdb3 is identified as a member of /dev/md0, slot 8.
mdadm: added /dev/sdj3 to /dev/md0 as 0
mdadm: added /dev/sdk3 to /dev/md0 as 1
mdadm: added /dev/sdl3 to /dev/md0 as 2
mdadm: added /dev/sdm3 to /dev/md0 as 3
mdadm: added /dev/sdn3 to /dev/md0 as 4
mdadm: added /dev/sdo3 to /dev/md0 as 5
mdadm: added /dev/sdp3 to /dev/md0 as 6
mdadm: added /dev/sdq3 to /dev/md0 as 7
mdadm: added /dev/sdc3 to /dev/md0 as 9
mdadm: added /dev/sdd3 to /dev/md0 as 10
mdadm: added /dev/sde3 to /dev/md0 as 11
mdadm: added /dev/sdf3 to /dev/md0 as 12
mdadm: added /dev/sdh3 to /dev/md0 as 13
mdadm: added /dev/sdr3 to /dev/md0 as 14
mdadm: added /dev/sdy3 to /dev/md0 as 15
mdadm: added /dev/sdi3 to /dev/md0 as 16
mdadm: added /dev/sds3 to /dev/md0 as 17
mdadm: added /dev/sdt3 to /dev/md0 as 18
mdadm: added /dev/sdu3 to /dev/md0 as 19
mdadm: added /dev/sdv3 to /dev/md0 as 20
mdadm: added /dev/sdw3 to /dev/md0 as 21
mdadm: added /dev/sdx3 to /dev/md0 as -1
mdadm: added /dev/sdg3 to /dev/md0 as -1
mdadm: added /dev/sdb3 to /dev/md0 as 8
mdadm: /dev/md0 assembled from 14 drives and 2 spares - not enough to
start the array.


root@dv4:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdb3[8](S) sdg3[29](S) sdx3[27](S) sdw3[24](S)
sdv3[20](S) sdu3[19](S) sdt3[18](S) sds3[25](S) sdi3[26](S)
sdy3[23](S) sdr3[22](S) sdh3[28](S) sdf3[12](S) sde3[11](S)
sdd3[10](S) sdc3[9](S) sdq3[7](S) sdp3[6](S) sdo3[5](S) sdn3[4](S)
sdm3[3](S) sdl3[2](S) sdk3[1](S) sdj3[0](S)
      34952381856 blocks super 1.2

unused devices: <none>

The array state is what is interesting.

root@dv4:~# mdadm --examine /dev/sdj3
/dev/sdj3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 94d790a9:619a5141:d98f1f0f:2511c5f9
           Name : dv4:0  (local to host dv4)
  Creation Time : Fri Jul 31 19:48:25 2009
     Raid Level : raid6
   Raid Devices : 22

 Avail Dev Size : 2912698488 (1388.88 GiB 1491.30 GB)
     Array Size : 58253967360 (27777.66 GiB 29826.03 GB)
  Used Dev Size : 2912698368 (1388.88 GiB 1491.30 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9af11157:115d8425:5f3cecf4:ea46725b

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 18 23:29:12 2010
       Checksum : 95ed75e2 - correct
         Events : 752490

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 0
   Array State : AAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing)



root@dv4:~# mdadm --examine /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 94d790a9:619a5141:d98f1f0f:2511c5f9
           Name : dv4:0  (local to host dv4)
  Creation Time : Fri Jul 31 19:48:25 2009
     Raid Level : raid6
   Raid Devices : 22

 Avail Dev Size : 2912698488 (1388.88 GiB 1491.30 GB)
     Array Size : 58253967360 (27777.66 GiB 29826.03 GB)
  Used Dev Size : 2912698368 (1388.88 GiB 1491.30 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e506e4a1:ac26540b:49aca00d:13077a06

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Apr 19 10:08:46 2010
       Checksum : 8a3860bf - correct
         Events : 770417

         Layout : left-symmetric
     Chunk Size : 1024K

   Device Role : Active device 8
   Array State : ........AAAAAAAAAAAAAA ('A' == active, '.' == missing)


That is, the array state does not agree between two different groups
of drives ... the 14 with the wrong array state, and the 10 with the
correct array state.  Is there some magical incantation or mdadm
command that will force the array to either "ignore" the array state
metadata, and physically look at the drives for assembly, or clear the
state and set it all as "good"?

Thanks
