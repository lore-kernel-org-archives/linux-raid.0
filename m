From: Kurt Newman <knewman@globaldataguard.com>
Subject: Re: Software raid-5 on root partition (2.6.32.1)
Date: Tue, 27 Jul 2010 19:37:18 -0500
Message-ID: <4C4F7BBE.5010200@globaldataguard.com>
References: <4C4F7AC9.1090201@globaldataguard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C4F7AC9.1090201@globaldataguard.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kurt Newman wrote:
> Q: Does the 2.6.32.1 kernel still support raid-5 on the root device if
> using an initial ram disk?
> Q: Since this isn't working for me, have any suggestions of things to
> look at?
> Q: Is order important when doing an "mkinitrd --preload"?
> 
> Background:
> 
> When booting with busybox, I can mount the partitions, modify them, etc.
>  I'm simply having problems booting.
> 
> The raid devices are clean and aren't sync'ing.
> 
> I've been running a 2.6.20 variant kernel with a machine who's root
> partition is a software raid-5 device (/dev/mdX).  I was not using any
> kernel modules to boot, so no initrd was needed.
> 
> I'm now trying to run 2.6.32.1 + some additional kernel modules via an
> initrd (I put several of the modules in initrd at this point).
> Unfortunately, I'm no longer able to boot with the root partition as a
> raid-5 device.
> 
> The initrd was created using mkinitrd.  I requested that the following
> modules should loan on startup with the --preload option:
> 
>  - pata_it8213
>  - sata_sis
>  - pata_sis
>  - pata_sch
>  - pata_mpiix
>  - pata_it821x
>  - ata_generic
>  - dm-mod
>  - dm-multipath
>  - dm-mirror
>  - dm-log
>  - raid1
>  - raid456
>  - sr_mod
>  - aic94xx
>  - aic79xx
>  - aic7xxx
>  - scsi_transport_spi
>  - BusLogic
>  - mptbase
>  - mptsas
>  - mptspi
>  - mptctl
>  - mptfc
>  - mptlan
>  - mptscsih
> 
> 

I was too quick with the send button.  I forgot to include the kernel
output:

Creating block devices
Creating root device
Mounting root filesystem
EXT3-fs: unable to read superblock
mount: error 22 mounting ext3
pivotroot: pivot_root(/sysroot,/sysroot/initrd) failed: 2
umount /initrd/proc failed: 2
Freeing unused kernel memory: 364k freed
Kernel panic - not syncing: No initial found. Try passing init= option
to kernel
Pid: 1, comm: swapper Not tainted 2.6.32.1 #1
Call Trace:
 [<c102b103>] panic+0x38/0xe4
 [<c1001235>] init_post+0xd3/0xd6
 [<c1427908>] kernel_init+0x83/0x8a
 [<c1427885>] ? kernel_init+0x0/0x8a
 [<c100340f>] kernel_thread_helper+0x7/0x10

