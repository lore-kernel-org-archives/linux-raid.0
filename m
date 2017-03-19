From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: stripe_cache_size, some info
Date: Sun, 19 Mar 2017 19:35:14 +0100
Message-ID: <CAJH6TXhL4=MLanyvQh8UMkBmfkfjPd-frsCOC3PqLnDXCpMetw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all,
I need some info about stripe_cache_size

Is that a sort of "writeback" cache? Higher the number, higher the
amount of data to be cached in ram before writing to disks, right?

Some questions:

1) any upper limit for that value ? Can I set it near 1GB like most
hardware controller?
2) why on my RAID-6 I don't have /sys/block/md0/md/stripe_cache_size ?

As I would like to replace most of our HW raid controller with mdadm,
any suggestion on how to improve RAID-6 speed ?

Modern CPU aren't an issue, I don't think that double-parity
calculation could create any bottleneck on a modern CPU.
The real advantages of a raid controller are mostly 2:

1) the writeback cache (1GB or 2GB)
2) the ability to automatically replace a disk by hotswapping it.

Any solution to this ? For the "2", i've tried by configuring the
POLICY in mdadm.conf but new disk is never reconized and I always have
to manually add the new disk to the array.
