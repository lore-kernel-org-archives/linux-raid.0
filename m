From: Andargor The Wise <andargor@yahoo.com>
Subject: RE: First RAID Setup
Date: Sun, 18 Dec 2005 14:08:31 -0800 (PST)
Message-ID: <20051218220831.77225.qmail@web54606.mail.yahoo.com>
References: <20051217020121.47604.qmail@web54611.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051217020121.47604.qmail@web54611.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Callahan, Tom" <CallahanT@tessco.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yet another thing, someone has suggested that I should
increase the chunk size for my RAID5 from 32 to either
64 or 128.

Is it worth it, considering that the system doesn't
normally run on a heavy load? Mail for a few users,
some read-only database applications, website, etc.
Mostly a development machine.

Would this alleviate the "pauses" during large file
transfers/copies that I have indicated in my previous
post?

I'm asking because backing up ~176 GB, reconfiguring
the RAID, and restoring it properly so the machine
boots (the RAID5 is /) is quite a PITA.

Andargor


--- Andargor The Wise <andargor@yahoo.com> wrote:

> Another question related to my first post in the
> thread.
> 
> I'm currently locally rsync'ing the data I pulled
> off
> my damaged disk to the RAID-5 array from one ssh
> session. However, I notice a pause if I 'ls' on
> another session while a large file is being rsync'ed
> (until it is finished).
> 
> Is this normal? Does the fact that the Asus P5GL-MX
> has 4 SATA ports, but they are marked "master/slave"
> have anything to do with these pauses? I thought 
> 
> I would think that I have plenty of horsepower (P4
> 3.0G), memory and I/O bandwidth to avoid this...
> 
> I am using Slack 10.2, kernel 2.6.14.4 with AHCI
> enabled and SATA in native mode on the three disks.
> 
> Andargor
> 
> 
> --- Andargor The Wise <andargor@yahoo.com> wrote:
> 
> > Ok, I got things up and running, hopefully. A
> > question
> > about LILO, however.
> > 
> > This is my raidtab:
> > 
> > raiddev /dev/md0
> >         raid-level 1
> >         nr-raid-disks 3
> >         nr-spare-disks 0
> >         chunk-size 32
> >         persistent-superblock 1
> >         device /dev/sda1
> >         raid-disk 0
> >         device /dev/sdb1
> >         raid-disk 1
> >         device /dev/sdc1
> >         raid-disk 2
> > 
> > raiddev /dev/md1
> >         raid-level 1
> >         nr-raid-disks 3
> >         nr-spare-disks 0
> >         chunk-size 32
> >         persistent-superblock 1
> >         device /dev/sda2
> >         raid-disk 0
> >         device /dev/sdb2
> >         raid-disk 1
> >         device /dev/sdc2
> >         raid-disk 2
> > 
> > raiddev /dev/md2
> >         raid-level 5
> >         nr-raid-disks 3
> >         nr-spare-disks 0
> >         parity-algorithm left-symmetric
> >         chunk-size 32
> >         persistent-superblock 1
> >         device /dev/sda5
> >         raid-disk 0
> >         device /dev/sdb5
> >         raid-disk 1
> >         device /dev/sdc5
> >         raid-disk 2
> > 
> > And my lilo.conf:
> > 
> > boot=/dev/md0
> > raid-extra-boot=/dev/sda,/dev/sdb,/dev/sdc
> > map=/boot/System.map
> > install=/boot/boot.b
> > message=/boot/boot_message.txt
> > prompt
> > compact
> > lba32
> > timeout=30
> > default=Linux
> > 
> > change-rules
> >   reset
> > vga = normal
> > 
> > image = /boot/bzImage-2.6.14.4
> >   root = /dev/md2
> >   append="idebus=66"
> >   label = Linux
> >   read-only
> > 
> > image = /boot/vmlinuz
> >   root = /dev/md2
> >   append="idebus=66"
> >   label = slack_orig
> >   read-only
> > 
> > When I run LILO, I get:
> > 
> > Warning: COMPACT may conflict with LBA32 on some
> > systems
> > Added Linux *
> > Added slack_orig
> > The boot record of  /dev/md0  has been updated.
> > The boot record of  /dev/sda  has been updated.
> > Warning: /dev/sdb is not on the first disk
> > The boot record of  /dev/sdb  has been updated.
> > Warning: /dev/sdc is not on the first disk
> > The boot record of  /dev/sdc  has been updated.
> > 
> > Are the warnings normal?
> > 
> > Andargor
> > 
> > 
> > 
> > --- "Callahan, Tom" <CallahanT@tessco.com> wrote:
> > 
> > > Sorry, I'm programmed for HA lately. Your plan
> > > sounds good then, I wish you
> > > the best of luck.
> > > 
> > > Tom Callahan
> > > 
> > > -----Original Message-----
> > > From: Andargor The Wise
> > [mailto:andargor@yahoo.com]
> > > Sent: Thursday, December 15, 2005 3:22 PM
> > > To: Callahan, Tom; linux-raid@vger.kernel.org
> > > Subject: RE: First RAID Setup
> > > 
> > > 
> > > 
> > > 
> > > --- "Callahan, Tom" <CallahanT@tessco.com>
> wrote:
> > > 
> > > > I understand the reason for the RAID1
> > devices.....
> > > I
> > > > was asking why you have
> > > > 3 devices in the RAID1 setup? RAID1 is a
> > mirrored
> > > > configuration, requiring
> > > > only 2 disks for operation.
> > > 
> > > Right. Like I indicated, I reviewed this list
> for
> > > suggested configurations and this is what I came
> > up
> > > with as a result.
> > > 
> > > I guess you do only need two disks, since you'll
> > be
> > > able to recover anyway, but it seemed a simpler
> > > config
> > > with identical disk partitions and only a small
> > > amount
> > > of space wasted on one disk.
> > > 
> > > > It is always wise to build in a spare however,
> > > that
> > > > being said about all
> > > > raid levels. In your configuration, if a disk
> > > fails
> > > > in your RAID5, your
> > > > array will go down. RAID5 is usually 3+ disks,
> > > with
> > > > a mirror. So you should
> > > > have 3 disks at minimum, and then a 4th as a
> > > spare.
> > > 
> > > But if I don't mind the machine coming down, I
> > don't
> > > think I need a spare? I just want to be able to
> > rip
> > > out the bad drive, slap in a new one, rebuild,
> and
> > > be
> > > back in business with all my data. I don't need
> > HA.
> > > 
> > > (snip)
> > > > Another gotcha, it's usually better to use
> > entire
> > > > disks, if you can afford
> > > > to, in an MD array. This alleviates growing
> > pains
> > > of
> > > > having to manually
> > > > repartition if you want to grow an exisiting
> > > > filesystem. This may not make
> > > > much sense now, but once you have to do it,
> > you'll
> > > > smack your forehead in
> > > > grief.
> > > 
> > > Yes, I can see that, you instead grow by
> slapping
> 
=== message truncated ===


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
