From: Tyler <pml@dtbb.net>
Subject: BUGREPORT: mdadm v2.0-devel - Inconsistent create command ordering,
 and inconsistent use/addition of spare drive with raid6
Date: Wed, 04 May 2005 05:59:39 -0700
Message-ID: <4278C73B.8040306@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Here's a few more bugs i found, using mdadm v2.0-devel with the big 
patch I posted earlier (with 4 patches together).  It seems that the 
create command wants the metadata command earlier in the command set.  
Secondly, after creating a raid6 array, the use/display of a spare drive 
that was included on the create command line doesn't seem to be right, 
compared to added a spare drive manually after creating the array, the 
details page is different, and it doesn't even list a spare (mind you, 
it hasn't finished syncing the raid, but why should it be any different 
of information, than that of the manual adding of a spare (and still not 
be synced yet)).

And I would like to remind you about the zero-superblock not working on 
version 1 superblocks, and of course my curiosity regarding the raid 
information (or lack there of) using the --detail command.

Thanks again :)

Creating new raid fails (with mdadm 2.0-devel patch i posted on my 
website) (raid6, 30 drives, 1 spare, superblock version 1):

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -C -l 6 -n 30 -x 1 -e 1 -c 
128 /dev/md0 /dev/hdb /dev/hdc /dev/hdd /dev/sd[a-z] /dev/sdaa /dev/sdab
mdadm: invalid number of raid devices: 30

Do it again, but simply re-order the commands, and magically it works:

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -C -l 6 -e 1 -n 30 -x 1 -c 
128 /dev/md0 /dev/hdb /dev/hdc /dev/hdd /dev/sd[a-z] /dev/sdaa /dev/sdab
mdadm: array /dev/md0 started.

Looking at mdstat and --detail of /dev/md0, it doesn't list the spare 
drive that I added during creation, and it shows 1 drive failed:

root@localhost:~/dev/mdadm-2.0-devel-1# cat /proc/mdstat
Personalities : [raid5] [raid6]
md0 : active raid6 sdab[30](F) sdaa[29] sdz[28] sdy[27] sdx[26] sdw[25] 
sdv[24] sdu[23] sdt[22] sds[21] sdr[20] sdq[19] sdp[18] sdo[17] sdn[16] 
sdm[15] sdl[14] sdk[13] sdj[12] sdi[11] sdh[10] sdg[9] sdf[8] sde[7] 
sdd[6] sdc[5] sdb[4] sda[3] hdd[2] hdc[1] hdb[0]
      5470105088 blocks level 6, 128k chunk, algorithm 2 [30/30] 
[UUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
      [>....................]  resync =  0.0% (8384/195360972) 
finish=1162.8min speed=2794K/sec
unused devices: <none>
root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -D /dev/md0
/dev/md0:
        Version : 01.00.01
  Creation Time : Wed May  4 13:36:00 2005
     Raid Level : raid6
     Array Size : 5470105088 (5216.70 GiB 5601.39 GB)
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 30
  Total Devices : 31
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May  4 13:36:00 2005
          State : clean, resyncing
 Active Devices : 30
Working Devices : 30
 Failed Devices : 1
  Spare Devices : 0

     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State

Stop the array, and re-create it again without the spare on the command 
line, magically it says no drives failed, and reports no spares of course:

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -S /dev/md0
root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -C -l 6 -e 1 -n 30 -c 128 
/dev/md0 /dev/hdb /dev/hdc /dev/hdd /dev/sd[a-z] /dev/sdaa    
mdadm: array /dev/md0 started.

root@localhost:~/dev/mdadm-2.0-devel-1# cat /proc/mdstat
Personalities : [raid5] [raid6]
md0 : active raid6 sdaa[29] sdz[28] sdy[27] sdx[26] sdw[25] sdv[24] 
sdu[23] sdt[22] sds[21] sdr[20] sdq[19] sdp[18] sdo[17] sdn[16] sdm[15] 
sdl[14] sdk[13] sdj[12] sdi[11] sdh[10] sdg[9] sdf[8] sde[7] sdd[6] 
sdc[5] sdb[4] sda[3] hdd[2] hdc[1] hdb[0]
      5470105088 blocks level 6, 128k chunk, algorithm 2 [30/30] 
[UUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
      [>....................]  resync =  0.0% (8424/195360972) 
finish=1149.1min speed=2808K/sec
unused devices: <none>

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -D /dev/md0
/dev/md0:
        Version : 01.00.01
  Creation Time : Wed May  4 13:38:06 2005
     Raid Level : raid6
     Array Size : 5470105088 (5216.70 GiB 5601.39 GB)
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 30
  Total Devices : 30
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May  4 13:38:06 2005
          State : clean, resyncing
 Active Devices : 30
Working Devices : 30
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State

Now adding the spare drive manually after the creation of the array, and 
it says 31 working devices, 1 spare, 0 failed:

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm --add /dev/md0 /dev/sdab
mdadm: added /dev/sdab

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -D /dev/md0
/dev/md0:
        Version : 01.00.01
  Creation Time : Wed May  4 13:38:06 2005
     Raid Level : raid6
     Array Size : 5470105088 (5216.70 GiB 5601.39 GB)
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 30
  Total Devices : 31
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed May  4 13:38:06 2005
          State : clean, resyncing
 Active Devices : 30
Working Devices : 31
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State

Regards,
Tyler.
