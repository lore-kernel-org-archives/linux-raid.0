From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 007 of 7] md: Get name for block device in sysfs
Date: Mon, 17 Dec 2007 03:10:14 +0100
Message-ID: <1197857414.2585.16.camel@lov.site>
References: <20071214171950.1308.patches@notabene>
	 <1071214062647.1928@suse.de>
	 <3ae72650712150858v14681823td2b0410eb67b1d04@mail.gmail.com>
	 <18277.43533.991986.323212@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18277.43533.991986.323212@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Greg KH <greg@kroah.com>
List-Id: linux-raid.ids

On Mon, 2007-12-17 at 09:43 +1100, Neil Brown wrote:
> On Saturday December 15, kay.sievers@vrfy.org wrote:
> > On Dec 14, 2007 7:26 AM, NeilBrown <neilb@suse.de> wrote:
> > >
> > > Given an fd on a block device, returns a string like
> > >
> > >         /block/sda/sda1
> > >
> > > which can be used to find related information in /sys.
> ....
> > 
> > As pointed out to when you came up with the idea, we can't do this. A devpath
> > is a path to the device and will not necessarily start with "/block" for block
> > devices. It may start with "/devices" and can be much longer than
> > BDEVNAME_SIZE*2  + 10.
> 
> When you say "will not necessarily" can I take that to mean that it
> currently does, but it might (will) change??

It's in -mm. The devpath for all block devices, like for all other
devices, will start with /devices/* if !SYSFS_DEPRECATED.

> In that case can we have the patch as it stands and when the path to
> block devices in /sys changes, the ioctl can be changed at the same
> time to match?

No, you have to use kobject_get_path() to get the path to the object.
This will also handle devices where the name contains '/' which needs to
be translated to '!', which is broken in this patch.

> Or are you saying that as the kernel is today, some block devices
> appear under /devices/..., in which case could you please give an
> example?

We expect the next kernel to have it.

Btw: BLKGETNAME should probably be renamed to something which contains
DEVPATH, to make clear that it's a path to, and not the name of the
device.

Kay

