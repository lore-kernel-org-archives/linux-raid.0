From: Elliot Carver <carver.elliot@gmail.com>
Subject: mdadm doesn't detect sw raid 5 array on boot
Date: Sun, 7 Jan 2007 04:26:27 +0200
Message-ID: <1918477969.20070107042627@gmail.com>
Reply-To: Elliot Carver <carver.elliot@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have created software raid 5 array, which is not detected automatically during boot.
I have put the needed information in mdadm.conf with the auto=yes option but mdadm
can not start this particular array during boot. When I type manually mdadm -As /dev/md2,
the array starts and works without any problems. What can be the reason for this?
The disks of the problematic array are attached to a highpoint 1820a controller.With the old controller (Highpoint 1640) there weren't any problems.
Kernel version is 2.6.11.OS is Mandriva 2005.   
The other software array (disks attached directly to motherboard sata ports) works without any problem and starts
automatically during boot. Below is /etc/mdadm.conf. 
# MD0 Device mounted as raid

DEVICE /dev/sda /dev/sdb /dev/sdc /dev/sdd

ARRAY /dev/md0 level=raid5 num-devices=4 spares=1 UUID=24f177fd:80b039e6:d02c66bf:2859b089

# LAST HIGHPOINT 1820A (replaced HP RR 1640) <-- this is the problematic array.

DEVICE /dev/sde /dev/sdf /dev/sdg /dev/sdh

ARRAY /dev/md2 level=raid5 auto=yes num-devices=4 spares=1 UUID=a2f494ec:36aac1b0:691da55c:8f60459a 

Thanks in advance. Any help will be greatly appreciated. 


