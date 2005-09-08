From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Drive fails & raid6 array is not self rebuild .
Date: Thu, 8 Sep 2005 12:54:31 -0600 (MDT)
Message-ID: <Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  Is there a documented procedure to follow during
 	creation or after that will get a raid6 array to self
 	rebuild ?

 	Why I am asking .
 	I was getting the errors below at a heavy rate , so ...

Sep  7 20:11:49 localhost kernel: scsi2 (2:0): rejecting I/O to dead 
device
Sep  7 20:11:49 localhost kernel: md: write_disk_sb failed for device 
sde
Sep  7 20:11:49 localhost kernel: md: excessive errors occurred during 
superblock update, exiting
Sep  7 20:11:49 localhost kernel: raid5: Disk failure on sde, 
disabling device. Operation continuing on 35 devices

 	I ran the below & the above messages stopped .  But the array
 	(appears to have) never tried rebuilding .

# mdadm --manage --fail /dev/md_d0 /dev/sde

 	The problem arose because the drive died totally . ie:
root@devel-0:/ # fdisk /dev/sde

Unable to open /dev/sde


# cat /proc/mdstat
...snip...
md_d0 : active raid5 sdc[0] sdao[40] sdan[34] sdam[33] sdal[32] 
sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26] sdad[25] 
sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18] sdu[17] 
sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9] sdk[8] 
sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
       1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35] 
[UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
...snip...

# cat /etc/mdadm.conf
DEV /dev/sd[c-l] /dev/sd[n-w] /dev/sd[yz] /dev/sda[a-h] /dev/sda[j-s]
ARRAY /dev/md_d0 level=raid5 num-devices=36 spares=4 
UUID=2006d8c6:71918820:247e00b0:460d5bc1

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
+------------------------------------------------------------------+
