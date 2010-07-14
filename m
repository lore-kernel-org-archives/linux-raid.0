From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: mdadm "hang", 100% CPU usage when trying to create RAID-1 array with
 external bitmap
Date: Wed, 14 Jul 2010 12:53:45 +0200
Message-ID: <4C3D9739.7030703@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to create RAID-1 with external bitmap with this command:

mdadm --create /dev/md11 --level=1 --bitmap=/mnt/src/bitmap --raid-devices 2 /dev/storage/origin missing


/dev/storage/origin is 1.2 TB; is placed on "stacked" block devices like this:

RAID-5 -> dm-crypt -> LVM-2 -> /dev/storage/origin


/mnt/src/bitmap is technically the same stacked device, except the last LVM volume:

RAID-5 -> dm-crypt -> LVM-2 -> /dev/storage/src -> /mnt/src/bitmap

(although I tried to keep bitmap outside of this RAID-5 device, and it was still hanging).


When started with "strace", mdadm hangs with 100% CPU usage after opening /mnt/src/bitmap:

(...)
rename("/var/run/map.new", "/var/run/map") = 0
flock(3, LOCK_UN)                       = 0
close(3)                                = 0
munmap(0x6ff40000, 4096)                = 0
unlink("/var/run/map.lock")             = 0
ioctl(4, 0x800c0910, 0x77f5f89c)        = 0
fstat64(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 1), ...}) = 0
fstat64(4, {st_mode=S_IFBLK|0600, st_rdev=makedev(9, 1), ...}) = 0
ioctl(4, 0x800c0910, 0x77f5f7cc)        = 0
ioctl(4, 0x40480923, 0x77f5f854)        = 0
access("/mnt/src/bitmap", F_OK)         = -1 ENOENT (No such file or directory)
open("/mnt/src/bitmap", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 3


I see no disk activity when this happens.


# mdadm -V
mdadm - v3.1.2 - 10th March 2010

Kernel is 2.6.34.1 (tried also 2.6.28.7), 32 bit x86 system.

Or, I didn't wait long enough? So far, it takes about an hour to create this array...

Creating smaller arrays (i.e. 8 GB) in a similar configuration works fine.


-- 
Tomasz Chmielewski
http://wpkg.org
