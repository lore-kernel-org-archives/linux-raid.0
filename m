From: Hxsrmeng <hxsrmeng@gmail.com>
Subject: Is that normal a removed part in RAID0 still showed as "active
 sync"
Date: Mon, 7 Jan 2008 08:49:21 -0800 (PST)
Message-ID: <14670113.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The /dev/md0 is set as RAID0
"cat /proc/mdstat" shows
md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
157307904 blocks 64k chunks

Then sdd is removed.

But  "cat /proc/mdsta" still shows the same information as above, while two
RAID5 devices show their sdd parts as (F)
md0 : active raid0 sda1[0] sdd1[3] sdc1[2] sdb1[1]
157307904 blocks 64k chunks

Is this normal?

Also, when using "mdadm --detail"
sdd1( part of RAID0) is showed as "active sync", but sdd2(which is part of
RAID5) is showed as "removed"

Thank you.

-- 
View this message in context: http://www.nabble.com/Is-that-normal-a-removed-part-in-RAID0-still-showed-as-%22active-sync%22-tp14670113p14670113.html
Sent from the linux-raid mailing list archive at Nabble.com.

