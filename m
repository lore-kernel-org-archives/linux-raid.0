From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: Please help- raid1 recovery after disk failure
Date: Tue, 26 Oct 2004 21:20:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041027042059.GJ30613@sam.triumf.ca>
References: <20041018225652.GC29864@sam.triumf.ca> <1098141725.5229.47.camel@MIKETRAN.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1098141725.5229.47.camel@MIKETRAN.austin.ibm.com>
To: Mike Tran <mhtran@us.ibm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 18, 2004 at 06:22:05PM -0500, Mike Tran wrote:
> I would re-create md0 array with a missing disk as follows:
> mdadm -C /dev/md0 -l 1 -n 2 /dev/hdc2 missing
> Later you can hot add a disk to make it a normal 2-way mirror array.

Thanks for all the responses and suggestions- I was able to rebuild
my raid1 (mirror) array without losing any data. For the record,
this is what I did:

0) /dev/hdc2 (half-mirror) mounted as "/"
1) mdadm -C /dev/md0 ... /dev/hdc2 ...
   did not work- says "hdc2" is busy. Maybe it's for the better.
2) reboot into the Fedora2 rescue CD, get the rescue root shell
3) make sure hdc2 is not mounted, md0 is not active (they are not)
4) mdadm -C /dev/md0 -l1 -n2 -c256 /dev/hdc2 missing
   (may have warned about something)
5) mdadm --start /dev/md0, cat /proc/mdstat, mount /dev/md0 /mnt/tmp,
   edit grub.conf (root=/dev/hdc2->/dev/md0), edit fstab (hdc2->md0).
   Notes: /proc/mdstat shows two devices with status status [U_].
6) umount /dev/md0, mdadm --stop /dev/md0
7) reset, remove rescue CD
8) boot from the hard disk, note: md0 started, mounted as "/".
9) mdadm /dev/md0 -a /dev/hda2, note: resync starts automatically
10) wait for resync to complete, 160 Gbyte took about 90 minutes
11) /proc/mdstat shows status [UU].
12) shutdown, move loose disks into enclosures, close the box
13) boot: md0 comes up, status [UU], I am in business until the next
    spurious read error (I am too lazy to roll a custom patched kernel,
    I would rather wait until Red Hat apply the raid1 patches fixing
    bug 136485).

K.O.


> On Mon, 2004-10-18 at 17:56, Konstantin Olchanski wrote:
> > Dear Linux raiders- I ran into a problem with raid1 recovery after
> > a disk failure (running Fedora2, kernel 2.6.8-1.521smp).
> > 
> > 1) I had a raid1 filesystem mirrored across /dev/hda2 and /dev/hdc2.
> > 2) Disk hda died (unreadable sectors, fails SMART tests)
> > 3) A new blank hda was installed and partitionned exactly like hdc.
> > 4) I cannot restart and rebuild the raid1 volume because hdc2 is
> >    in a funny "spare" state (see below)
> > 
> > How do I mark hdc2 as "active"?
> > Once "active", I assume then I will be able to restart md0,
> > hot-add /dev/hda2 as usual. (And the mirror will resync and rebuild itself?
> > Hopefully?)
> > 
> > [root@tw04 root]# mdadm -E /dev/hdc2
> > /dev/hdc2:
> >           Magic : a92b4efc
> >         Version : 00.90.00
> >            UUID : aade8782:20122089:4f496788:228d85b9
> >   Creation Time : Fri Oct  8 17:12:56 2004
> >      Raid Level : raid1
> >     Device Size : 124158208 (118.41 GiB 127.14 GB)
> >    Raid Devices : 2
> >   Total Devices : 2
> > Preferred Minor : 0
> > 
> >     Update Time : Mon Oct 18 06:04:35 2004
> >           State : clean, no-errors
> >  Active Devices : 1
> > Working Devices : 2
> >  Failed Devices : 1
> >   Spare Devices : 1
> >        Checksum : 7041db42 - correct
> >          Events : 0.312429
> > 
> > 
> >       Number   Major   Minor   RaidDevice State
> > this     2      22        2        2      spare   /dev/hdc2
> >    0     0       3        2        0      active sync   /dev/hda2
> >    1     1       0        0        1      faulty removed
> >    2     2      22        2        2      spare   /dev/hdc2
> > [root@tw04 root]# 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
