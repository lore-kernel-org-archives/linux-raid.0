From: "kyle" <kylewong@southa.com>
Subject: change strip_cache_size freeze the whole raid
Date: Mon, 22 Jan 2007 19:02:08 +0800
Message-ID: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Yesterday I tried to increase the value of strip_cache_size to see if I can 
get better performance or not. I increase the value from 2048 to something 
like 16384. After I did that, the raid5 freeze. Any proccess read / write to 
it stucked at D state. I tried to change it back to 2048, read 
strip_cache_active, cat /proc/mdstat, mdadm stop, etc. All didn't return 
back. I even cannot shutdown the machine. Finally I need to press the reset 
button in order to get back my control.

Kernel is 2.6.17.8 x86-64, running at AMD Athlon3000+, 2GB Ram, 8 x Seagate 
8200.10 250GB HDD, nvidia chipset.

cat /proc/mdstat (after reboot):
Personalities : [raid1] [raid5] [raid4]
md1 : active raid1 hdc2[1] hda2[0]
      6144768 blocks [2/2] [UU]

md2 : active raid5 sdf1[7] sde1[6] sdd1[5] sdc1[4] sdb1[3] sda1[2] hdc4[1] 
hda4[0]
      1664893440 blocks level 5, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]

md0 : active raid1 hdc1[1] hda1[0]
      104320 blocks [2/2] [UU]

Kyle

