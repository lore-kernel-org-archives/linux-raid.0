From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Unable to re-add a disk  after a reboot.
Date: Thu, 14 Aug 2014 18:08:30 -0500
Message-ID: <53ED416E.8010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

   I just finished converting a 3-disk raid5 to 4-disk raid6. After a 
reboot to start clean, I noticed that one of the disk (the new one I 
just added) was missing in /proc/partitions. This was disk 4 in my 
/dev/md0. Assuming some cable issue, I powered off, wiggled the cables 
and restarted and the device was found by kernel. However, md0 shows 
device missing and array degraded

    lata [rramesh] 280 > cat /proc/mdstat
    Personalities : [raid6] [raid5] [raid4]
    md0 : active raid6 sdb1[0] sdd1[3] sdc1[1]
           3906763776 blocks super 1.2 level 6, 512k chunk, algorithm 2
    [4/3] [UUU_]

    unused devices: <none>

However my attempt to --re-add does not work.

    lata [rramesh] 277 > sudo mdadm /dev/md0 --verbose --re-add /dev/sde1
    mdadm: --re-add for /dev/sde1 to /dev/md0 is not possible
    lata [rramesh] 278 > sudo mdadm -E /dev/sde1
    /dev/sde1:
               Magic : a92b4efc
             Version : 1.2
         Feature Map : 0x0
          Array UUID : 730051d9:f4c58e0c:504fd1d9:798a84a4
                Name : lata:0  (local to host lata)
       Creation Time : Sun Oct  6 16:41:01 2013
          Raid Level : raid6
        Raid Devices : 4

      Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
          Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
       Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
         Data Offset : 262144 sectors
        Super Offset : 8 sectors
               State : clean
         Device UUID : 03898148:47c40cc2:f365082e:9f7f06cf

         Update Time : Thu Aug 14 08:53:16 2014
            Checksum : 346e9226 - correct
              Events : 1191488

              Layout : left-symmetric
          Chunk Size : 512K

        Device Role : Active device 3
        Array State : AAAA ('A' == active, '.' == missing)
    lata [rramesh] 279 > fgrep UUID /etc/mdadm/mdadm.conf
    # ARRAY /dev/md/0 metadata=1.2
    UUID=0e9f76b5:4a89171a:a930bccd:78749144 name=zym:0
    ARRAY /dev/md0 metadata=1.2 spares=1 name=lata:0
    UUID=730051d9:f4c58e0c:504fd1d9:798a84a4

I checked the SMART and it shows a lot of reallocated_sector_ct errors 
also. So, the disk is dying, but I am not able understand why mdadm 
would not add.

    SMART Attributes Data Structure revision number: 16
    Vendor Specific SMART Attributes with Thresholds:
    ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE     
    UPDATED  WHEN_FAILED RAW_VALUE
       1 Raw_Read_Error_Rate     0x000b   091   091   016 Pre-fail 
    Always       -       53
       2 Throughput_Performance  0x0005   100   100   054 Pre-fail 
    Offline      -       0
       3 Spin_Up_Time            0x0007   135   135   024 Pre-fail 
    Always       -       426 (Average 425)
       4 Start_Stop_Count        0x0012   100   100   000 Old_age  
    Always       -       59
    *5 Reallocated_Sector_Ct   0x0033   001   001   005 Pre-fail 
    Always   FAILING_NOW 330*
       7 Seek_Error_Rate         0x000b   098   098   067 Pre-fail 
    Always       -       2
       8 Seek_Time_Performance   0x0005   100   100   020 Pre-fail 
    Offline      -       0
       9 Power_On_Hours          0x0012   100   100   000 Old_age  
    Always       -       3445
      10 Spin_Retry_Count        0x0013   100   100   060 Pre-fail 
    Always       -       0
      12 Power_Cycle_Count       0x0032   100   100   000 Old_age  
    Always       -       59
    192 Power-Off_Retract_Count 0x0032   100   100   000 Old_age  
    Always       -       548
    193 Load_Cycle_Count        0x0012   100   100   000 Old_age  
    Always       -       548
    194 Temperature_Celsius     0x0002   153   153   000 Old_age  
    Always       -       39 (Min/Max 21/43)
    196 Reallocated_Event_Count 0x0032   001   001   000 Old_age  
    Always       -       17604
    197 Current_Pending_Sector  0x0022   001   001   000 Old_age  
    Always       -       13256
    198 Offline_Uncorrectable   0x0008   100   100   000 Old_age  
    Offline      -       0
    199 UDMA_CRC_Error_Count    0x000a   200   200   000 Old_age  
    Always       -       0

Any recommendations while I am waiting to get a replacement.

Ramesh

