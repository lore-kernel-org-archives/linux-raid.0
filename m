From: Mark Knecht <markknecht@gmail.com>
Subject: metadata and / and grub-static
Date: Sun, 4 Apr 2010 12:34:52 -0700
Message-ID: <j2u5bdc1c8b1004041234j715c0a3fi6bd89c2695f286ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I'm trying to do my first RAID install that puts / on RAID1 but I'm
having some trouble. Distro is Gentoo. I'm fairly certain the problem
is in my kernel because grub finds my RAID enabled kernel and starts
booting, but when it gets to the point where it is going to enable md0
and mount / (or I think that's where it is) then it fails with a very
standard message:

VFS - Unable to mount root fs on unknown-block(9,0)

   I know the machine works because I already have a non-RAID install
on sda. The new RAID install is on sdb & sdc and I'm booting to it
from sda. However so far I cannot get past the point where it figures
out what to do with /dev/md0 and moves on.

   I just wanted to check that the messages below, which occurred when
I first built the RAID, aren't a real killer. I am not storing /boot
on this device but I do want to store /. Is there any problem with
recent versions of grub doing this? I chose metadata=1.0 as mdadm
seemed happier with that choice, but I've been unable to mount this
RAID either.

   Again, if this is a kernel issue then I'll work it out. I've built
RAID0 and RAID1 support into the kernel, as well as other things, but
maybe I've missed something else. I just wanted to be doubly sure that
it's not a problem with grub as a boot loader.

Thanks,
Mark

keeper ~ # mdadm --create /dev/md0 --level=1 --raid-devices=2
/dev/sdb3 /dev/sdc3
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/' or '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=1.0
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/' or '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=1.0
Continue creating array? n
mdadm: create aborted.
keeper ~ #  mdadm --create /dev/md0 --level=1 --raid-devices=2
--metadata=1.0 /dev/sdb3 /dev/sdc3
mdadm: array /dev/md0 started.
keeper ~ # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc3[1] sdb3[0]
      31463228 blocks super 1.0 [2/2] [UU]
      [>....................]  resync =  3.9% (1241664/31463228)
finish=5.2min speed=95512K/sec

unused devices: <none>
keeper ~ #
