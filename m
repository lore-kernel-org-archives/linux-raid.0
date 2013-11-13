From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: mdadm --fail requires writeable drive.
Date: Wed, 13 Nov 2013 12:17:21 +0000
Message-ID: <52836DD1.8080605@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I noticed that mdadm --fail will only work if a disk is present and is 
writeable.

mdadm's Manage.c seems to first make sure the drive can be "stat"ed 
before proceeding (which will fail if the drive is gone), and then 
seemingly try to write "Faulty" to the drive's superblock as well as 
notifying MD of the drive failure.

However, in many cases, a drive must be set faulty because it has gone 
offline. MD will do a very good job to set the drive faulty itself, 
provided that IOs are running on the array. If no IOs are running on the 
array, removing a drive and then trying to set it as failed will not 
work. Trying to "-r" the drive will also fail since the drive is not yet 
marked as failed, so deemed still in use.

Looking through the code it seemed to me that MD could be told to fail a 
drive even if that drive was no longer present (the /dev/sdX device node 
file still is in this case), in the same way as remove works. Would that 
be possible? Am I missing something here?

Thanks in advance for your help.

Regards,

Ben - MPSTOR
