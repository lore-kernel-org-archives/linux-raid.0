From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Reading the same block via partition and non-partitioned device gives
 different content
Date: Tue, 5 Jan 2016 11:28:23 +0300
Message-ID: <568B7EA7.9010901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

[Please Cc me on reply; thank you]

QEMU KVM virtual machine with openSUSE Tumbleweed (kernel
4.3.3-3-default); MD RAID1 with 1.2 metadata on /dev/vdb1 and /dev/vdc1.

If I do

mdadm /dev/mdX --fail /dev/vdb1
mdadm /dev/mdX --add /dev/vdd1

and wait for synchronization to finish and then look directly on on-disk
suportblock, I see different content whether I read from /dev/vdd or
from /dev/vdd1.

/dev/vdd1 claims new disk is still spare (i.e. it is apparently
immediately after adding it).

The *same* superblock when read from /dev/vdd (of course with
appropriate offset) correctly marks /dev/vdd1 as RAID member. The same
content also seen when looking from host.

I hit this when debugging problem with grub2 that scans devices for
Linux MD (it is using the same code both at boot and run time). It
skipped replacement disk because it believed disk was spare.

Is it expected behavior? Note that if we now replace /dev/vdc1 with
something else we have "wrong" superblock on both partitions so grub
fails to find array completely. Fortunately this is transient state, but
it also means it is impossible to reconfigure grub until reboot.
Alternatively shutting down and restarting array cleats it as well.

Any trick we can use to force content to be the same in this state?

-andrei
