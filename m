From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: RAID 0 went down...
Date: Mon, 11 Oct 2004 05:10:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097489440.5815.30.camel@langvan2.homenetwork>
References: <4aaefdb041011052847dd1c18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4aaefdb041011052847dd1c18@mail.gmail.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Romeyn,

If there were I/O errors on one of the disks, I am not sure that you
want to re-assemble/re-create this "corrupted" raid0 array.  However, if
you just want to get some data out of the volume /dev/md0, you can use
mdadm to re-create the array:

mdmadm -C -R /dev/md0 -c 64 -l 0 -n 2 /dev/sdb1 /dev/sdc1

Regards,
Mike T.

On Mon, 2004-10-11 at 07:28, Romeyn Prescott wrote:
> I have a RH 9.0 box with a RAID 0.  I started getting some I/O errors
> and when I rebooted the box md0 wouldn't mount.
> 
> /etc/raiddtab:
> -----
> raiddev             /dev/md0
> raid-level                  0
> nr-raid-disks               2
> chunk-size                  64k
> persistent-superblock       1
> nr-spare-disks              0
>     device          /dev/sdb1
>     raid-disk     0
>     device          /dev/sdc1
>     raid-disk     1
> -----
> 
> The problem appears to be with /dev/sdc, yet it passes all of the
> manufacturer's (Seagate) diagnostics.  Here's what /var/log/dmesg
> says:
> -----
> md: Autodetecting RAID arrays.
>  [events: 00000095]
>  [events: 00000031]
> md: autorun ...
> md: considering sdc1 ...
> md:  adding sdc1 ...
> md:  adding sdb1 ...
> md: created md0
> md: bind<sdb1,1>
> md: bind<sdc1,2>
> md: running: <sdc1><sdb1>
> md: sdc1's event counter: 00000031
> md: sdb1's event counter: 00000095
> md: superblock update time inconsistency -- using the most recent one
> md: freshest: sdb1
> md: kicking non-fresh sdc1 from array!
> md: unbind<sdc1,1>
> md: export_rdev(sdc1)
> md0: former device sdc1 is unavailable, removing from array!
> md0: max total readahead window set to 512k
> md0: 2 data-disks, max readahead per data-disk: 256k
> md: md0, array needs 2 disks, has 1, aborting.
> raid0: disks are not ordered, aborting!
> md: pers->run() failed ...
> md :do_md_run() returned -22
> md: md0 stopped.
> md: unbind<sdb1,0>
> md: export_rdev(sdb1)
> md: ... autorun DONE.
> -----
> 
> Is there any way I can recover from this?  I've been googling my
> brains out, but most of what I find relates to RAID1.  Restoring from
> a backup is possible, but..."complicated" and is my last resort.
> 
> TIA,
> ...ROMeyn

