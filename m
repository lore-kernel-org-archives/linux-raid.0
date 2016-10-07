From: Phil Turmel <philip@turmel.org>
Subject: Re: Why not just return an error?
Date: Fri, 7 Oct 2016 10:19:15 -0400
Message-ID: <45c5f179-1a9e-1440-be44-215ddc87781f@turmel.org>
References: <57F6DF18.40703@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57F6DF18.40703@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2016 07:32 PM, Dark Penguin wrote:
> Greetings!
> 
> The more I read about md-raid, the more I notice that the biggest
> problem of it: if you hit an error on a degraded RAID, it falls apart.
> Because of this, it is possible to lose a huge amount of data due to one
> tiny read error, which particularly makes raid5 the sword of Damocles.

Because raid is about uptime through failures.  It's not backup, it's
not data consistency.  A degraded array is supposed to be a temporary
state -- the time it takes to install a new drive and rebuild.  A
single-degraded raid6 still has redundancy to carry you through a read
error during rebuild.  Raid5 does not.  That's it.  There's no other
magic, and anything else would be more bug-inducing complexity.

A degraded raid5 isn't raid anymore, just "aid".  You can minimize the
odds of a read error during rebuild by properly scrubbing your arrays
while they are non-degraded, but drive specifications make it clear that
your odds won't be good on large arrays.

> But one question keeps me increasingly frustrated. Yes, during its
> normal functioning, it totally makes sense to kick a faulty device out
> of an array.

{ Possible misconception here: linux raid arrays don't kick out drives
just for read errors.  MD raid will attempt to *fix* the bad sector
using the data from the other drives.  Only if the fix fails will the
drive be ejected.  Timeout mismatch guarantees that the fix will fail. }

> But if we're running a degraded array, and doing so will
> definitely result is massive data loss, why not just return a read error
> instead? Just add a little check: on error, if degraded -> then just
> return an error. I believe this is the dream of everyone who had ever
> dealt with RAIDs.

Stopping the array *preserves* data.  The block layer has no concept of
what's on top, and an error in one place that isn't handled could easily
turn into corruption in otherwise good places.  Layered block devices
require a sysadmin to evaluate the situation.

> With RAID, the first proprity is keeping data safe. Yes, it's not an
> alternative to backups and all that, but still - if we hit an error on a
> degraded array, the array should scream and panic and send all kinds of
> warnings, but definitely NOT collapse and warrant a visit to the RAID
> recovery laboratory (or this mailing list). Imagine how much headache
> and lost hair would that relieve!..

Linux raid is widely used.  Traffic on this list is relatively small.
I'm quite sure 99.99% of linux raid users are dealing with these events
just fine:  ddrescue the troublesome drive to another, reassemble with
that, then wipe or replace the original.  Whine to the powers that be
that raid6 would have kept their array up through the event so could
they please fund another drive?  Drown sorrows in beer if the PTB say no.

> Now, I'm probably not the first one to think of such a bright idea. So
> there must be a very good reason why this is not possible; I don't think
> the problem is just that "the existing behaviour is preferred, and
> anyone who does not agree is an idiot". If not for enterprise use, then
> at least it would be very useful for the "home archive" scenario when
> "uptime" and "absense of errors" hold much less meaning than "losing one
> file and not all the data". So, why is this not possible?..

No, you aren't the first to want a magic wand.  Sorry.

Phil
