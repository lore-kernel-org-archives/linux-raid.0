From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: Drop sending a change uevent when stopping
Date: Wed, 17 Feb 2016 10:19:43 -0800
Message-ID: <20160217181943.GA28011@kernel.org>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, Hannes Reinecke <hare@suse.de>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian Parschauer wrote:
> When stopping an MD device, then its device node /dev/mdX may still
> exist afterwards or it is recreated by udev. The next open() call
> can lead to creation of an inoperable MD device. The reason for
> this is that a change event (KOBJ_CHANGE) is sent to udev which
> races against the remove event (KOBJ_REMOVE) from md_free().
> So drop sending the change event.
> 
> A change is likely also required in mdadm as many versions send the
> change event to udev as well.

Makes sense, it's unlikely we need the CHANGE event. Applied.

Thanks,
Shaohua
