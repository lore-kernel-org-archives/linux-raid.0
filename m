From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 11:18:42 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408101021030.1665@lion.drogon.net>
References: <41188A95.5000608@provincia.verbania.it>
 <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net> <411892D0.8050701@provincia.verbania.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411892D0.8050701@provincia.verbania.it>
To: Boniforti Flavio <boniforti@provincia.verbania.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Aug 2004, Boniforti Flavio wrote:

> Gordon Henderson wrote:
>
> > You can do either. Personally, I create identical partitions on each drive
> > and then mirror them.
>
> OK. What would be the difference (in terms of performance and/or ease of
> configuration/maintenance) between the two methods?

OK - this is a very intersting and highly debatable subject!

Personally, I like partitions - lots of them, but thats becasue I'm a
bolring old fart who's been involved with Unix systems of one sort or
another for over 20 years now, and if paritions were good enough for me 20
years ago then they'll work now... (No, thats probably not a good
argument, but hey)

These days I have 2 basic schemes - firstly

  /		Small partition, usually 256MB or so.
  swap		Double RAM just for old-times sake.
  /usr		2GB. Maybe 1GB if it's not running X and space is tight.
  /var		Rest of disk and arrange /home to be a symlink to
			/var/home

This isn't ideal, if someone fills up /var then you can have problems
logging in for example, but just about every other scenario has issues
too.  On a bigger capacity server then I might do the following:

  /		Big partition of maybe 4GB. Includes /var to hold
		mail spool, etc.
  swap		Double RAM
  /usr		1 or 2GB as before
  /mounts/local			Half of rest of disk
  /mounts/local.yesterday	Remaining space

I'll then nightly archive the local partition to the yesterday partition
then re-mount it read-only and dump it to tape. (problems with dump &
ext2/3 on live filesystems)

These aren't ideal (what is?) but with reasonably well behaved users it
works very well and I've been using setups like this for quite some years
now with very results.

Some Linux distros will create a smaller /boot partition. I understand
this was required in the bad old days when the BIOIS could only address
1024 cylinders, so you had to make sure the kernel image was inside that
limit. These days with a modern BIOS it's not required (although others
will have other probably good reasons for using it anyway)

Traditionally, Windows will just put one huge partition on the whole disk
(or maybe 2 once disk got over 4GB and FAT couldn't handle it) and some of
the other Linux distributions do just them themselves.  Technically you
get more disk space avalable to you that way, but these days disk space is
cheap, and with multiple partitions the chance of a head crash taking out
the entire disk is rare and hopefully only limited to one partition (thats
one theory for multiple partitions anyway) (Do heads still "crash"?
Probably unlikely with modern drives, but who knows...)

> > Probably the easiest way to get started is to pick a distribution that
> > lets you build the disks as a mirror from install time - Eg. Red Hat (or
> > whatever it's called these days) If you have an existing server with one
> > disk and want to add a 2nd as a mirror, thats not too difficult. you need
> > to read the stuff in the Software RADI HowTo which has the information on
> > how to do it all.
>
> I see, but I *have to* install Debian on it.

OK. Debian is good - it's what I use :)

But Woddy doesn't have an installer that'll let you install directly onto
RAID )-: I head Sarge will, but thats not going to be releases for a wee
while yet...

> I already installed it (as a test) following the instructions found at:
> http://www.inittab.de/manuals/debootstrap.html

Er - thats a rather "intersting" way to install Debian - I use the
standard Woody CD set..

> I guess the hardest task will be configuring RAID, as the system works
> with the above procedure...

OK. So with Debian, I basic, but minimal system on the first drive, not
touching the 2nd drive at all during this process... I'll usually compile
up a custome kernel at this point to make sure the IDE controllers have
DMA, if nothing else.

Then with the 2nd drive, partition it to be identical to the first disk,
then follow through the runes on the HowTo for mirroring the disks.

You can do it 2 ways - either create a mirror set with 1 disk, the other
being degraded immediately, then raidhotadd it, or create them step by
step, temporarily relocating each partition as you go. (Eg into the swap
partition, after you turn swap off!) I use the latter method.

First, move root to another partition:

Eg. mkfs /dev/hda2 (swap partition), mount /dev/hda2 /mnt ; cd / ;
find . -xdev | cpio -pm /mnt

This is the hard part - cd /mnt, edit /mnt/etc/fstab and /mnt/etc/lilo to
reflect the fact that root is now on /dev/hda2, (make sure swap isn't
going to be mounted!) run lilo -r /mnt and reboot. Hopefully the system
will now boot with /dev/hda2 being root.

I don't know madm, so (because I've been doing it this way for the past 6
years) I then edit an /etc/raidtab to create a raid1 with /dev/hda1 and
/dev/hdc1, mkraid it, mkfs it, mount it under /mnt and copy root back into
it as before, edit /mnt/etc/lilo.conf and /mnt/etc/fstab to make it
mounted under /dev/md0. The key lines in lilo.conf are then:

  boot=/dev/md0
  root=/dev/md0
  raid-extra-boot=/dev/hda,/dev/hdc

and run lilo -r /mnt

(of-course, substitute /dev/sdX for hdX if you are using SCSI)

finally, use cfdisk to set the partition type to fd for /dev/hda1 and
/dev/hdc1 and reboot...

If this works you'll then have root under /dev/md0 and therefore under
RAID1... Then you just repeat this for the other partitions - copy them
into a spare partition (eg the swap one), create an entry in /etc/raditab
for them, mkraid/mkfs/mount/copy/ edit /etc/fstab, cfdisk the partition
types and off you go. Finally make the swap partition RAID1, run mkswap on
it, and re-enable it in the fstab.

It's tedious, but it doesn't really take that long if you just install a
bare minimal system to start with, then raid the lot, then use dselect or
tasksel to install all the other applications you need.

One other tip if you are using ext3 is to tune2fs -i0 -c0 /dev/hdaX after
the mkfs -t ext3 ... to make sure it's not force checked after so many
days/mounts.

Enjoy...

Gordon
