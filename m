From: Don Jessup <donj@asaca.com>
Subject: Problem with mdadm and raidstart
Date: Thu, 1 Apr 2004 11:20:15 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401192015.40822.qmail@web14522.mail.yahoo.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



   I have been testing disk failures with RAID5.   I have problems that I
  have run into that happens with raidstart and mdadm. 

    Here is the scenario.   I stop a healthy raid5.     I then do either one
   of the following:  I poweroff the first disk in the raid5 and remove it or
   I zero out the raid superblock on the first disk.     I then go ahead and
    try to start the raid either by raidstart command or  
     mdadm --assemble --run  /dev/md8   /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
     /dev/sde1 

     Both of these commands fail.  I do admit when using the mdadm command I
     can get the RAID5 to start if I leave out the first disk. 

    But when I try this same test with any other disk in the raid set (so any
    disk other than disk 0 ) the command raidstart works and I 
     assuming mdadm command would work as well.   That is what I would like 
    to happen with disk0 as well.    Is there anyway to start
    a degraded raid set consistently without having to manually figure 
    out which disk failed?   


    Any way to make this work?  If it is a simple fix I could do it myself
    if someone could point me to right direction or maybe there is a latter
    version of the mdadm command that this is not a problem.  Any one ?
    Any ideas?

    I'm running linux 2.4.22 kernel with mdadm - v1.3.0 - 29 Jul 2003.

    Thank You



   
 

    



=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
