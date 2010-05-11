From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 21:37:28 -0500
Message-ID: <71.F9.29689.AE2C8EB4@cdptpa-omtalb.mail.rr.com>
References: <4BE7CF2C.8030400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE7CF2C.8030400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >
> > 	GRUB can initially read the /dev/hda1 partition, because it does
> > bring up the GRUB menu, which is on /dev/hdx1.
> >
> > 	If I boot to multiuser mode, I get a complaint about an address
> > space collision of a device.  It then recognizes the /dev/hda1 partition
> as
> > ext2 and starts to load the initrd, but then unceremoniously hangs.
> After a
> > while, it aborts the boot sequence and informs the user it has given up
> > waiting for the root device.  It announces it cannot find /dev/md2 and
> drops
> > to busybox.  Busybox, however, complains about not being able to access
> tty,
> > and the system hangs for good.
> >
> > 	If I boot to single user mode, then when raid1 and raid456 load
> > successfully, but then it complains that none of the arrays are
> assembled.
> > Afterwards, it waits for / to be available, and eventually times out
> with
> > the same errors as the multiuser mode.
> >
> > 	I'm not sure where I should start looking.  I suppose if initrd
> > doesn't have the image of /etc, it might cause md to fail to load the
> > arrays, but it certainly should contain /etc.  What else could be
> causing
> > the failure?  I did happen to notice that under the old kernel, when md
> > first tried, the arrays would not load, but then a bit later in the boot
> > process, they did load.
> >
> > 	Has anyone else come across this problem?  The upgrade is from
> > Debian "Lenny" to "Squeeze".   Where should I start looking?
> 
> Firstly, almost certainly by 2.6.32 your IDE drives will appear as
> /dev/sdx rather than hdx so you may need to build the initrd for 2.6.32
> with a different /etc/mdadm.conf.

	Thanks!  I did not know that.  It's a great place to start.

> When you boot and get the complaint
> about no / can you get a command line you can run mdadm -Evvs from?

	No, the system hangs.  However, I can interrupt the boot at the GRUB
prompt, and I should be able to specify the correct target for /, which will
get me half the way there.

 
> Secondly, the idea of grub1 chain-loading grub2 sounds iffy to me; use
> either grub1 or grub2 but not both.

	It's done that way so that if GRUB2 fails, one can still interrupt
the boot at the GRUB1 prompt and fix things.  Once GRUB2 is running
properly, there is a simple command which eliminates GRUB1 from the boot
procerss and boots directly from GRUB2.

> Hope this gives you some places to look.

	It surely does!  Thanks yet again.  I'm too tired right now to dig
into it, but if indeed hda and hdb are now sda and sdb, I can fix this
pretty easily.  Of course, I have backups, and I could just revert to the
backup image, but then I would be right back where I started.  I'd much
rather get the broken system working with the new kernel and move forward.

