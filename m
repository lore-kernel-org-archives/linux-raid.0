From: Neil Brown <neilb@suse.de>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 13 Nov 2009 13:02:32 +1100
Message-ID: <19196.48696.365294.105376@notabene.brown>
References: <nfbrown@novell.com>
	<200911121751.nACHpMrQ011365@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from greg@enjellic.com on Thursday November 12
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 12, greg@enjellic.com wrote:
> On Nov 10,  7:22am, "Neil F Brown" wrote:
> } Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
> 
> Good morning to everyone, hope the week is progressing well.
> 
> > On Tue, November 10, 2009 1:39 am, Doug Ledford wrote:
> > > On 11/06/2009 01:45 AM, Neil Brown wrote:
> > >>
> > >> Greetings.
> > >>
> > >>  About a week ago I released mdadm-3.1
> > >>  I have now 'withdrawn' it meaning that it doesn't appear on the
> > >>  kernel.org mirrors any more, and I ask people not to use it.
> > >
> > > Although the cause for this sucks, I was actually going to suggest that
> > > since 3.1 is a version bump, that we take the opportunity to change a
> > > few defaults.  Like switching to version 1 superblocks instead of
> > > version 0 by default.  And changing the default chunk size to 512k
> > > instead of 64k.  The time has simply come for the 0->1 superblock
> > > change, and I have a good deal of data showing that for SATA disks at
> > > least, the 512k chunk size is the typical sweet  spot.
> 
> > I had been toying with that idea myself - certainly of changing the
> > defaults soon.  I'm tempted to make the default metadata "1.1"
> > though possibly not for RAID1.  For RAID0,4,5,6,10 there is no value
> > in having the metadata at the end of the device.  For RAID1 there is
> > as it makes booting off any member easier.  Thoughts?
> 
> It may be heresy but I would suggest that if the defaults change we
> should also implement support for auto-starting version 1.x devices,
> or some appropriate subset of them.

Yep, definite heresy. :-)

> 
> I understand and appreciate the concerns of the userspace start
> community.  However, we do a lot of storage on very dedicated systems
> and I have spent far more time unsnarling systems with blown
> initrd/initramfs setups and other boot issues than I have recovering
> from starting RAID volumes on the wrong box.  Thats why I don't let
> udev anywhere near production machines and I am still living on 0.9
> metadata in spite of its limitations.

You don't need udev for user-space md startup.  You do need initramfs,
but I think you need that for lots of things these days.  It doesn't
need to be a very complicated initramfs.

> 
> UNIX has always been about allowing people to shoot themselves in the
> foot if they so desire.  I think an acceptable compromise would be to
> move toward a default of disabled auto-detection with the option to
> turn on detection of all meta-data types if people choose to do that.
> 

You have the source code and you are quite welcome to shoot yourself
in whichever limb you please with it.
in-kernel autostart of v1.x arrays could probably be implemented
without too much difficulty.  I am not likely to do it though.
If someone sent me nice patches which enabled it as a CONFIG option I
might accept them, providing a good justification was included.

But I don't think it is a good idea.
If you really really want to avoid an initramfs, then just use a 0.90
array for the device holding the root filesystem.  Everything other
than root can be started by init scripts.  Or do you want to avoid
init scripts too because they are too easy to get wrong :-)

> > NeilBrown
> 
> Best wishes for a pleasant weekend to everyone.
> 
Thank you, and the same to you!

NeilBrown
