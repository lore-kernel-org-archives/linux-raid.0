From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 11:43:46 +1100
Message-ID: <18694.24642.729914.620038@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
	<18694.19834.523955.697048@notabene.brown>
	<ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Tuesday October 28
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Tuesday October 28, kay.sievers@vrfy.org wrote:
> > But in different places.
> > Debian has /etc/udev/rules
> > openSUSE has /lib/udev/rules
> >
> > I love standards.  There are so many to choose from. :-)
> 
> They are all valid and needed. You should install in
> /lib/udev/rules.d/ if the rule is not supposed to be edited by the
> user.

Clearer now.  Thanks.

> > I notice that 'md'
> > devices don't seem to disappear.  Maybe that is because /sys/block/mdX
> > never disappears (last time I tried it was too racy).
> 
> It stays because the md kernel device lifetime rules are kind of
> broken regarding hotplug setups. Similar issue why md needs all the
> static nodes in /dev too to create a device.
> 
> > Would there be any way to get udev to delete devices when
> >  /sys/block/mdX/md/array_state
> > becomes 'clear' (presumably on a CHANGE event) ??
> 
> What would be the reason to leave the kernel block device around?
> Can't you just remove it like any other subsytem in the kernel does.
> That would just remove the node, all links and update userspace to
> reflect the change.

I tried some time ago.  It was hard.

md devices magic appear when you tried to open the device-special
file.  I need some sort of locking to prevent that creation while I'm
destroying the old device.  But when I was trying this (quite some
months ago) the locking around do_open was fairly difficult to
follow.  I don't remember the exact issues, but I gave up.

What would happen was that when the md device disappear, udev would
try to open it (I think) and make it reappear again.  Sometimes with
an oops.  I think I avoided some of that by sending the DELETE event
well before the device was actually deleted ... or something.  But it
was still far from perfect.

Maybe I should try again.


> 
> There is currently no "change" event that could tell to remove a
> device node in /dev while we still have a kernel device around. And
> you would need to convince me that this is really needed, and why md
> is so special here. :)

md is a bit 'special', but not quite unique.  I think 'loop' now works
the same way as md in terms of devices magically appearing on open.
Maybe I can see how it was made to work for that case.


Thanks Kay,

NeilBrown
