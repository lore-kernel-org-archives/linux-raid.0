From: Tyler <pml@dtbb.net>
Subject: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Sun, 01 May 2005 18:35:54 -0700
Message-ID: <427583FA.7030704@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to build a Raid-6 array using 31 drives, is there a patch 
available or an easy way to safely increase the *MD_SB_DISKS*=27 to a 
higher number?  My attempts at patching the source myself were 
unsuccessful, more than likely because i don't know what/why the limit 
is 27, and whether that effects other parts of the kernel.

Thanks,
Tyler.

PS - I've tryed the latest 2.6.12-rc3-mm2 kernel, with mdadm v2.0-devel, 
using the --metadata 1.0 option on the create line, and still get:

# mdadm -C -e 1.0 -l 6 -n 31 /dev/md0 /dev/hdb /dev/hdc /dev/hdd 
/dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh 
/dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdp 
/dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx 
/dev/sdy /dev/sdz /dev/sdaa /dev/sdab
mdadm: invalid number of raid devices: 31
# mdadm -V
mdadm - v2.0-devel-1 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 18 
February 2005
# uname -a
Linux pink 2.6.12-rc3-mm2 #1 SMP Mon May 2 02:15:28 CEST 2005 i686 GNU/Linux
# dmesg |grep md
md: raid5 personality registered as nr 4
md: raid6 personality registered as nr 8
md: md driver 0.90.2 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 3.38
