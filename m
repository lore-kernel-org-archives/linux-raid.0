From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: Bootable software raid and SuSE 9.1
Date: Thu, 8 Jul 2004 01:38:39 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0407080121210.25702-100000@sweetums.bluetronic.net>
References: <Pine.LNX.4.58.0407072225080.16359@pcmail.chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0407072225080.16359@pcmail.chemie.uni-erlangen.de>
To: Norman Schmidt <Norman.Schmidt@chemie.uni-erlangen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Jul 2004, Norman Schmidt wrote:
>I tried to use the way I use in debian (boot=/dev/md6, raid-extra-boot
>..., append md=6,/... in lilo.conf), but it refuses to assemble the raid.
...
>Later on, the module raid1 is loaded, and then a "raidautorun" is called,

The md= syntax... (Documentation/md.txt)
  for old raid arrays without persistent superblocks:
    md=<md device no.>,<raid level>,<chunk size factor>,<fault level>,dev0...
  for raid arrays with persistent superblocks
    md=<md device no.>,dev0,dev1,...,devn

The "md=" kernel cmdline needs the raid personality(s) to be compiled in,
not as modules.  The setup function is basically a one-shot:

init/do_mounts_md.c:
/*
 * When md (and any require personalities) are compiled into the kernel
 * (not a module), arrays can be assembles are boot time using with AUTODETECT
 * where specially marked partitions are registered with md_autodetect_dev(),
 * and with MD_BOOT where devices to be collected are given on the boot line
 * with md=.....
 * The code for that is here.
 */
...
				(yeah, the grammer police need to fix that)

If the partitions aren't "fd", there's nothing to get them to autostart once
the modules /are/ loaded.

You'd probablly be better off using a partitioned raid array depending on
what else may be using the drives.  This can be complicated.  And at any
rate, it looks like you'll need to build your own kernel or fix the initrd
to load the necessary modules and setup the array(s) via an appropriate
configuration file (mdadm.conf, or whatever)

--Ricky


