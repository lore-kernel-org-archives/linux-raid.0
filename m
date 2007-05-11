From: David Greaves <david@dgreaves.com>
Subject: Re: removed disk && md-device
Date: Fri, 11 May 2007 21:50:20 +0100
Message-ID: <4644D70C.2010501@dgreaves.com>
References: <200705091417.09033.bs@q-leap.de>	<20070509131450.GA31985@lapse.madduck.net>	<200705091539.53863.bs@q-leap.de>	<17986.50678.340484.891578@notabene.brown>	<46432D4B.4010302@dgreaves.com> <17987.51381.756955.577977@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17987.51381.756955.577977@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bernd Schubert <bs@q-leap.de>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org
List-Id: linux-raid.ids

[Another repost - DNS/ISP/MX problems didn't seem to make it to any of the lists
or debian bugtrack, sorry cc's]
Sorry, rushed email - it wasn't clear. I think there is something important here
though.

Oh, it may be worth distinguishing between a drive identifier (/dev/sdb) and a
drive slot (md0, slot2).

Neil Brown wrote:
> On Thursday May 10, david@dgreaves.com wrote:
>> Neil Brown wrote:
>>> On Wednesday May 9, bs@q-leap.de wrote:
>>>> Neil Brown <neilb@suse.de> [2007.04.02.0953 +0200]:
>>>>> Hmmm... this is somewhat awkward.  You could argue that udev should be
>>>>> taught to remove the device from the array before removing the device
>>>> >from /dev.  But I'm not convinced that you always want to 'fail' the
>>>>> device.   It is possible in this case that the array is quiescent and
>>>>> you might like to shut it down without registering a device failure...
>>>> Hmm, the the kernel advised hotplug to remove the device from /dev, but you 
>>>> don't want to remove it from md? Do you have an example for that case?
>>> Until there is known to be an inconsistency among the devices in an
>>> array, you don't want to record that there is.
>>>
>>> Suppose I have two USB drives with a mounted but quiescent filesystem
>>> on a raid1 across them.
>>> I pull them both out, one after the other, to take them to my friends
>>> place.
>>>
>>> I plug them both in and find that the array is degraded, because as
>>> soon as I unplugged on, the other was told that it was now the only
>>> one.
>> And, in truth, so it was.
> 
> So what was?
Sorry; so it was, as you said, "the only one".
Once you unplugged drive B, drive A was the only drive in the array. From the OS
perspective.

> It is true that now one drive is "the only one plugged in", but is
> that relevant?
Not immediately - which is why I don't think it's an error or an I/O and hence
doesn't deserve an I/O event count increment.
(which is what I meant by "Who updated the event count though?")

So md should distinguish between "removed" and "removed and out of sync".
(aside : what does 'failed' mean anyway? What does it give you that you don't
know better from event count?)

> Is it true that the one drive is "the only drive in the array"??
> That depends on what you mean by "the array".  If I am moving "the
> array" to another computer, then the one drive still plugged into the
> first computer is not "the only drive in the array" from my
> perspective.
Yes, but I think that's only the same as saying they all have the same UUID -
'human you' doesn't (directly) care/know about the event count match status -
you just want a working array.

> If there is a write request, and it can only be written to one drive
> (because the other is unplugged), then it becomes appropriate to tell
> the still-present drive that it is the only drive in the array.
Ah, now here I think it's relevant to tell the other drive(s) that the unplugged
drive is not only removed - it's failed.
There's a minor error handling optimisation - md could know that a drive was
removed so not even bother writing to it, just mark it failed in the remaining
drives.

>> Who updated the event count though?
> Sorry, not enough words.  I don't know what you are asking.
See below

>>> Not good.  Best to wait for an IO request that actually returns an
>>> errors. 
>> Ah, now would that be a good time to update the event count?
> 
> Yes.  Of course.  It is an event (IO failed).  That makes it a good
> time to update the event count...... am I missing something here?
I think so: a remove event shouldn't update the event count to other drives. A
failed write should (of course).

Well, not 'of course'.
If I do I/O to slot1 and slot2 then the event count goes up.
If slot3 is missing, fails etc etc then why do we tell slots 1+2?
Surely md would just do an event count comparison on assembly?


>> Maybe you should allow drives to be removed even if they aren't faulty or spare?
>> A write to a removed device would mark it faulty in the other devices without
>> waiting for a timeout.
> 
> Maybe, but I'm not sure what the real gain would be.
See below.

>> But joggling a usb stick (similar to your use case) would probably be OK since
>> it would be hot-removed and then hot-added.
> 
> This still needs user-space interaction.
> If the USB layer detects a removal and a re-insert, sdb may well come
> back a something different (sdp?) - though I'm not completely familiar
> with how USB storage works.
Yes, so, assuming my proposal, in the case where you hot remove sdb (not fail)
then hot add sdp (same drive slot different drive identifier, maybe different
usb controller) the on-disk superblock can reliably ensure that the array just
continues (also assuming quiescence)?

> In any case, it should really be a user-space decision what happens
> then.  A hot re-add may well be appropriate, but I wouldn't want to
> have the kernel make that decision.

udev is userspace though - you could have a conservative no-add policy ruleset.


My proposal is simply to allow a hot-remove of a drive without marking it
faulty. This remove event would not update the event counts in other drives.
This allows transient (stupid human in the OP report) drive removal to be
properly communicated via udev to md. You don't end up in the situation of "the
drive formerly known as..."

Just out of interest.
Currently, if I unplug /dev/sdp (which is md0 slot3), wait, plug in a random
non-md usb drive which appears as /dev/sdp, what does md do? Just write to the
new /dev/sdp assuming it's the old one?

David



