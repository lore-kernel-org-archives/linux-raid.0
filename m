From: Ekkehard Lissner <ekkehard@lissners.de>
Subject: mkraid-problems
Date: Fri, 15 Aug 2003 22:33:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F3D4391.2020702@lissners.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a problem with a raid-5-array. The array consits of 3 disks, 
sdb1, sdc1 and sdd1.

First I found disk sdb1 out of synch - the timestamp caused it to be 
kicked out of the array.
Second I added the device again with raidhotadd to the array.
Third I rebooted the machine after I had seen a "synched"-message in syslog.

When the machine boots up, it stopped because the raid could not start 
up again.

When starting the raid manually with raidstart, it shows up that sdb1 
and sdc1 have the same timestamp,
sdd1 is a lower timestamp. But for some strange reason, sdb1 is also not 
in the array. This results in
the array not comming up, because it can not run with only one disk left.

My question here:
How can I reconstruct the array without losing my data?
The device was formated with a ext2-fs, and since the first failure im 
very confident that no write-access
has been done to the array (it was mounted read-only).
What is the effect of mkraid -f? Does it force a re-construct and does 
this destroy the filesystem on the md-device?

If there is no normal way to reconstruct the array without losing my 
data, how about patching the timestamps with
a disk-editor? Which bytes must be read from sdc1 and be written to sdd1 
and sdb1?

Regards
Ekkehard Lissner



