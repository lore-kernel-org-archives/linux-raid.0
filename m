From: Andrew Morton <akpm@osdl.org>
Subject: Fw: MD Oops on boot with 2.6.2-rc1-mm3
Date: Sun, 25 Jan 2004 16:17:28 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040125161728.003d0274.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Begin forwarded message:

Date: Sun, 25 Jan 2004 10:28:27 -0500
From: Jonathan Kamens <jik@kamens.brookline.ma.us>
To: linux-kernel@vger.kernel.org
Subject: MD Oops on boot with 2.6.2-rc1-mm3


I get an Oops on boot with 2.6.2-rc1-mm3, trying to boot from a RAID1
MD root partition with two disks in the array; the Oops apparently
causes the raid array not to be assembled, so the boot stops.
Unfortunately, I don't have a serial console so I can't capture the
complete Oops and run ksymoops on it, but here's the information I was
able to gather:

* I have raid=noautodetect turned on, so detection happens from within
  linuxrc in my initrd.  If I get rid of raid=noautodetect, then the
  initial autodetect works fine, but I still get an Oops in the
  autodect run within linuxrc; its call trace looks slightly
  different.

* The kernel was able to successfully start one of my other RAID
  partitions immediately before the Oops which caused md0 to fail to
  start: "raid1: raid set md1 active with 2 out of 2 mirrors".

Here's what I was able to transcribe (I couldn't write down all the
hex numbers that ksymoops would have been able to interpret, but
perhaps what I was able to capture will be helpful):

Unable to handle kernel NULL pointer dereference at virtual address 00000008
EIP is at blkdev_reread_part+0x15/0x90
Call Trace:

  iget5_locked
  blkdev_ioctl
  wake_up_inode
  ioctl_by_bdev
  do_md_run
  printk
  bdevname
  autorun_array
  printk
  bdevname
  autorun_devices
  printk
  autostart_arrays
  exact_lock
  kobj_lookup
  md_ioctl
  get_gendisk
  md_open
  do_open
  blkdev_open
  dentry_open
  blkdev_ioctl
  sys_ioctl
  sys_open
  sysenter_part_esp

I can duplicate this Oops, so if there's any other information from it
which I can provide to help debug it, please let me know.

  jik
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

