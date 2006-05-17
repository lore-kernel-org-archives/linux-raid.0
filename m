From: Bill Cizek <cizek@rcn.com>
Subject: Raid1 resync throttling
Date: Wed, 17 May 2006 18:34:28 -0500
Message-ID: <446BB304.1040800@rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Are there any known issues of the raid1 resync not throttling properly?

I'm setting up a new array on a pair of SATA disks, and it hogs the 
disks and blocks all
other i/o to them.  If I lower /proc/sys/dev/raid/speed_limit_max 
(before creating the array)
things run better, but that's not always an option -- I rebooted and the 
system hung once
the resync started -- I had to pull the second drive to get things back 
to normal.

This is on a 2.6.16.14 system, using mdadm 2.2 and 2.4.1.  I've set up a 
few mirrors
in the past with no issues, but those were all regular IDE.  This is the 
first time
I tried SATA.  Are there any known SATA issues with RAID?

Does anyone have any thoughts on this?

TIA,
Bill
