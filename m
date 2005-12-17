From: Andargor The Wise <andargor@yahoo.com>
Subject: RE: First RAID Setup
Date: Fri, 16 Dec 2005 16:00:43 -0800 (PST)
Message-ID: <20051217000043.17508.qmail@web54614.mail.yahoo.com>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4D@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0481A62A3E95A044AC20A1A45899645C06B02F4D@glc-mail-1.tessco.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Callahan, Tom" <CallahanT@tessco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I got things up and running, hopefully. A question
about LILO, however.

This is my raidtab:

raiddev /dev/md0
        raid-level 1
        nr-raid-disks 3
        nr-spare-disks 0
        chunk-size 32
        persistent-superblock 1
        device /dev/sda1
        raid-disk 0
        device /dev/sdb1
        raid-disk 1
        device /dev/sdc1
        raid-disk 2

raiddev /dev/md1
        raid-level 1
        nr-raid-disks 3
        nr-spare-disks 0
        chunk-size 32
        persistent-superblock 1
        device /dev/sda2
        raid-disk 0
        device /dev/sdb2
        raid-disk 1
        device /dev/sdc2
        raid-disk 2

raiddev /dev/md2
        raid-level 5
        nr-raid-disks 3
        nr-spare-disks 0
        parity-algorithm left-symmetric
        chunk-size 32
        persistent-superblock 1
        device /dev/sda5
        raid-disk 0
        device /dev/sdb5
        raid-disk 1
        device /dev/sdc5
        raid-disk 2

And my lilo.conf:

boot=/dev/md0
raid-extra-boot=/dev/sda,/dev/sdb,/dev/sdc
map=/boot/System.map
install=/boot/boot.b
message=/boot/boot_message.txt
prompt
compact
lba32
timeout=30
default=Linux

change-rules
  reset
vga = normal

image = /boot/bzImage-2.6.14.4
  root = /dev/md2
  append="idebus=66"
  label = Linux
  read-only

image = /boot/vmlinuz
  root = /dev/md2
  append="idebus=66"
  label = slack_orig
  read-only

When I run LILO, I get:

Warning: COMPACT may conflict with LBA32 on some
systems
Added Linux *
Added slack_orig
The boot record of  /dev/md0  has been updated.
The boot record of  /dev/sda  has been updated.
Warning: /dev/sdb is not on the first disk
The boot record of  /dev/sdb  has been updated.
Warning: /dev/sdc is not on the first disk
The boot record of  /dev/sdc  has been updated.

Are the warnings normal?

Andargor



--- "Callahan, Tom" <CallahanT@tessco.com> wrote:

