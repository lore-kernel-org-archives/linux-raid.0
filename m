From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md
	array starts/stops.
Date: Fri, 3 Nov 2006 17:57:34 +1100
Message-ID: <17738.59486.140951.821033@cse.unsw.edu.au>
References: <20061031164814.4884.patches@notabene>
	<1061031060046.5034@suse.de>
	<20061031211615.GC21597@suse.de>
	<3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>
	<17737.58737.398441.111674@cse.unsw.edu.au>
	<1162475516.7210.32.camel@pim.off.vrfy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Thursday November 2
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 2, kay.sievers@vrfy.org wrote:
> On Thu, 2006-11-02 at 23:32 +1100, Neil Brown wrote:
> > and I don't remember
> > you suggesting "change", but my memory isn't what it used to be(*), so you
> > probably did.
> 
> It was in the Czech Republic, but we got a few beers... :) And in the
> "virtual md devices" conversation.

Hmm... rings a bell.  I guess I didn't appreciate the important
difference between 'change' and 'online' at the time.  Thanks for
clearing that up.

> 
> We couldn't think of any use of an "offline" event. So we removed the
> event when the device-mapper device is suspended.
> 
> > Should ONLINE and OFFLINE remain and CHANGE be added, or should they
> > go away?
> 
> The current idea is to send only a "change" event if something happens
> that makes it necessary for udev to reinvestigate the device, like
> possible filesystem content that creates /dev/disk/by-* links.
> 
> Finer grained device-monitoring is likely better placed by using the
> poll() infrastructure for a sysfs file, instead of sending pretty
> expensive uevents. 
> 
> Udev only hooks into "change" and revalidates all current symlinks for
> the device. Udev can run programs on "online", but currently, it will
> not update any /dev/disk/by-* link, if the device changes its content.
> 

OK.  Makes sense.
I tried it an got an interesting result....

This is with md generating 'CHANGE' events when an array goes on-line
and when it goes off line, and also with another patch which causes md
devices to disappear when not active so that we get ADD and REMOVE
events at reasonably appropriate times.

It all works fine until I stop an array.
We get a CHANGE event and then a REMOVE event.
And then a seemingly infinite series of ADD/REMOVE pairs.

I guess that udev sees the CHANGE and so opens the device to see what
is there.  By that time the device has disappeared so the open causes
an ADD.  udev doesn't find anything and closes the device which causes
it to disappear and we get a REMOVE.
Now udev sees that ADD and so opens the device again to see what it
there, triggering an ADD.  Nothing is there so we close it and get a
REMOVE.
Now udev sees the second ADD and ....

A bit unfortunate really.  This didn't happen when I had
ONLINE/OFFLINE as udev ignored the OFFLINE.
I guess I can removed the CHANGE at shutdown, but as there really is a
change there, that doesn't seem right.

The real problem is that udev opens the device, and md interprets and
'open' as a request to create the device. And udev see the open and an
ADD and so opens the device....

It's not clear to me what the 'right' thing to do here is:
 - I could stop removing the device on last-close, but I still
   think that (the current situation) is ugly.
 - I could delay the remove until udev will have stopped poking,
   but that is even more ugly
 - udev could avoid opening md devices until it has poked in 
   /sys/block/mdX to see what the status is, but that is very specific
   to md

It would be nice if I could delay the add until later, but that would
require major surgery and probably break the model badly.

On the whole, it seems that udev was designed without thought to the
special needs of md, and md was designed (long ago) without thought
the ugliness that "open creates a device" causes.

Any clever ideas anyone?


NeilBrown
