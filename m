From: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Subject: Re: [mdadm PATCH] bcache: add bcache superblock
Date: Tue, 15 May 2012 01:04:57 +0100 (BST)
Message-ID: <alpine.LNX.2.01.1205150042200.12473@stax.localdomain>
References: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511203835.26301.1937.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Fri, 11 May 2012, Dan Williams wrote:

> This is a hybrid proposal for supporting bcache as a md device.
> Somewhat similar to the v1.x metadata format, where array assembly is
> handled in userspace, but managed in the kernel.  In the bcache case it
> is an "external" metadata format, but then the expectation is that the
> kernel "bcache" personality takes over runtime maintenance of the
> metadata.

I am having some trouble with this, can you clarify (perhaps by example) 
how to create a pairing of a cache and backing device?

I tried creating directly:

  # mdadm --create /dev/md0 --level=11 --raid-devices=2 /dev/sdb /dev/sdc 
  mdadm: unknown level 11

But as the code in Assemble.c is patched (and not Create.c), I had a hunch 
to format the devices as before then assemble the array:

  # make-bcache -C /dev/sdb
  # make-bcache -B /dev/sdc
  # mdadm -A /dev/md0 /dev/sdb /dev/sdc 
  mdadm: Cannot assemble mbr metadata on /dev/sdb
  mdadm: /dev/sdb has no superblock - assembly aborted

For a hack, I changed Create.c to accept case 11 and leave the chosen 
chunk size. It got further, but then failed with:

  # mdadm --create /dev/md/bcache --level=11 --raid-devices=2 /dev/sdb /dev/sdc 
  mdadm: /dev/sdb appears to be part of a raid array:
      level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
  mdadm: partition table exists on /dev/sdb but will be lost or
         meaningless after creating array
  mdadm: /dev/sdc appears to be part of a raid array:
      level=raid0 devices=0 ctime=Thu Jan  1 01:00:00 1970
  mdadm: partition table exists on /dev/sdc but will be lost or
         meaningless after creating array
  mdadm: largest drive (/dev/sdc) exceeds size (117155216K) by more than 1%
  Continue creating array? y
  mdadm: Defaulting to version 1.2 metadata
  mdadm: RUN_ARRAY failed: Cannot allocate memory

Maybe I missed something basic here, but I'm afraid can't see what? If 
not, hopefully this information is useful.

I use bcache v13 patches and the MD conversion, and this patch to mdadm.

  $ lsmod | grep bcache
  md_bcache               3202  0 
  bcache                138187  1 md_bcache
  md_mod                 88671  5 md_bcache,raid456,raid1

  $ uname -a
  Linux stax 3.4.0-rc7-mh+ #190 SMP PREEMPT Sun May 13 22:36:17 BST 2012 i686 Intel(R) Pentium(R) D CPU 2.80GHz GenuineIntel GNU/Linux

Thanks

-- 
Mark
