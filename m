From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Thu, 13 May 2010 18:30:37 -0500
Message-ID: <CA.2D.20538.1AB8CEB4@cdptpa-omtalb.mail.rr.com>
References: <1273724133.5140.833.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1273724133.5140.833.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: 'Daniel Reurich' <daniel@centurion.net.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Thank you for your response.  My hat is off to you.  Few people
return such thorough and detailed posts.

> > 	Hello?  Anyone?  I'm flummoxed, here.  I tried to write in a manual
> > assembly of the arrays in the initrd, but so far I haven't been able to
> get
> > it to work.  One way or another, it just hangs when running
> > /scripts/local-top/mdadm in the initrd.  Even `ls -1 /dev/sd*` returns
> an
> > error.
> >
> Ok.
> 
> 1) Get business card image from the link provided and burn to CD and
> boot of it.
> 
> http://www.debian.org/devel/debian-installer/
> 
> 2) Select Advanced Options then expert install.
> 3) Set Language etc.
> 4) When it asks to select installer components select "Network Console"
> and continue.
> 5) Configure the network (if you haven't already),
> 6) In the menu select "Continue installation remotely using ssh and
> follow the instructions to connect in via ssh from your desired
> workstation and continue.
> 7) Select exit to shell
> 8) insert the appropriate raid modules: 'modprobe raidX' where X is the
> raid levels you use for each raid level you use.
> 9) use mdadm to manually assemble the necessary root, /boot and /var
> arrays.

	/var is just part of the main array.  Only /boot and the swap area
have their own partitions.  Interestingly enough, the installer kernel shows
the drives to be /dev/hda and /dev/hdb, again.  Apparently the installer
uses an older kernel?  Oh, and it can assemble the third array (the swap
area) just fine, or at least it says it can:

~ # mdadm -Dt /dev/md3
/dev/md3:
        Version : 1.02
  Creation Time : Sun Dec 20 05:05:08 2009
     Raid Level : raid1
     Array Size : 204796548 (195.31 GiB 209.71 GB)
  Used Dev Size : 204796548 (195.31 GiB 209.71 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon May 10 01:08:00 2010
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : 'Backup':3
           UUID : 3615c4a2:33786b6d:b13863d9:458cd054
         Events : 66

    Number   Major   Minor   RaidDevice State
       2       3        3        0      active sync   /dev/hda3
       1       3       67        1      active sync   /dev/hdb3

> 10) If your root fs is in LVM do: "modprobe dm_mod" followed by
> "vgchange -ay"
> 11) make a target directory: "mkdir /target"
> 12) mount the root filesystem on /target: mount /dev/<rootfs> /target

	'No joy:

~ # mount -o -v  /dev/md1 /target
mount: mounting /dev/md1 on /target failed: Invalid argument

	So now, what?  I can mount the arrays just fine under the Ubuntu
live CD, but not this one.

> 13) bind mount the dev sys and proc virtual filesystems:
> 	"mount -o bind /dev /target/dev"
> 	"mount -o bind /sys /target/sys"
> 	"mount -o bind /proc /target/proc"
> 14) Chroot: chroot /target /bin/bash
> 15) mount /boot /usr /var as needed.
> 16) update your mdadm.conf and /etc/fstab etc (ideally use labels for
> root and boot or fs UUID's), and any other stuff like installing the
> latest mdadm (apt|aptitude should work fine if your internet connected).

	Uh-uh, again.  Neither apt-get nor aptitude seem to be on the CD, at
least not when installing this way.

> > 	It's also really odd that I can assemble and mount the root and boot
> > arrays, but under Ubuntu I can't even assemble the swap array.  It
> complains
> > that the first member of the array is busy and refuses to start
> /dev/md3.
> > The results of --examine look identical to those listed below, except of
> > course for the partition specific entries (size, drive and array UUID,
> > events, etc).
> >
> This is because ubuntu probably picks up the first swap partition it
> finds and uses it.

	It doesn't mention it when I issue `mount` or lsof.  What's more, it
gives the same error for both partitions.  Also, as I mentioned, it doesn't
show any errors when I issue `sudo mdadm --examine [sda3|sdb3]`.  Finally,
it assembles without complaint under the Debian live CD.

> It seems odd to me that all the raid volumes are named "Backup".
> Perhaps mdadm doesn't like the name collision.

	First of all, isn't that the homehost name?  If so, it is *SUPPOSED*
to be the same for all three.  Secondly, it assembled just fine under the
old kernel and mdadm, as I mentioned.  Thirdly, if it were the case, I would
expect it to assemble at least the first target without complaint.  Finally,
the names aren't the same.  They are 'Backup':1, 'Backup':2, and 'Backup':3

> Perhaps you need to recreate some of them with a different name.  I'd
> suggest recreating the raid1 volumes with different names and the
> --assume-clean flag (except the swap one which won't be since the ubuntu
> live cd's been messing with one of those component partitions).

	I think before I try something like that, I would just trash one
element of each array, assemble the arrays broken with just one element, and
copy over the files to the "new" partitions, and go from there.

> I hope this helps.

	Well, I'm getting somewhere.  I'm just not sure where, if I can't
get mount to work.

