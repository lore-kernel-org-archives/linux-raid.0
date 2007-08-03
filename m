From: Basheer <subs@nmcexquisite.com>
Subject: Problem creating software raid - Device or resource busy.
Date: Thu, 2 Aug 2007 23:51:49 -0700 (PDT)
Message-ID: <11978339.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

Re: Software Raid Problem
----------------------------------------

Background
------------------------------------------
OS= Opensuse 10.2
2 X 250gb Sata drives

Drive 1
----------
/dev/sda1 = swap
/dev/sda2 = linux raid   (os & data is here)
/dev/sda3 = linux raid  

Drive 2
----------
/dev/sdb1 = swap
/dev/sdb2 = linux resiser
/dev/sdb3 = linux reiser
---------------------------------------------------------------

Using mdadm I managed to create /dev/md0 in raid 1 (mirror). 
/dev/sda3 & /dev/sdb3 where added to this set.

Good so far....now for the problem....

Problems Area
-----------------------
Using mdadm I  failed to create /dev/md1 in raid 1 (mirror). 
/dev/sda2 & /dev/sdb2 where part of  this set.
I get this error: mdadm: cannot open device /dev/sda2: Device or 
resource busy.

I booted from rescue CD, and ran the mdam command to create /dev/md1 
... and it worked! I let the raid sync.

When I reboot, I get this error:

mdadm: cannot open device /dev/sda2: Device or resource busy.
mdadm: /dev/sda2 has no superblock - assembly aborted

How to do I solve this?

Your help will be appreciated.

Regards



-- 
View this message in context: http://www.nabble.com/Problem-creating-software-raid---Device-or-resource-busy.-tf4210914.html#a11978339
Sent from the linux-raid mailing list archive at Nabble.com.

