From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: Drop sending a change uevent when stopping
Date: Wed, 17 Feb 2016 14:14:01 -0800
Message-ID: <20160217221401.GA30809@kernel.org>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
 <20160217181943.GA28011@kernel.org>
 <871t8brpon.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871t8brpon.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Hannes Reinecke <hare@suse.de>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

On Thu, Feb 18, 2016 at 08:29:28AM +1100, Neil Brown wrote:
> On Thu, Feb 18 2016, Shaohua Li wrote:
> 
> > On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian Parschauer wrote:
> >> When stopping an MD device, then its device node /dev/mdX may still
> >> exist afterwards or it is recreated by udev. The next open() call
> >> can lead to creation of an inoperable MD device. The reason for
> >> this is that a change event (KOBJ_CHANGE) is sent to udev which
> >> races against the remove event (KOBJ_REMOVE) from md_free().
> >> So drop sending the change event.
> >> 
> >> A change is likely also required in mdadm as many versions send the
> >> change event to udev as well.
> >
> > Makes sense, it's unlikely we need the CHANGE event. Applied.
> >
> > Thanks,
> > Shaohua
> 
> It would be worth checking, but I think that with this change, you can
> write
>   "inactive" to /sys/block/mdXXX/md/array_state
> and the array will become inactive, but no uevent will be generated,
> which isn't good.
> Maybe send the uevent that was just removed from the 'inactive' case of
> array_state_store() instead.

with 'inactive', the mode == 2, do_md_stop() doesn't send the event either, so
the behavior isn't changed.

> (But I still think this is just a bandaid and doesn't provide any
> guarantees that there will be no races with udev)

that's correct. I'd expect races in other CHNAGE/REMOVE cases are very rare.

Thanks,
Shaohua
