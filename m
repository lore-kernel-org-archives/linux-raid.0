From: "Nolan Glore" <glore24d@erau.edu>
Subject: Multipath issues with gentoo
Date: Wed, 11 May 2005 12:43:09 -0400
Message-ID: <1115829789.a20b141cglore24d@erau.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having an problem using mdadm to multipath two scsi devices. We are running this type of configuration on all our RedHat AS3 boxes with no issues but I have noticed that the mdadm on RedHat is a bit different than the one on gentoo. I've posted this with no luck on some gentoo forums. Below is the details of what is going on. If you could let me know if this is an issue of mdadm or possibly a gentoo issues and if you have any suggestions of a fix I would appreciate it. Thanks.
 
Nolan
 

I created the multipath device with the following command: 
 

Code: 
 
mdadm --create /dev/md0 --level multipath --raid-devices=2 /dev/sdc1 /dev/sdd1 
 

This works fine. I can fail either of my devices and all is well. 
 
I stop md0 and then start it again with this command: 
 

Code: 
 
mdadm --build /dev/md0 --level=multipath --raid-devices=2 /dev/sdc1 /dev/sdd1 
 

and it still will fail over fine. When I look at /proc/mdstat all looks well: 
 
Code: 
 
Personalities : [linear] [multipath] 
md0 : active multipath sdd1[1] sdc1[0] 
      97667136 blocks [2/2] [UU] 
 
unused devices: <none> 
 

Here is what shows up in my syslog: 
 
Code: 
 
Apr  7 11:42:38 dbinstall kernel: md: bind<sdc1> 
Apr  7 11:42:38 dbinstall kernel: md: nonpersistent superblock ... 
Apr  7 11:42:38 dbinstall kernel: md: bind<sdd1> 
Apr  7 11:42:38 dbinstall kernel: md: nonpersistent superblock ... 
Apr  7 11:42:38 dbinstall kernel: multipath: array md0 active with 2 out of 2 IO paths 
 
 
I get then get the UUID of the array and write my mdadm.conf 
Code: 
 
DEVICE /dev/sd*  
ARRAY /dev/md0 UUID=b6e63e9b:d4cbebcc:8144a88e:5dd85696
PROGRAM /usr/sbin/handle-mdadm-events  
 
If I try and take advantage of the mdadm.conf file and execute this command to start md0: 
 
Code: 
 
mdadm -As
 
 
I get the following message: 
 
Code: 
 
mdadm: failed to add /dev/sdd1 to /dev/md0: Device or resource busy 
mdadm: /dev/md0 has been started with 1 drive (out of 2). 
 
 
When I take a look at /proc/mdstat here is what I get: 
 
Code: 
 
Personalities : [linear] [multipath] 
md0 : active multipath sdc1[0] 
      97667072 blocks [1/1] [U] 
 
unused devices: <none> 
 

Here is what shows up in my syslog: 
Code: 
 
Apr  7 11:43:43 dbinstall kernel: md: md0 stopped. 
Apr  7 11:43:43 dbinstall kernel: md: bind<sdc1> 
Apr  7 11:43:43 dbinstall kernel: md: export_rdev(sdd1) 
Apr  7 11:43:43 dbinstall kernel: multipath: array md0 active with 1 out of 2 IO paths 
 
 
Only sdc1 shows up so when I test failover it doesn't work. 


