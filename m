From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: RAID10 hot replacement issue
Date: Thu, 08 Nov 2012 14:54:51 +0800
Message-ID: <509B573B.9040806@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>, joystick <joystick@shiftmail.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

G'day Neil,

Not a real problem, but a data point and possible issue.

I tried a hot replace on one of my main system disks. It all appeared to 
work as-planned, but now I can't remove the replacement flag from /dev/sdg2.

I failed and removed /dev/sdg2 from /dev/md2, and then re-added it. It 
synced up, a check shows no mismatches and it all appears to work ok, 
but with the replacement flag set on that partition I can't do any 
further hot-replace on that array. The flag survived a reboot.

I suspect I need to remove /dev/sdg2 and zero the superblock before 
adding it back.

This came about when I originally replaced /dev/sds2 with /dev/sdg2. All 
went well except at the end of the process sds2 was marked as failed and 
sdg2 was marked as (R), and nothing I could do would change it. I could 
remove sds2, but can't clear the replacement flag on sdg2.

I performed the original replacement on kernel 3.6.2, and am now running 
3.6.6.

root@srv:/sys/block/md2/md# cat /proc/mdstat
<snip>
md2 : active raid10 sdg2[3](R) sdh2[2]
       976247808 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]
       bitmap: 1/8 pages [4KB], 65536KB chunk

root@srv:/sys/block/md2/md# mdadm --examine /dev/sd[hg]2
/dev/sdg2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x11
      Array UUID : 6df98448:8cfbee7e:acdf3947:f282c441
            Name : sysresccd:2
   Creation Time : Sun May  8 14:02:40 2011
      Raid Level : raid10
    Raid Devices : 2

  Avail Dev Size : 1952497072 (931.02 GiB 999.68 GB)
      Array Size : 976247808 (931.02 GiB 999.68 GB)
   Used Dev Size : 1952495616 (931.02 GiB 999.68 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 9ba8a9af:e01c51d4:f9555d3e:2906f9a2

Internal Bitmap : 2 sectors from superblock
     Update Time : Thu Nov  8 14:46:34 2012
        Checksum : bb70195e - correct
          Events : 1252869

          Layout : far=2
      Chunk Size : 512K

    Device Role : Replacement device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 6df98448:8cfbee7e:acdf3947:f282c441
            Name : sysresccd:2
   Creation Time : Sun May  8 14:02:40 2011
      Raid Level : raid10
    Raid Devices : 2

  Avail Dev Size : 1952497072 (931.02 GiB 999.68 GB)
      Array Size : 976247808 (931.02 GiB 999.68 GB)
   Used Dev Size : 1952495616 (931.02 GiB 999.68 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 9245b92c:1b491bd5:0f35fb14:9faab3c9

Internal Bitmap : 2 sectors from superblock
     Update Time : Thu Nov  8 14:46:34 2012
        Checksum : 36a2660b - correct
          Events : 1252869

          Layout : far=2
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
root@srv:/sys/block/md2/md# mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Sun May  8 14:02:40 2011
      Raid Level : raid10
      Array Size : 976247808 (931.02 GiB 999.68 GB)
   Used Dev Size : 976247808 (931.02 GiB 999.68 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Thu Nov  8 14:46:46 2012
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

          Layout : far=2
      Chunk Size : 512K

            Name : sysresccd:2
            UUID : 6df98448:8cfbee7e:acdf3947:f282c441
          Events : 1252869

     Number   Major   Minor   RaidDevice State
        2       8      114        0      active sync   /dev/sdh2
        3       8       98        1      active sync   /dev/sdg2

root@srv:/sys/block/md2/md# cat dev-sdg2/state
in_sync,replacement

root@srv:/sys/block/md2/md# echo -replacement > dev-sdg2/state
bash: echo: write error: Device or resource busy

