From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Thu, 8 Sep 2005 20:05:38 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509082000030.31748@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
 <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
 <17184.43156.113155.811612@cse.unsw.edu.au>
 <Pine.LNX.4.63.0509081525380.30261@filesrv1.baby-dragons.com>
 <17184.56377.773388.978710@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17184.56377.773388.978710@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,

On Fri, 9 Sep 2005, Neil Brown wrote:
> On Thursday September 8, babydr@baby-dragons.com wrote:
>>  	When I try to do the remove I get .
>> root@devel-0:/ # mdadm /dev/md_d0 --remove /dev/sdao
>> mdadm: hot remove failed for /dev/sdao: Device or resource busy
>>
>>  	I should also have 3 other drives that are spares .  I could
>>  	try hot remove on one of them .  See at bottom the output of
>>  	mdadm --misc -Q --detail /dev/md_d0
>>  	Which is showing no spare drives ?  And I built it with 4
>>  	spares
>
> Yes... /dev/sda[pqrs] are missing.  I wonder why..
>
> What does
>   mdadm -E /dev/sda[pqrs]
> show?
 	See way below .

> What happens if you then
>  mdadm /dev/md_d0 -a /dev/sda[pqrs]
> ??

 	Getting stranger & stranger .

root@devel-0:~ # mdadm /dev/md_d0 -a /dev/sda[pqrs]
mdadm: re-added /dev/sdap

root@devel-0:~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] [raid10]
md_d0 : active raid5 sdap[36] sdc[0] sdao[40] sdan[34] sdam[33] 
sdal[32] sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26] 
sdad[25] sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18] 
sdu[17] sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9] 
sdk[8] sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
       1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35] [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]

md1 : active raid1 sdb2[0] sda2[1]
       1003968 blocks [2/2] [UU]

md2 : active raid1 sdb3[0] sda3[1]
       34700288 blocks [2/2] [UU]

md0 : active raid1 sdb1[0] sda1[1]
       136448 blocks [2/2] [UU]

unused devices: <none>


 	It appears they think their still part of the array .

root@devel-0:~ # mdadm -E /dev/sda[pqrs]
/dev/sdap:
           Magic : a92b4efc
         Version : 01.00
      Array UUID : 2006d8c6:71918820:247e00b0:460d5bc1
            Name :
   Creation Time : Sun Aug 28 17:46:59 2005
      Raid Level : raid5
    Raid Devices : 36

     Device Size : 71132943 (33.92 GiB 36.42 GB)
     Data Offset : 16 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : c083f71d:ce15a0aa:24341675:45ec6e3e
     Update Time : Sun Aug 28 20:43:06 2005
        Checksum : dc216e5 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

    Array State : uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu 1 failed
/dev/sdaq:
           Magic : a92b4efc
         Version : 01.00
      Array UUID : 2006d8c6:71918820:247e00b0:460d5bc1
            Name :
   Creation Time : Sun Aug 28 17:46:59 2005
      Raid Level : raid5
    Raid Devices : 36

     Device Size : 71132943 (33.92 GiB 36.42 GB)
     Data Offset : 16 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 430b9730:4416eb44:2f793e78:a3a92cc1
     Update Time : Sun Aug 28 20:43:06 2005
        Checksum : 4092a148 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

    Array State : uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu 1 failed
/dev/sdar:
           Magic : a92b4efc
         Version : 01.00
      Array UUID : 2006d8c6:71918820:247e00b0:460d5bc1
            Name :
   Creation Time : Sun Aug 28 17:46:59 2005
      Raid Level : raid5
    Raid Devices : 36

     Device Size : 71132943 (33.92 GiB 36.42 GB)
     Data Offset : 16 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 33ea7f64:976740bb:ff88e4bc:84534774
     Update Time : Sun Aug 28 20:43:06 2005
        Checksum : e2918b3d - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

    Array State : uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu 1 failed
/dev/sdas:
           Magic : a92b4efc
         Version : 01.00
      Array UUID : 2006d8c6:71918820:247e00b0:460d5bc1
            Name :
   Creation Time : Sun Aug 28 17:46:59 2005
      Raid Level : raid5
    Raid Devices : 36

     Device Size : 71132943 (33.92 GiB 36.42 GB)
     Data Offset : 16 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : acb2ea9d:7c3f3b6e:98d9f85c:c8cb2bae
     Update Time : Sun Aug 28 20:43:06 2005
        Checksum : a8eff479 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

    Array State : uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu 1 failed
root@devel-0:~ #

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
