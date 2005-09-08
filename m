From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Thu, 8 Sep 2005 15:39:44 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
 <17184.43156.113155.811612@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17184.43156.113155.811612@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  Inline .

On Fri, 9 Sep 2005, Neil Brown wrote:
> On Thursday September 8, babydr@baby-dragons.com wrote:
>>  	Hello All ,  Is there a documented procedure to follow during
>>  	creation or after that will get a raid6 array to self
>>  	rebuild ?
> I suspect a kernel upgrade would do the trick, though you don't say
> what kernel you are running.
> You could probably kick it along by removing and re-adding your spare:
>  mdadm /dev/md_d0 --remove /dev/sdao
>  mdadm /dev/md_d0 --add /dev/sdao
>
> (And I assume you mean 'raid5' rather than 'raid6', not that it
> matters..)
 	Sorry ,  yes I meant raid5 .

 	My kernel version is .
root@devel-0:/ # uname -a
Linux devel-0 2.6.12.5 #1 SMP Fri Aug 26 20:09:46 UTC 2005 i686 GNU/Linux

 	When I try to do the remove I get .
root@devel-0:/ # mdadm /dev/md_d0 --remove /dev/sdao
mdadm: hot remove failed for /dev/sdao: Device or resource busy

 	I should also have 3 other drives that are spares .  I could
 	try hot remove on one of them .  See at bottom the output of
 	mdadm --misc -Q --detail /dev/md_d0
 	Which is showing no spare drives ?  And I built it with 4
 	spares

root@devel-0:~ # cat /etc/mdadm.conf
DEV /dev/sd[c-l] /dev/sd[n-w] /dev/sd[yz] /dev/sda[a-h] /dev/sda[j-s]
ARRAY /dev/md_d0 level=raid5 num-devices=36 spares=4 UUID=2006d8c6:71918820:247e00b0:460d5bc1

 	 c-l is 10 devices (one is dead 'e' leaves 9) .
 	 n-w is 10 devices
 	 yz  is  2 devices
 	aa-h is  8 devices
 	aj-s is 10 devices
 		----------
 		40 devices given in mdadm.conf
 		-1 dead device .
 		----------
 		39 devices
 		36 devices used (per /proc/mdstat)
 		----------
 		 3 devices for spares .

>> # cat /proc/mdstat
>> ...snip...
>> md_d0 : active raid5 sdc[0] sdao[40] sdan[34] sdam[33] sdal[32]
>> sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26] sdad[25]
>> sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18] sdu[17]
>> sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9] sdk[8]
>> sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
>>        1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35]
>> [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]

/dev/md_d0:
         Version : 01.02.01
   Creation Time : Sun Aug 28 17:46:59 2005
      Raid Level : raid5
      Array Size : 1244826240 (1187.16 GiB 1274.70 GB)
     Device Size : 35566464 (33.92 GiB 36.42 GB)
    Raid Devices : 36
   Total Devices : 36
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Sep  8 06:26:10 2005
           State : clean, degraded
  Active Devices : 35
Working Devices : 35
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name :
            UUID : 2006d8c6:71918820:247e00b0:460d5bc1
          Events : 5308

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       8       48        1      active sync   /dev/sdd
        0       0        0        0      removed
        3       8       80        3      active sync   /dev/sdf
        4       8       96        4      active sync   /dev/sdg
        5       8      112        5      active sync   /dev/sdh
        6       8      128        6      active sync   /dev/sdi
        7       8      144        7      active sync   /dev/sdj
        8       8      160        8      active sync   /dev/sdk
        9       8      176        9      active sync   /dev/sdl
       10       8      208       10      active sync   /dev/sdn
       11       8      224       11      active sync   /dev/sdo
       12       8      240       12      active sync   /dev/sdp
       13      65        0       13      active sync   /dev/sdq
       14      65       16       14      active sync   /dev/sdr
       15      65       32       15      active sync   /dev/sds
       16      65       48       16      active sync   /dev/sdt
       17      65       64       17      active sync   /dev/sdu
       18      65       80       18      active sync   /dev/sdv
       19      65       96       19      active sync   /dev/sdw
       20      65      128       20      active sync   /dev/sdy
       21      65      144       21      active sync   /dev/sdz
       22      65      160       22      active sync   /dev/sdaa
       23      65      176       23      active sync   /dev/sdab
       24      65      192       24      active sync   /dev/sdac
       25      65      208       25      active sync   /dev/sdad
       26      65      224       26      active sync   /dev/sdae
       27      65      240       27      active sync   /dev/sdaf
       28      66        0       28      active sync   /dev/sdag
       29      66       16       29      active sync   /dev/sdah
       30      66       48       30      active sync   /dev/sdaj
       31      66       64       31      active sync   /dev/sdak
       32      66       80       32      active sync   /dev/sdal
       33      66       96       33      active sync   /dev/sdam
       34      66      112       34      active sync   /dev/sdan
       40      66      128       35      active sync   /dev/sdao

        2       8       64        -      faulty spare   /dev/sde


-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
