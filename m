From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Wed, 8 Apr 2009 16:38:03 +1000
Message-ID: <18908.17995.353779.708803@notabene.brown>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
	<87tz51dmmu.fsf@frosties.localdomain>
	<FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com>
	<155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
	<029B34A7-B30F-4BCC-A485-530EAC76C059@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Tuesday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 7, dledford@redhat.com wrote:
> On Apr 7, 2009, at 5:26 PM, NeilBrown wrote:
> > On Tue, April 7, 2009 10:16 pm, Doug Ledford wrote:
> >> On Apr 7, 2009, at 2:05 AM, Goswin von Brederlow wrote:
> >>> Doug Ledford <dledford@redhat.com> writes:
> >>>
> >>>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
> >>>> temporary mappings of incrementally added devices to device names.
> >>>> Unfortunately, this breaks incremental assembly if used early in  
> >>>> the
> >>>> booting process.  Specifically, root may still be read only.  Since
> >>>> incremental assembly is largely a udev specific feature, and udev
> >>>> needs a writable /dev tmpfs mount even when root is still read  
> >>>> only,
> >>>> it's safer to put our mdadm.map file in /dev/md so that we can  
> >>>> write
> >>>> to the map file no matter how early in the boot process we are
> >>>> attempting to use incremental assembly.
> >>>
> >>> What about /lib/init/rw?
> >>
> >> Never heard of it.  But, if / is read-only, why wouldn't that also be
> >> read-only?
> >
> > because a tmpfs was mounted there.  It's probably a Debian-specific
> > thing.
> >
> > Why /var/run cannot be mounted from tmpfs nice and early too I don't  
> > know..
> > I understand that some people think /var/run needs to persist across
> > reboots to preserve ownership of directories, but they are wrong :-)
> > /var/run should be a tmpfs mount point very early.
> 
> I disagree.  At least in our case, the reason that /var/run is a real  
> directory is not to preserve ownerships (although it does do that as  
> well), but to preserve security context for SELinux.

Ahhh... well SELinux and I have never seen eye-to-eye either :-)

> 
> > I have to say that putting the map file in /dev feels very icky
> > to me.  It isn't a device, and so doesn't belong in /dev.
> > If we go around putting things somewhere convenient rather than
> > where they belong, we quickly end up with a mess.
> 
> If that's the case, then all of udev's library data in /dev/.udev  
> doesn't belong there either.  And as much as this may not be a device,  
> it is in fact device specific in that it maps one device to another.   
> It really is right along the lines of the data udev stores in .udev,  
> so I don't see the ickyness.

You don't think that /dev/.udev is icky?

> 
> > So while it might be very pragmatic, I am currently dis-inclined
> > to take the patch.   Can you try asking your boot-script people
> > to make /var/run be an early tmpfs ???
> 
> I'm betting that this stands 0 chance for F11 anyway, and I'm betting  
> it would be a rather long, uphill fight to get them to agree to this  
> period.

And thus are poor design decisions entrenched :-(
Of course, figuring out exactly which design decision was the poor one
would not be an easy task.

NeilBrown
