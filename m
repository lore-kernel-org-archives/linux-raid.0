From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: mdadm 3.2.5: Assemble doesn't scale correctly
Date: Mon, 15 Oct 2012 18:13:12 +0200
Message-ID: <507C3618.4030603@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

Hi list,

the mdadm 3.2.5 assemble command doesn't scale correctly.

First, I've tested simple stuff with "strace" like this one:

# mdadm -A /dev/md0 /dev/loop0 /dev/loop1

This also scans imsm superblocks by reading files from "/sys/bus/pci".
Let's set it explicitly to 1.2:

# mdadm -A /dev/md0 -e 1.2 /dev/loop0 /dev/loop1

This results in approx. 100 lines less strace output.


But now the big performance killer:

Assemble()->open_dev_excl()->dev_open("%d:%d")->map_dev()

Why does this have to scan the whole "/dev" directory - not finding any
device with the same/wanted major:minor? Isn't there a better method?

It takes longer and longer the more devices are in /dev.

Cheers,
Sebastian

-- 
Sebastian Riemer
Linux Kernel Developer - Storage

