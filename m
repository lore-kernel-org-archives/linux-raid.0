From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: RAID md-personality
Date: Fri, 11 Jul 2003 09:31:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F0EBC2B.6537D31D@SteelEye.com>
References: <007701c34778$32aea5e0$c9e903ca@magnus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Chambon <raid-ml@cronos.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Chambon wrote:
 
> 1) During boot time, when md is trying to autodetect a RAID array before the
> root
> filesystem is mounted, I get the following error when kmod
> is trying to load md-personality (someone know what this module is for ?).

This first autorun attempt occurs at md initialization time, before the
initrd is loaded, so there are no modules available. That's why the
failure occurs. This is actually expected behavior for Red Hat and SuSE
installations...more below...

 
> =========
> Jul  9 15:28:29 mekare kernel: md: md driver 0.90.0 MAX_MD_DEVS=256,
> MD_SB_DISKS=27
> Jul  9 15:28:29 mekare kernel: md: Autodetecting RAID arrays.
> Jul  9 15:28:29 mekare kernel:  [events: 00000004]
> Jul  9 15:28:29 mekare kernel:  [events: 00000004]
> Jul  9 15:28:29 mekare kernel: md: autorun ...
> Jul  9 15:28:29 mekare kernel: md: considering hdc1 ...
> Jul  9 15:28:29 mekare kernel: md:  adding hdc1 ...
> Jul  9 15:28:29 mekare kernel: md:  adding hda8 ...
> Jul  9 15:28:29 mekare kernel: md: created md0
> Jul  9 15:28:29 mekare kernel: md: bind<hda8,1>
> Jul  9 15:28:29 mekare kernel: md: bind<hdc1,2>
> Jul  9 15:28:29 mekare kernel: md: running: <hdc1><hda8>
> Jul  9 15:28:29 mekare kernel: md: hdc1's event counter: 00000004
> Jul  9 15:28:29 mekare kernel: md: hda8's event counter: 00000004
> Jul  9 15:28:29 mekare kernel: md: md0: raid array is not clean -- starting
> background reconstruction
> Jul  9 15:28:29 mekare kernel: md: RAID level 1 does not need chunksize!
> Continuing anyway.
> Jul  9 15:28:29 mekare kernel: kmod: failed to exec /sbin/modprobe -s -k
> md-personality-3, errno = 2
> Jul  9 15:28:29 mekare kernel: md: personality 3 is not loaded!
> ==========
 

> - I can' find this module anywhere.

Look in /etc/modules.conf for an "alias md-personality ..." line.


> - I have tried to include the raid1 module in the RAMDISK using mkinitrd
> but I still have the same error.

Yes, I would expect that.


> - When the root filesystem is mounted, I don't have this error anymore as
> you can see:
> 
> =========
> Jul  9 15:28:29 mekare kernel: VFS: Mounted root (ext2 filesystem).
> Jul  9 15:28:29 mekare kernel: md: raid1 personality registered as nr 3
> Jul  9 15:28:29 mekare kernel: Journalled Block Device driver loaded
> Jul  9 15:28:29 mekare kernel: md: Autodetecting RAID arrays.
> Jul  9 15:28:29 mekare kernel:  [events: 00000004]
> Jul  9 15:28:29 mekare kernel:  [events: 00000004]
> Jul  9 15:28:29 mekare kernel: md: autorun ...
> Jul  9 15:28:29 mekare kernel: md: considering hda8 ...
> Jul  9 15:28:29 mekare kernel: md:  adding hda8 ...
> Jul  9 15:28:29 mekare kernel: md:  adding hdc1 ...
> Jul  9 15:28:29 mekare kernel: md: created md0
> Jul  9 15:28:29 mekare kernel: md: bind<hdc1,1>
> Jul  9 15:28:29 mekare kernel: md: bind<hda8,2>
> Jul  9 15:28:29 mekare kernel: md: running: <hda8><hdc1>
> Jul  9 15:28:29 mekare kernel: md: hda8's event counter: 00000004
> Jul  9 15:28:29 mekare kernel: md: hdc1's event counter: 00000004
> Jul  9 15:28:29 mekare kernel: md: md0: raid array is not clean -- starting
> background reconstruction
> Jul  9 15:28:29 mekare kernel: md: RAID level 1 does not need chunksize!
> Continuing anyway.
> Jul  9 15:28:29 mekare kernel: md0: max total readahead window set to 508k
> Jul  9 15:28:29 mekare kernel: md0: 1 data-disks, max readahead per
> data-disk: 508k
> Jul  9 15:28:29 mekare kernel: raid1: device hda8 operational as mirror 0
> ===========

The way that distros (at least Red Hat and SuSE) do this is to let the
initial autorun attempt fail and then, inside the initrd, they load the
necessary raid personality modules, as well as the necessary storage
drivers (in your case IDE is built-in) and then they manually call the
RAID_AUTORUN ioctl of md, to trigger a second autorun. It's sort of
convoluted...

--
Paul
