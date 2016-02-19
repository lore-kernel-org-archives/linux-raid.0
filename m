From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: Drop sending a change uevent when stopping
Date: Fri, 19 Feb 2016 13:58:43 -0800
Message-ID: <20160219215843.GA30838@kernel.org>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
 <20160217181943.GA28011@kernel.org>
 <871t8brpon.fsf@notabene.neil.brown.name>
 <56C56894.8070906@suse.de>
 <87egc9pqj7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87egc9pqj7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

On Fri, Feb 19, 2016 at 10:06:20AM +1100, Neil Brown wrote:
> On Thu, Feb 18 2016, Hannes Reinecke wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > On 02/17/2016 10:29 PM, NeilBrown wrote:
> >> On Thu, Feb 18 2016, Shaohua Li wrote:
> >> 
> >>> On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian
> >>> Parschauer wrote:
> >>>> When stopping an MD device, then its device node /dev/mdX
> >>>> may still exist afterwards or it is recreated by udev. The
> >>>> next open() call can lead to creation of an inoperable MD
> >>>> device. The reason for this is that a change event
> >>>> (KOBJ_CHANGE) is sent to udev which races against the
> >>>> remove event (KOBJ_REMOVE) from md_free(). So drop sending
> >>>> the change event.
> >>>> 
> >>>> A change is likely also required in mdadm as many versions
> >>>> send the change event to udev as well.
> >>> 
> >>> Makes sense, it's unlikely we need the CHANGE event.
> >>> Applied.
> >>> 
> >>> Thanks, Shaohua
> >> 
> >> It would be worth checking, but I think that with this change,
> >> you can write "inactive" to /sys/block/mdXXX/md/array_state and
> >> the array will become inactive, but no uevent will be
> >> generated, which isn't good. Maybe send the uevent that was
> >> just removed from the 'inactive' case of array_state_store()
> >> instead.
> >> 
> >> (But I still think this is just a bandaid and doesn't provide
> >> any guarantees that there will be no races with udev)
> >> 
> > Thing is, _none_ of the other subsystems will ever send a uevent
> > when it becomes inactive.
> 
> A CDROM drive does when you eject the media.
> 
> 
> > (Would be pretty pointless, too, as what exactly is one supposed
> > to do here?)
> 
> Lazy-unmount the filesystem?
> If the array was part of another array, mark the slot in that array as
> 'faulty' ?
> 
> > The current usage has it that CHANGE events are only ever sent if
> > a device becomes active.
> 
> "mostly" but not "only ever".

Neil,

did you mean I should drop the patch?

I really doubt there is any difference with/without the CHANGE event giving a
REMOVE event will pop up soon. But this could be userspace aware, I'm not
totally sure.

Thanks,
Shaohua
