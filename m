From: Pradeep <pradeepjp@yahoo.com>
Subject: Re: mdadm -A erased the superblock ?
Date: Sat, 22 Mar 2008 09:53:38 -0700 (PDT)
Message-ID: <4510.66972.qm@web32801.mail.mud.yahoo.com>
References: <40829.192.168.1.70.1206129490.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40829.192.168.1.70.1206129490.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Where there any kernel message (view with 'dmesg') at this time?

Mar 21 00:27:45 brahma kernel: md: invalid raid superblock magic on sdd
Mar 21 00:27:45 brahma kernel: md: sdd does not have a valid v0.90 superblock, not
importing!
Mar 21 00:27:45 brahma kernel: md: md_import_device returned -22



    What is much more interesting, is that I rebooted the machine, and 'mdadm --examine'
started working again (producing output).
I then retried the 'mdadm -A' command and that went through as well.

I did not run any other command that could have written anything to the hard disk.

This is an x86_64 machine - Linux brahma.skynet.xc 2.6.23.15-137.fc8 #1 SMP Sun Feb 10
17:03:13 EST 2008 x86_64 x86_64 x86_64 GNU/Linux
I cannot recall if the raid set was originally created on a 32 or a 64 bit O.S.

Is there any other diagnostic I can try ?
regards,
-pradeep.


--- NeilBrown <neilb@suse.de> wrote:

> On Fri, March 21, 2008 7:26 am, Pradeep wrote:
> > Hi,
> >     It appears that a 'mdadm -A' command erased the superblocks on my
> > disks.
> > Could you please take a look and let me know if I did something wrong ?
> >
> > (I was adding 2 disks that were in a raid 1 set to a new machine running
> > fedora 8.)
> > Briefly, I issued an 'mdadm --examine /dev/sdd1' command to check the
> > disks in my raid 1
> > array.
> > (repeat similar command for /dev/sde1)
> >
> > Then I issued 'mdadm -A -v -u '400f8c5f:045827ea:f72fe561:698ccea2'
> > /dev/md0'
> > which errored out because it was looking at /dev/sdd instead of /dev/sdd1
> >
> 
> This isn't why it errored out.  It looked at sdd and found nothing there.
> It also looked at various other devices and found nothing usable there.
> That is perfectly normal.
> 
> What is strange is that it found sdd1 and sde1 in /proc/partitions,
> but couldn't find names for them in /dev, so it reports them as
> 8:65 and 8:49
> 
> However when you ran the "--examine", it did find /dev/sdd1 in
> /dev with the correct major/minor numbers.  So something must
> have happened between those two commands.
> 
> Also, I cannot think why it is reporting "Invalid argument" and
> failing to add the devices to the array.
> Where there any kernel message (view with 'dmesg') at this time?
> 
> NeilBrown
> 
> 
> 
> 



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
