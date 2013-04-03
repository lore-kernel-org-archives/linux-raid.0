From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Xen disk write slowness in kernel 3.8.x
Date: Wed, 03 Apr 2013 13:14:21 +1100
Message-ID: <515B907D.2030005@crc.id.au>
References: <515B8E7B.8070104@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515B8E7B.8070104@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/04/13 13:05, Steven Haigh wrote:
> Hi all,
>
> I'm still trying to track down the cause of disk write slowness when
> passing through disks to a DomU.
>
> I've restructured things a little and now pass the raid array (/dev/md3)
> directly to the DomU. When running a xfs_fsr on the filesystem from
> within the Dom0, I get the following:
>
> # iostat -m 5
> (....)
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0.11    0.00    9.23   44.64    0.21   45.81
>
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sdc             286.20        17.22        34.15         86        170
> sdf             284.20        17.45        34.43         87        172
> sdd             217.40        17.25        34.15         86        170
> sde             211.00        17.25        34.38         86        171
> md3            1095.40        69.20        67.18        346        335
>
> This is with the RAID6 mounted on /mnt/fileshare from within the Dom0.
> Speeds are about what I would expect for the task that is going on.
>
> With no changes at all to the setup or the RAID, I attach the same RAID6
> array to a DomU:
>
> # xm block-attach zeus.vm phy:/dev/md3 xvdb w
>
> Now run xfs_fsr from within the DomU, I look at the same output from
> iostat on Dom0:
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0.00    0.00    2.35    0.00    0.34   97.31
>
> Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
> sdc             702.40        11.28        16.09         56         80
> sdf             701.00        11.26        16.15         56         80
> sdd             698.00        11.18        15.95         55         79
> sde             700.60        11.27        16.19         56         80
> md3            1641.00        30.30        29.87        151        149
>
> I'm seeing this consistently across all methods of speed testing (dd,
> bonnie++, etc).
>
> If I remove and attach a single disk from the array and run tests on
> that, I obtain full speed for the single drive. As soon as the array is
> passed, the speed drops significantly (as seen above).
>
> I have copied in the linux-raid list to this - as it seems to only
> affect md arrays passed to the Xen DomU guests.
>
> Where do we start debugging this?
>

Whoops - forgot to add the details of the array:
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md3 : active raid6 sdd[5] sdc[4] sdf[1] sde[0]
       3906766592 blocks super 1.2 level 6, 128k chunk, algorithm 2 
[4/4] [UUUU]

# mdadm --detail /dev/md3
/dev/md3:
         Version : 1.2
   Creation Time : Mon Apr  1 01:49:18 2013
      Raid Level : raid6
      Array Size : 3906766592 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 1953383296 (1862.89 GiB 2000.26 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Wed Apr  3 13:13:45 2013
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

            Name : xenhost.lan.crc.id.au:3  (local to host 
xenhost.lan.crc.id.au)
            UUID : 69cd7c1c:2ffc2df2:0a8afbb3:a2f32dab
          Events : 310

     Number   Major   Minor   RaidDevice State
        0       8       64        0      active sync   /dev/sde
        1       8       80        1      active sync   /dev/sdf
        5       8       48        2      active sync   /dev/sdd
        4       8       32        3      active sync   /dev/sdc

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
