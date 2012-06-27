From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Wed, 27 Jun 2012 21:19:31 +0200
Message-ID: <20120627211931.466b83ca@hoferr-x61s.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org>
	<js1vuk$9k8$2@dough.gmane.org>
	<4FE5B213.5010503@hardwarefreak.com>
	<js70ce$fgv$1@dough.gmane.org>
	<4FE72053.4040101@hardwarefreak.com>
	<4FE7E044.6040506@hardwarefreak.com>
	<js9emr$761$1@dough.gmane.org>
	<4FE91619.4020709@hardwarefreak.com>
	<1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	<4FEA1A4F.9090605@hardwarefreak.com>
	<1340788044.3420.8.camel@hoferr-desktop.hofer.rummelring>
	<4FEAFDC5.7030205@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEAFDC5.7030205@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jun 2012 07:34:13 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> > With a disk size of 2 TB thid should take about 6 hours?
> 
> Yeah, something like that.
> 
> > I think I'll let it run again this evening so that it can complete
> > until the next day.
> 
> Do them one at a time this time, starting with /dev/sdk.  Remember to
> issue sync.  E.g.
> 
> ~$ dd if=/dev/zero of=/dev/sdk bs=16384; sync
> 
> Try a smaller block size this time, 16KB instead of 1M.

Ok, thanks I will. And additionally I will write down what time I
started each command so when one of them still hasn't finished after 12
hours or so the disk will have to be replaced right?


> Oh, Ramon, before you do any of this, change to the deadline elevator:
> 
> ~$ echo deadline > /sys/block/sdk/queue/scheduler
> 
> Dangit, Ramon, I can't believe I forgot to tell you this when you
> installed the 9240.  Debian, like most distros, defaults to the CFQ
> elevator, which is good, I guess, for interactive desktop use.  But it
> sucks like a Hoover with most server workloads.  So add this to your
> kernel boot options in grub's menu.list, normally found in
> /boot/grub/menu.lst:
> 
> elevator=deadline
> 
> That will enable deadline each time you boot.  So after you make the
> change go ahead and reboot the system.  Then proceed with your dd
> commands.

Very interesting!!!
Thanks for that :-)

Btw: I use grub2. The file I edited is /etc/default/grub. I changed
this line:

GRUB_CMDLINE_LINUX_DEFAULT="quiet elevator=deadline"

and ran
~# update-grub

I checked if the right scheduler is running:

~$ cat /sys/block/sdk/queue/scheduler
noop [deadline] cfq 

Is this correct what I did?


> >> So at this point you can try creating the RAID5 array again.  If
> >> the dd command did what we wanted, /dev/sdk should have remapped
> >> the bad sector, and you shouldn't get the error kicking that
> >> drive.  If you still do, you may need to replace the drive.
> > 
> > I'm not sure if I didn't kille the dd command too early.
> > Maybe it's better to let it run again. Maybe even each disk at once?
> > Maybe this would already tell if a disk is faulty?
> 
> Yeah, do em one at a time this time.  It'll cause less load, and you
> should still be able to watch movies etc while it runs.

And I can see if one of them behaves strangely :-)


Cheers
Ramon
