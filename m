From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-0 Autodetection fails
Date: Mon, 29 Jul 2002 20:05:44 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15685.4984.691089.491992@notabene.cse.unsw.edu.au>
References: <3D3E9BEB.41C0F8CC@infodesign-osd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Agustinus Tedja on Wednesday July 24
To: agustinus.tedja@infodesign-osd.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 24, agustinus.tedja@infodesign-osd.de wrote:
> Hello everybody,
> I am installing Linux SuSE 8.0 with kernel version 2.4.18-4GB. This
> kernel should have already contain the Software-RAID module as
> advertised by SuSE.
> I have 3 equal drives. For simplicity I installed complete Linux only in
> a drive hdb(the boot and the root is in this normal drive) and now I am
> trying to make a RAID level 0 with the rest 2 drives called hdc and hdd. 
> I have made these two drives into a RAID-drive called /dev/md0 with
> YaST2 help and it was successfully mounted and used.
> But each time I rebooted the system, this /dev/md0 could not be
> recognized at startup and all data in /dev/md0 was lost as well. I
> needed to mount it again afterwards, that made it a silly idea.
> What is wrong ? Any hints and helps are gladly welcomed.

Two problems:
  1/ your kernel has the MD driver included, but not the raid0
      personality module.
  2/ You array is madeof /dev/hdc1 and /dev/hdd1, but your
     /etc/raidtab says /etc/hdc and /dev/hdd (no '1').

However it seems to load the raid0 module eventually and does assemble
the raid0 array, so you should be able to mount it...

Possibly just fixing raidtab will fix your problem.
Otherwise complain to SuSE.  The problem is somehow related to their
kernel and their YaST tool.

NeilBrown

  
 
> 
> Here is the message on boot:
> ...
> <6>md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
> <6>md: Autodetecting RAID arrays.
> <6> |events: 0000009a]
> <6> |events: 0000009a]
> <6>md: autorun ...
> <6>md: considering hdd1 ...
> <6>md:  adding hdd1 ...
> <6>md:  adding hdc1 ...
> <6>md: created md0
> <6>md: bind<hdc1,1>
> <6>md: bind<hdd1,2>
> <6>md: running: <hdd1><hdc1>
> <6>md: hdd1's event counter: 0000009a
> <6>md: hdc1's event counter: 0000009a
> <3>request_module[md-personality-2]: Root fs not mounted
> <3>md: personality 2 is not loaded!
> <4>md: do_md_run() returned -22
> <6>md: md0 stopped.
> <6>md: unbind<hdd1,1>
> <6>md: export_rdev(hdd1)
> <6>md: unbind<hdc1,0>
> <6>md: export_rdev(hdc1)
> <6>md: ... autorun DONE.
> 
> ...and after some lines below there is other messages:
> 
> <3>md: invalid raid superblock magic on hdc
> <4>md: hdc has invalid sb, not importing!
> <4>md: could not import hdc!
> <4>md: autostart hdc failed!
> <6>md: Autodetecting RAID arrays.
> <6> |events: 0000009a]
> <6> |events: 0000009a]
> <6>md: autorun ...
> <6>md: considering hdd1 ...
> <6>md:  adding hdd1 ...
> <6>md:  adding hdc1 ...
> <6>md: created md0
> <6>md: bind<hdc1,1>
> <6>md: bind<hdd1,2>
> <6>md: running: <hdd1><hdc1>
> <6>md: hdc1's event counter: 0000009a
> <6>md: hdd1's event counter: 0000009a
> <6>md: raid0 personality readahead registered as nr 2
> <6>md0: max total readahead window set to 496k
> <6>md0: 2 data-disks, max readahead per data-disk: 248k
> <4>raid0: looking at hdc1
> <4>raid0:   comparing hdc1 (80418112) with hdc1(80418112)
> <4>raid0:   END
> <4>raid0:   ==> UNIQUE
> <4>raid0: 1 zones
> <4>raid0: looking at hdd1
> <4>raid0:   comparing hdd1 (80418112) with hdc1(80418112)
> <4>raid0:   EQUAL
> <4>raid0: FINAL 1 zones
> <4>raid0: zone 0
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> <4>raid0:
> 
> FYI here I give the content of some important files:
> /etc/fstab:
> 	/dev/hdb3	/		reiserfs	defaults 1 2
> 	/dev/hdb2	/boot		reiserfs	defaults 1 2
> 	/dev/md0	/dataraid	auto		noauto, user 0 0
> 	devpts		/dev/pts	devpts		defaults 0 0
> 	/dev/cdrecorder	/media/cdrecorder auto		ro,noauto,user,exec 0 0
> 	/dev/cdrom	/media/cdrom	auto		noauto,user,exec 0 0
> 	/dev/fd0	/media/floppy	auto		noauto,user,sync 0 0
> 	usbdevs		/proc/bus/usb	usbdevs		noauto 0 0
> 	proc		/proc		proc		defaults 0 0
> 	/dev/hdb1	swap		swap		pri=42 0 0	
> 
> /etc/raidtab:
> 	raiddev /dev/md0
> 	raid-level 0
> 	nr-raid-disks 2
> 	persistent-superblock 1
> 	chunk-size 32
> 	device /dev/hdc
> 	raid-disk 0
> 	device /dev/hdd
> 	raid-disk 1
> 
> /etc/mtab: (not mdtab, inside there is no md0 entry)
> 	/dev/hdb3 	/	reiserfs	rw 0 0
> 	proc		/proc	proc		rw 0 0
> 	devpts		/dev/pts devpts		rw 0 0
> 	/dev/hdb2	/boot	reiserfs	rw 0 0
> 	shmfs		/dev/shm  shm		rw 0 0
> 	usbdevfs 	/proc/bus/usb  usbdevs	rw 0 0
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
