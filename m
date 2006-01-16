From: Neil Brown <neilb@suse.de>
Subject: Re: block size issue when re-syncing RAID1 with ext2fs on top
Date: Tue, 17 Jan 2006 09:43:22 +1100
Message-ID: <17356.8586.574751.179265@cse.unsw.edu.au>
References: <20060116175549.ALLYOURBASEAREBELONGTOUS.M23957@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wolfram Schlich on Monday January 16
Sender: linux-raid-owner@vger.kernel.org
To: Wolfram Schlich <lists@wolfram.schlich.org>
Cc: ext2-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 16, lists@wolfram.schlich.org wrote:
> Hi,
> 
> I'm experiencing a problem on a 2.2.16C37_III driven Cobalt RaQ4
> after I add a new 2nd disk to a RAID1.

2.2.16 .... that's old, isn't it!
raid1 was only every available as external patches for 2.2 kernels...


> 
> I'm uncertain whether this is a RAID, ext2fs or even a hardware
> issue, that's why I'm writing both to ext2-devel and linux-raid.
> 
> Setup:
> - /dev/md1(hd[ab]1): ext2: /
> - /dev/md3(hd[ab]3): ext2: /var
> - /dev/md4(hd[ab]4): ext2: /home
> - /dev/md6(hd[ab]6): swap: -
> 
> When I boot up the system with only hda, everything is fine (except
> that the RAIDs run degraded, but that's expected :P), even e2fsck
> doesn't complain when checking md[134].
> 
> Now, when I connect hdb and boot the machine, the Cobalt init scripts
> detect a broken RAID, clone the hda partition table to hdb and then
> add the newly created hdb partitions to the corresponding md.
> That's the point where it breaks:
> 
> --8<--[ lots of ]--8<--
> ll_rw_block: device 03:01: only 4096-char blocks implemented (1024)
> EXT2-fs error (device ide0(3,1)): ext2_write_inode: unable to read \
> 	inode block [...]
> --8<--

The fact that EXT2 is reporting an error with ide0(3,1) is a worry.
Ext2 shouldn't even see the ide drives.  It should just see md devices
which should hide all the underlying details.

So I suspect the problem is that you are mounting the root filesystem
of hda1 rather than md1

The resync code will set the blocksize for hda1 to 4096, and the ext2
code will try to read 1024byte blocks, and it fails with the message
you see.

NeilBrown
