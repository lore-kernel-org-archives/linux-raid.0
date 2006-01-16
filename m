From: Wolfram Schlich <lists@wolfram.schlich.org>
Subject: block size issue when re-syncing RAID1 with ext2fs on top
Date: Mon, 16 Jan 2006 18:55:49 +0100
Message-ID: <20060116175549.ALLYOURBASEAREBELONGTOUS.M23957@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ext2-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm experiencing a problem on a 2.2.16C37_III driven Cobalt RaQ4
after I add a new 2nd disk to a RAID1.

I'm uncertain whether this is a RAID, ext2fs or even a hardware
issue, that's why I'm writing both to ext2-devel and linux-raid.

Setup:
- /dev/md1(hd[ab]1): ext2: /
- /dev/md3(hd[ab]3): ext2: /var
- /dev/md4(hd[ab]4): ext2: /home
- /dev/md6(hd[ab]6): swap: -

When I boot up the system with only hda, everything is fine (except
that the RAIDs run degraded, but that's expected :P), even e2fsck
doesn't complain when checking md[134].

Now, when I connect hdb and boot the machine, the Cobalt init scripts
detect a broken RAID, clone the hda partition table to hdb and then
add the newly created hdb partitions to the corresponding md.
That's the point where it breaks:

--8<--[ lots of ]--8<--
ll_rw_block: device 03:01: only 4096-char blocks implemented (1024)
EXT2-fs error (device ide0(3,1)): ext2_write_inode: unable to read \
	inode block [...]
--8<--

I'm not sure what's happening. It looks like the block device
hda1 (3,1) only supports 4096 char sized blocks, but the filesystem
wants to read 1024 char sized blocks.

Any hints on what might be the cause of the problem?

TIA.
-- 
Wolfram Schlich
