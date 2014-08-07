From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: RAID10-reshape crashed due to memory allocation problem
Date: Thu, 7 Aug 2014 23:06:46 +0200
Message-ID: <201408072106.s77L6kKo009859@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers,

seems like memory is leaking when a RAID10-array is reshaped.

Here are the details of what I did:

RAID10-array consisting of 13 disks (2TB each) and one spare was
grown into a 16 disk RAID10-array by adding two more spares and
then doing  mdadm --grow /dev/md5 --raid-devices=16

When the reshape operation reached 80% (after 20 hours) the system
became unresponsive and crashed soon after. Console output showed
something like "... could not allocate memory block ..."

The machine has 32GB of RAM.

After the machine was rebooted the reshape operation was running
for 6 more hours and was followed by an 8 hour resync.

Everything seems to be OK now, but according to /proc/meminfo
only 15GB of RAM are available. Much too low for a system that
is almost idle.

I will reboot the machine at our next maintenance window and
compare its available memory with the situation right now.

Is restarting the reshape operation after a crash really safe?
Should I check the correctness of my array somehow?

Kind regards

Peter Koch
