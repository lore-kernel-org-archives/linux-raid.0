From: Neil Brown <neilb@suse.de>
Subject: Re: removed disk && md-device
Date: Fri, 11 May 2007 11:36:53 +1000
Message-ID: <17987.51381.756955.577977@notabene.brown>
References: <200705091417.09033.bs@q-leap.de>
	<20070509131450.GA31985@lapse.madduck.net>
	<200705091539.53863.bs@q-leap.de>
	<17986.50678.340484.891578@notabene.brown>
	<46432D4B.4010302@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Thursday May 10
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Bernd Schubert <bs@q-leap.de>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org
List-Id: linux-raid.ids

On Thursday May 10, david@dgreaves.com wrote:
> Neil Brown wrote:
> > On Wednesday May 9, bs@q-leap.de wrote:
> >> Neil Brown <neilb@suse.de> [2007.04.02.0953 +0200]:
> >>> Hmmm... this is somewhat awkward.  You could argue that udev should be
> >>> taught to remove the device from the array before removing the device
> >> >from /dev.  But I'm not convinced that you always want to 'fail' the
> >>> device.   It is possible in this case that the array is quiescent and
> >>> you might like to shut it down without registering a device failure...
> >> Hmm, the the kernel advised hotplug to remove the device from /dev, but you 
> >> don't want to remove it from md? Do you have an example for that case?
> > 
> > Until there is known to be an inconsistency among the devices in an
> > array, you don't want to record that there is.
> > 
> > Suppose I have two USB drives with a mounted but quiescent filesystem
> > on a raid1 across them.
> > I pull them both out, one after the other, to take them to my friends
> > place.
> > 
> > I plug them both in and find that the array is degraded, because as
> > soon as I unplugged on, the other was told that it was now the only
> > one.
> And, in truth, so it was.

So what was?
It is true that now one drive is "the only one plugged in", but is
that relevant?
Is it true that the one drive is "the only drive in the array"??
That depends on what you mean by "the array".  If I am moving "the
array" to another computer, then the one drive still plugged into the
first computer is not "the only drive in the array" from my
perspective.

If there is a write request, and it can only be written to one drive
(because the other is unplugged), then it becomes appropriate to tell
the still-present drive that it is the only drive in the array.

> 
> Who updated the event count though?

Sorry, not enough words.  I don't know what you are asking.

> 
> > Not good.  Best to wait for an IO request that actually returns an
> > errors. 
> Ah, now would that be a good time to update the event count?

Yes.  Of course.  It is an event (IO failed).  That makes it a good
time to update the event count...... am I missing something here?

> 
> 
> Maybe you should allow drives to be removed even if they aren't faulty or spare?
> A write to a removed device would mark it faulty in the other devices without
> waiting for a timeout.

Maybe, but I'm not sure what the real gain would be.

> 
> But joggling a usb stick (similar to your use case) would probably be OK since
> it would be hot-removed and then hot-added.

This still needs user-space interaction.
If the USB layer detects a removal and a re-insert, sdb may well come
back a something different (sdp?) - though I'm not completely familiar
with how USB storage works.

In any case, it should really be a user-space decision what happens
then.  A hot re-add may well be appropriate, but I wouldn't want to
have the kernel make that decision.

NeilBrown

