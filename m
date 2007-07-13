From: Bryan Christ <bryan.christ@hp.com>
Subject: Raid array is not automatically detected.
Date: Fri, 13 Jul 2007 15:36:01 -0500
Message-ID: <4697E231.3070906@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My apologies if this is not the right place to ask this question. 
Hopefully it is.

I created a RAID5 array with:

mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda1 /dev/sdb1 
/dev/sdc1 /dev/sdd1 /dev/sde1

mdadm -D /dev/md0 verifies the devices has a persistent super-block, but 
upon reboot, /dev/md0 does not get automatically assembled (an hence is 
not a installable/bootable device).

I have created several raid1 arrays and one raid5 array this way and 
have never had this problem.  In all fairness, this is the first time I 
have used mdadm for the job.  Usually, I boot to something like 
SysRescueCD, used raidtools to create my array and then reboot with my 
Slackware install CD.

Anyone know why this might be happening?

Bryan
