From: Anthony Johnson <anthony@storix.com>
Subject: linux mkraid: segmentation fault
Date: Sun, 19 May 2002 23:14:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CE89445.51B54454@storix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Can you please help me or provide me a contact where I can get some
support for software raid?

My company is developing a system recovery product that creates software
raid devices, and I get a segmentation fault when I run:
   mkraid -c /etc/raidtab --really-force /dev/md0

This problem doesn't occur on a normal running system, only after I have
booted from my recovery diskettes, and it occurs no matter what I have
configured in the raidtab file. I'm sure there is a problem due to
something missing from the RAM filesystem created by the recovery
diskettes but I can't find what it is.

I have rebuilt the partition map (containing md0 devices), made the
device nodes, updated the raidtab file correctly but nothing matters.
The boot media contains the necessary commands and any libraries
required (by running ldd on each executable).

Can you tell me what files or device nodes are required to make a raid
device that I might be missing? This is quite urgent as we'll be
releasing this product in only a month and we won't be able to support
systems using software raid until I resolve this.

Thanks!
Anthony