> Sorry, I'm programmed for HA lately. Your plan
> sounds good then, I wish you
> the best of luck.
> 
> Tom Callahan
> 
> -----Original Message-----
> From: Andargor The Wise [mailto:andargor@yahoo.com]
> Sent: Thursday, December 15, 2005 3:22 PM
> To: Callahan, Tom; linux-raid@vger.kernel.org
> Subject: RE: First RAID Setup
> 
> 
> 
> 
> --- "Callahan, Tom" <CallahanT@tessco.com> wrote:
> 
> > I understand the reason for the RAID1 devices.....
> I
> > was asking why you have
> > 3 devices in the RAID1 setup? RAID1 is a mirrored
> > configuration, requiring
> > only 2 disks for operation.
> 
> Right. Like I indicated, I reviewed this list for
> suggested configurations and this is what I came up
> with as a result.
> 
> I guess you do only need two disks, since you'll be
> able to recover anyway, but it seemed a simpler
> config
> with identical disk partitions and only a small
> amount
> of space wasted on one disk.
> 
> > It is always wise to build in a spare however,
> that
> > being said about all
> > raid levels. In your configuration, if a disk
> fails
> > in your RAID5, your
> > array will go down. RAID5 is usually 3+ disks,
> with
> > a mirror. So you should
> > have 3 disks at minimum, and then a 4th as a
> spare.
> 
> But if I don't mind the machine coming down, I don't
> think I need a spare? I just want to be able to rip
> out the bad drive, slap in a new one, rebuild, and
> be
> back in business with all my data. I don't need HA.
> 
> (snip)
> > Another gotcha, it's usually better to use entire
> > disks, if you can afford
> > to, in an MD array. This alleviates growing pains
> of
> > having to manually
> > repartition if you want to grow an exisiting
> > filesystem. This may not make
> > much sense now, but once you have to do it, you'll
> > smack your forehead in
> > grief.
> 
> Yes, I can see that, you instead grow by slapping in
> extra disks and then resizing the array. Hmm. I'll
> have to think about that.
> 
> > 
> > Thanks,
> > Tom Callahan
> 
> 
> Thanks for the advice, lots to mull over. I've got
> time, I'm still ddrescue'ing my crashed drive... :)
> 
> Andargor
> 
> 
> 
> > 
> > -----Original Message-----
> > From: Andargor The Wise
> [mailto:andargor@yahoo.com]
> > Sent: Thursday, December 15, 2005 2:45 PM
> > To: Callahan, Tom; linux-raid@vger.kernel.org
> > Subject: RE: First RAID Setup
> > 
> > 
> > The RAID1 partitions are to make sure:
> > 
> > 1) The machine is able to boot even if a disk is
> > lost
> > (/boot).
> > 2) The machine isn't brought down if a disk is
> lost
> > (swap)
> > 
> > I thought about a spare drive, but I don't need
> high
> > availability. I'm satisfied with being able to
> > recover
> > my data.
> > 
> > Andargor
> > 
> > 
> > --- "Callahan, Tom" <CallahanT@tessco.com> wrote:
> > 
> > > You "should" have a designated spare for RAID-5.
> > > 
> > > Not sure why you have 3 disks for each RAID1,
> > RAID1
> > > is mirror, and unless
> > > the third drive is a spare, it is not needed.
> > > 
> > > Thanks,
> > > Tom Callahan
> > > 
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org
> > > [mailto:linux-raid-owner@vger.kernel.org]On
> Behalf
> > > Of Andargor The Wise
> > > Sent: Thursday, December 15, 2005 2:10 PM
> > > To: linux-raid@vger.kernel.org
> > > Subject: First RAID Setup
> > > 
> > > 
> > > I admit it. I'm a RAID virgin.
> > > 
> > > However, after a disastrous failure of the sole
> > > drive
> > > I wasn't backing up, I decided to go RAID-5
> under
> > > Slack 10.2 (first time ever with RAID-5).
> > > 
> > > The config:
> > > 
> > > Asus P5GL-MX (ICH6) mobo w/1 GB RAM, 4 x SATA
> > ports
> > > P4 3.0G/1M
> > > 3 x WD2000JS 200.0 GB SATA drives
> > > 
> > > First, a question: the BIOS on this machine
> seems
> > to
> > > list the SATA ports as "third/fourth IDE
> > > master/slave". Further, the documentation seems
> to
> > > say
> > > that SATA 1/2 are "master" and SATA 3/4 are
> > "slave"
> > > (black and red connectors, respectively).
> > > 
> > > My understanding is that SATA drives are each on
> > > separate buses. Is this because the BIOS offers
> a
> > > P-ATA emulation mode for SATA and it makes it
> > > "easier"
> > > to understand for novices to show them that way?
> > > 
> > > I ask because people have said that it is not a
> > good
> > > idea to have both IDE masters and slaves on the
> > same
> > > bus as part of a RAID-5 array. I know SATA is
> > > different, but will using three of the SATA
> ports
> > on
> > > this mobo be OK?
> > > 
> > > Second, after reading the excellent advice in
> this
> > > list, I decided that booting from RAID-5 might
> not
> > > be
> > > a good idea. So this is what I've been thinking:
> > > 
> > > Each disk partitioned alike:
> > > 	1	30MB 
> > > 	2	8GB (to allow for memory upgrades later)
> > > 	5	rest_of_disk
> > > 
> > > mds:
> > > 	md0	raid1 sda1 sdb1 sdc1
> > > 	md1	raid1 sda2 sdb2 sdc2
> > > 	md2	raid5 sda5 sdb5 sdc5
> > > 
> > > 	md0	/boot
> > > 	md1	swap
> > > 	md2	/
> > > 
> > > Does this look OK? What should the stripe and
> > chunk
> > > sizes be, considering I'll be going with
> reiserfs?
> > > Typical usage: development machine, some DB apps
> > > with
> > > medium load, read-only mostly, not many writes.
> 
=== message truncated ===


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
