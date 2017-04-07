From: Zhilong Liu <zlliu@suse.com>
Subject: Re: Degraded RAID reshaping
Date: Fri, 7 Apr 2017 17:06:45 +0800
Message-ID: <e9685e3a-ae79-f00e-50b4-c46c551343a4@suse.com>
References: <7C33B6CD-B871-4D42-86F6-D80BDDC6D639@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7C33B6CD-B871-4D42-86F6-D80BDDC6D639@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Victor Helmholtz <victor.helmholtz@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/07/2017 04:38 PM, Victor Helmholtz wrote:
> Hi,
>
> I have problem with reshaping a RAID6. I had a drive failure in 8 disk RAID6, and since I
> don't need that much space anymore I decided to shrink array instead of buying replacement
> disk. I executed following commands:
>
> e2fsck -f /dev/md2
> mdadm --grow -n7 /dev/md2
> mdadm: this change will reduce the size of the array.
>         use --grow --array-size first to truncate array.
>         e.g. mdadm --grow /dev/md2 --array-size 14650664960
> resize2fs /dev/md2 3500000000
> mdadm /dev/md2 --grow --array-size=14650664960
> e2fsck -f /dev/md2
> mdadm --grow -n7 /dev/md2 --backup-file /root/mdadm-md2.backup
>
>
> There was no errors and 'cat /proc/mdstat' reports reshape in progress:
>
> Personalities : [raid6] [raid5] [raid4]
> md2 : active raid6 sde1[1] sdn1[8] sdb1[9] sdr1[11] sdp1[10] sdl1[4] sdi1[3]
>        14650664960 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>        [>....................]  reshape =  0.0% (1/2930132992) finish=9641968871.8min speed=0K/sec
>        bitmap: 22/22 pages [88KB], 65536KB chunk
>
> unused devices: <none>
>
>
> The problem is that there was no progress for more than an hour, the reshaping has stopped
> at the fist chunk. Is this a bug or is it not possible to reshape degraded RAID? What
> shall I do with the array, can I abort the reshape or is it going to reshape eventually?
>
> Output of "mdadm --detail /dev/md2":
> /dev/md2:
>          Version : 1.2
>    Creation Time : Sun Oct 19 22:10:51 2014
>       Raid Level : raid6
>       Array Size : 14650664960 (13971.96 GiB 15002.28 GB)
>    Used Dev Size : 2930132992 (2794.39 GiB 3000.46 GB)
>     Raid Devices : 7
>    Total Devices : 7
>      Persistence : Superblock is persistent
>
>    Intent Bitmap : Internal
>
>      Update Time : Fri Apr  7 08:38:29 2017
>            State : clean, degraded, reshaping
>   Active Devices : 7
> Working Devices : 7
>   Failed Devices : 0
>    Spare Devices : 0
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>   Reshape Status : 0% complete
>    Delta Devices : -1, (8->7)
>
>             Name : borox:2  (local to host borox)
>             UUID : 216515ea:4a08e3b7:022786cd:534b5f0f
>           Events : 148046
>
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       65        1      active sync   /dev/sde1
>         3       8      129        2      active sync   /dev/sdi1
>         4       8      177        3      active sync   /dev/sdl1
>        10       8      241        4      active sync   /dev/sdp1
>        11      65       17        5      active sync   /dev/sdr1
>         9       8       17        6      active sync   /dev/sdb1
>
>         8       8      209        7      active sync   /dev/sdn1

please type "mdadm ---grow --continue /dev/md2" and recheck,
check the "systemctl status mdadm-grow-continue@md2.service"
check the "journalctl -xn", to make sure whether or not the instance
of mdadm-grow-continue@.service has worked well.

Thanks,
-Zhilong
> Thanks,
> Victor
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

