From: Evan Felix <evan.felix@pnl.gov>
Subject: Raid Array with 3.5Tb
Date: Thu, 15 Jan 2004 11:49:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074196167.1382.8.camel@e-linux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been attempting to create a large raid 5 device using the linux
2.6.1 kernel, with the Large Block Device configured on.  I have in the
system 16 250G disks.  I built an array with mdadm -C -n 15 -x 1
/dev/md2 /dev/sd[a-p]

The resync/recovery seemed to be going fine, but at some point i started
seeing:

kernel: compute_blocknr: map not correct
kernel: compute_blocknr: map not correct

thousands of time in my logs.

I had hoped this message was not bad, so i tried a mkfs on the system, 
the mkfs just seemed to hang(no output at all), i left it for 15 hours
or so but it never output anything.

I rebooted and restarted the array, and am running a simple dd of the
entire block now, but it will take sometime.

Has anyone else made an array this large? and does anybody have any
pointers on where i can start looking at code to fix this?

Evan
-- 
-------------------------
Evan Felix
Administrator of Supercomputer #5 in Top 500, Nov 2003
Environmental Molecular Sciences Laboratory
Pacific Northwest National Laboratory
Operated for the U.S. DOE by Battelle
