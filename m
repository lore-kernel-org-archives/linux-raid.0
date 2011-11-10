From: Chris Purves <chris@northfolk.ca>
Subject: unable to recover RAID 5 due to bad block
Date: Thu, 10 Nov 2011 12:04:31 -0400
Message-ID: <4EBBF60F.4030606@northfolk.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have a 5 disk RAID 5 where one of the disks died completely.  I replaced the failed disk and added a new disk to the array.  While it was rebuilding the new disk there was a read error on one of the "good" disks that caused the disk to be reset by the controller and the array was brought down.

I can bring the array back up in degraded mode by running mdadm --assemble --force /dev/md1; however, I have been unable to build the fifth disk.  I would appreciate any help.

-- 
Chris Purves
