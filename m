From: Jan Ceuleers <jan.ceuleers@gmail.com>
Subject: Re: Preventative replacement of active RAID1 disks
Date: Sun, 29 Jan 2012 09:43:21 +0100
Message-ID: <4F2506A9.3050000@gmail.com>
References: <4F16FB90.5000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F16FB90.5000905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/18/2012 06:04 PM, Jan Ceuleers wrote:
> List,
>
> I have two 2-partition RAID1 sets, each with a spare. The SMART info 
> for both active disks suggests that I should replace them. Both of 
> them. I based this on the Seek_Error_Rate in the smartctl -a output.
>
> I am looking for advice on how best to do this.

OK, so I went for scenario B, and I'm running into a problem on the tail 
end of the procedure:

root@zotac:~# mdadm /dev/md0 --grow --raid-devices=2 --spare-devices=1
mdadm:option --spare-devices not valid in grow mode
root@zotac:~# mdadm /dev/md0 --grow --raid-devices=2
mdadm: Cannot set raid-devices for /dev/md0: Device or resource busy
root@zotac:~# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
root@zotac:~# uname -a
Linux zotac 2.6.35-32-generic #64-Ubuntu SMP Tue Jan 3 00:47:07 UTC 2012 
x86_64 GNU/Linux
root@zotac:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md1 : active raid1 sdb3[3] sde2[2] sdd2[0]
       487861824 blocks [4/3] [U_UU]

md0 : active raid1 sdb2[3] sde1[2] sdd1[0]
       521984 blocks [4/3] [U_UU]

unused devices: <none>

So I'm trying to bring the number of active devices back down to 2 with 
1 spare. I was able to increase it from 2+1 to 4+0 earlier. Any suggestions?

Thanks, Jan



root@zotac:~# mdadm -E /dev/sdd1 /dev/sde1 /dev/sdb2
/dev/sdd1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c2bfb80c:0cbf5cd9:67c62432:ead2ec0c
   Creation Time : Mon Oct 18 11:25:42 2010
      Raid Level : raid1
   Used Dev Size : 521984 (509.84 MiB 534.51 MB)
      Array Size : 521984 (509.84 MiB 534.51 MB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Jan 29 09:38:46 2012
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 672c88d4 - correct
          Events : 525


       Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       18        3      active sync   /dev/sdb2
/dev/sde1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c2bfb80c:0cbf5cd9:67c62432:ead2ec0c
   Creation Time : Mon Oct 18 11:25:42 2010
      Raid Level : raid1
   Used Dev Size : 521984 (509.84 MiB 534.51 MB)
      Array Size : 521984 (509.84 MiB 534.51 MB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Jan 29 09:38:46 2012
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 672c88e8 - correct
          Events : 525


       Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       18        3      active sync   /dev/sdb2
/dev/sdb2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : c2bfb80c:0cbf5cd9:67c62432:ead2ec0c
   Creation Time : Mon Oct 18 11:25:42 2010
      Raid Level : raid1
   Used Dev Size : 521984 (509.84 MiB 534.51 MB)
      Array Size : 521984 (509.84 MiB 534.51 MB)
    Raid Devices : 4
   Total Devices : 3
Preferred Minor : 0

     Update Time : Sun Jan 29 09:38:46 2012
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 672c88bb - correct
          Events : 525


       Number   Major   Minor   RaidDevice State
this     3       8       18        3      active sync   /dev/sdb2

    0     0       8       49        0      active sync   /dev/sdd1
    1     1       0        0        1      faulty removed
    2     2       8       65        2      active sync   /dev/sde1
    3     3       8       18        3      active sync   /dev/sdb2

