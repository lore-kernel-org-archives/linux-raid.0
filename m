From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: mdadm recovery after HW failure: missing blocks at the end
Date: Thu, 1 Nov 2012 22:03:17 +0100
Message-ID: <976F9B53-9E94-4684-B714-6F1FFD4FBFEF@tu-dresden.de>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello all, hello Neil!

Please help!

After a host controller failure, our md RAIDs failed.

So far, I've managed to find the data again (see below), there's only some bytes in the end missing. However, these bits are important.

I am using git mdadm, as it supports "Data Offset" setting ("http://www.spinics.net/lists/raid/msg38695.html"), making my mdadm invocation look like this:

./mdadm --create /dev/md/scratch2G --assume-clean -l 6 -n 15 --metadata=1.2 -p ls -c 128 /dev/sdb:432s /dev/sdc:432s /dev/sdd:432s /dev/sde:432s /dev/sdf:432s /dev/sdg:432s /dev/sdh:432s /dev/sdi:432s /dev/sdj:432s /dev/sdk:432s missing /dev/sdl:432s /dev/sdm:432s /dev/sdn:432s /dev/sdo:432s

This gives me a valid FS signature on the assumed-clean device. However, running xfs_repair gives me the error message:

xfs_repair: error - read only 0 of 512 bytes


Digging deeper into the logs I found a size mismatch between the array re-created as shown above and the original setup:
(26005181562880-26005183266816)/(1024*13) = -128 kiB per device (a RAID6 with 15 devices has 13 "data" devices). Trying to fix this by passing a data size (" -z 1953514368 ") to the command mentioned above results in:

mdadm: /dev/sdb is smaller than given size. 1953514240K < 1953514368K + metadata
[SNIP ... same message for all 14 devices ... ]

So, I've got two questions: 
* Did mdadm (or the kernel md driver) write to the end area of the disk?
* Is it possible to make mdadm give me back the 128kiB at the end of each device? There's 88kiB left on each disk; this used to be enough when I created the original array in 2010.

Thanks a lot!


Yours,
Sebastian