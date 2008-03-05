From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: RAID-5 data corruption
Date: Thu, 06 Mar 2008 00:23:14 +0100
Message-ID: <47CF2B62.7070806@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

it seems my RAID-5 exploded last Sunday. :-(
Ext3 errors started appearing during the monthly data-check, and when I 
noticed later that day, mismatch_cnt was huge, about 200.000.000. After 
a reboot (or did I just restart the array? can't remember) and another 
check, it was down to 176, but the file system remained badly broken.

I suspected one of the disks was dying and reading/writing bad data, but 
it seems that's not the case: I took them out of their enclosures (I'm 
using external drives) and plugged them into my desktop to read the 
SMART values, and they look okay. Reallocated sector count was 0 on all 
three, there were no errors logged, and all passed both a SMART long 
selftest and badblocks -n. So I guess the disks are fine.

I also ran the latter (badblocks -n) with the disks back in the 
enclosures and using the same USB/Firewire ports, cables and hubs, and 
they passed again, so I guess that part is okay too.

The configuration is an LVM volume on an md array with two USB drives 
and one Firewire drive. I'm not sure what caused the problem, it could 
be an ext3 bug, an LVM bug, an md bug, or something in the USB or 
Firewire drivers, but the huge mismatch_cnt makes me suspect it's a 
rather low-level issue (md or lower). BTW, I'm using 2.6.24.3 with this 
config: http://murli.34sp.com/o/raid/config-2.6.24.3

Anyway, running "e2fsck -n" with all drives in the array aborts with 
"Error while iterating over blocks in inode 28327968: Illegal triply 
indirect block found". When I remove one drive at a time, it's the same 
for two 2/3 configurations, but different for the third: this time, 
e2fsck at least completes, but still finds lots of errors.

I've uploaded e2fsck and kernel logs to http://murli.34sp.com/o/raid/

My current plan is to buy some drives tomorrow to mirror the current 
state, and then see what e2fsck can recover; I also found e2salvage and 
e2extract. Are there any other tools I should look into?

I'll see if I can recover my data, but do you have any ideas what caused 
the problem in the first place?


-- 
Oliver
