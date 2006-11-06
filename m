From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md
	array starts/stops.
Date: Mon, 6 Nov 2006 11:18:44 +1100
Message-ID: <17742.32612.870346.954568@cse.unsw.edu.au>
References: <20061031164814.4884.patches@notabene>
	<1061031060046.5034@suse.de>
	<20061031211615.GC21597@suse.de>
	<3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>
	<17737.58737.398441.111674@cse.unsw.edu.au>
	<1162475516.7210.32.camel@pim.off.vrfy.org>
	<17738.59486.140951.821033@cse.unsw.edu.au>
	<1162542178.14310.26.camel@pim.off.vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Friday November 3
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 3, kay.sievers@vrfy.org wrote:
> 
> Hmm, why does the open() of device node of a stopped device cause an "add"?
> Shouldn't it just return a failure, instead of creating a device?

Because that is the API I inherited.  To create an MD array, you open
/dev/mdX and issue some IOCTLs.  Originally I think the devices were
all created at boot/module-load time much like they still are for
loop.c.  But when Al Viro did all that work with kmap and blkdev_get
ages ago he changed it so they didn't have to pre-created but rather
were created on-the-fly by an attempt to open the block device (this
calls in to md_probe which does the add_disk).

This creates a deep disconnect between udev and md.
udev expects a device to appear first, then it created the
device-special-file in /dev.
md expect the device-special-file to exist first, and then created the
device on the first open.

> 
> > A bit unfortunate really.  This didn't happen when I had
> > ONLINE/OFFLINE as udev ignored the OFFLINE.
> > I guess I can removed the CHANGE at shutdown, but as there really is a
> > change there, that doesn't seem right.
> 
> Yeah, it's the same problem we had with device-mapper, nobody could
> think of any useful action at a dm-device suspend "change"-event, so we
> didn't add it. :)   
> 

Yes... the device cannot disappear until no-one is using it, so no-one
will be interested in it going away.

> 
> The persistent naming rules for /dev/disk/by-* are causing this. Md
> devices will probably just get their own rules file, which will handle
> this and which can be packaged and installed along with the md tools.
> 
> If it's acceptable for you, so leave the shutdown "change" event out for
> now, until someone has the need for it.

Yes, I'll get rid of the online/offline events and just put in a
CHANGE when the array becomes available.

I'm still a bit concerned about the open->add->open infinite loop.
If anyone opens /dev/mdX while it isn't active (e.g. to check if it is
active), that will (given a patch that I would like to include) cause
and ADD event which will cause udev to start it's loop again.
Can we make udev ignore ADD for md and only watch for CHANGE?

Thanks,
NeilBrown
