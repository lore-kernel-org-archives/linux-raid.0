From: Duncan Laurie <duncan@sunbalt.net>
Subject: Re: Problems with RAID1 on cobalt raq3
Date: 17 Aug 2002 16:09:40 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1029625780.14769.134.camel@atherton>
References: <200208172056.g7HKuHm05754@raq.iceblink.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200208172056.g7HKuHm05754@raq.iceblink.org>
To: valen@tuatha.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Aug 2002 08:02:38 -0700, John P. Looney wrote:
>  I've been battling with getting RAID1 working on the root filesystem of a
> Cobalt raq3 (running RedHat 7.3) for about a week.
> 
>  The current problem is that the Raq3 PROM will not mount a root
> filesystem different to the one that it loads the kernel from initially.
> 
>  The PROM seems to use a variable "set_boot_dev" to get a partition name.
> It mounts this partition, gets a file /boot/vmlinux.gz from it, unzips it,
> and runs.
> 
>  I have hda2 (my original root partition) and hdg1 parts of a mirror setup
> as /dev/md1, which is to be mounted as /. I used the "failed-disk"
> directive to create md1 as / - however, after booting, md1 is mounted on /
> fine, but I cannot add hda2 to this with raidhotadd:
> 
> [root@midir root]# raidhotadd /dev/md1 /dev/hda2                   
> md: can not import hda2, has active inodes!
> md: error, md_import_device() returned -16
> /dev/md1: can not hot-add disk: invalid argument.
> 
>  Does anyone have any idea what could be happening, or how I could resolve
> this ?

Oops, that got sent before I was finished writing it,
I have a couple more questions..

1/ where did hdg come from?  Is there a 3rd party IDE controller
in the PCI slot?  (some RaQ3s had only 1 IDE connector populated..)
If it is, then you might run into problems because most likely the
ROM kernel does not have a driver for it.

2/ the ext3 filesystem might also be confusing the ROM kernel.
If you want to try one that will recognize it look here:

ftp://ftp-eng.cobalt.com/pub/users/duncan/kernel/rom/2.9.37-ext3.rom

This will also give you better control over the boot process,
adding a "set_lparams" function to the boot menu that specifies
the parameters specific to the ROM kernel.  ("set_params' will
pass parameters to the kernel that is loaded from disk)  This
will let you set a different root device to grab a kernel from.

It also has some more built-in PCI IDE drivers, so it might
help with problem #1. (if it is a problem...)

-duncan

