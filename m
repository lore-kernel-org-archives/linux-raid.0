From: Jim Faulkner <jfaulkne@ccs.neu.edu>
Subject: kernel panic under 2.6.2-rc1-mm2
Date: Fri, 23 Jan 2004 21:06:51 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0401232041530.20252@denali.ccs.neu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: akpm@osdl.org
List-Id: linux-raid.ids


2.6.2-rc1-mm2 kernel panics on my machine.  I believe that it is related
to software RAID based on the kernel output.

Unfortunately I do not have the complete output since it locked up at boot
time.  The kernel panic output ran off the screen.  Below is what was on
my screen from top to bottom (minus alot of numbers), and below that is my
current /proc/mdstat and /etc/raidtab.

thanks,
Jim Faulkner

my transcription of the kernel panic
-------------------------------------
printk
autorun_devices
printk
autostart_arrays
do_open
capable
md_ioctl
md_ioctl
blkdev_open
dentry_open
filp_open
md_ioctl
blkdev_ioctl
sys_ioctl
md_run_setup
prepare_namespace
init
init
kernel_thread_helper

Code: (a bunch of numbers)

Kernel Panic: Attempted to kill init!

my /proc/mdstat
---------------

Personalities : [linear] [raid0]
md2 : active raid0 md0[1] hdc1[0]
      123539392 blocks 4k chunks

md1 : active raid0 hde1[1] hda1[0]
      234436352 blocks 8k chunks

md0 : active linear hdh1[1] hdg1[0]
      63512704 blocks 128k rounding

unused devices: <none>


my /etc/raidtab
---------------

raiddev /dev/md0
        raid-level linear
        nr-raid-disks 2
        chunk-size 128
        persistent-superblock 1
        device /dev/hdg1
        raid-disk 0
        device /dev/hdh1
        raid-disk 1

raiddev /dev/md1
        raid-level 0
        nr-raid-disks 2
        chunk-size 8
        persistent-superblock 1
        device /dev/hda1
        raid-disk 0
        device /dev/hde1
        raid-disk 1

raiddev /dev/md2
        raid-level 0
        nr-raid-disks 2
        chunk-size 4
        persistent-superblock 1
        device /dev/hdc1
        raid-disk 0
        device /dev/md0
        raid-disk 1

