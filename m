From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: Accidental grow before add
Date: Mon, 27 Sep 2010 05:05:05 -0400
Message-ID: <AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<193703.58642.qm@web51305.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <193703.58642.qm@web51305.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I am more interested to know why it kicked off a reshape that would leave the array in a degraded state without a warning and
> needing a '--force' are you sure there wasn't capacity to 'grow' anyway?

Positive. I had no spare of any kind and mdstat was showing all disks
were in use. Now I've got the new drive in there as a spare, but it
was added after the reshape started and mdadm doesn't seem to be
trying to use it yet. I'm thinking it's going through the original
reshape I kicked off (transforming it from an intact 7 disk RAID 6 to
a degraded 8 disk RAID 6) and then when it gets to the end it will run
another reshape to pick up the new spare. I too am surprised there
wasn't at least a warning if not a confirmation.

> Also, when i first ran my reshape it was incredibly slow from Raid5~6 tho.. it literally took days.

I did a RAID 5 -> RAID 6 conversion the other week and it was also
slower than a normal resizing, but only 2-2.5 times as slow. Adding a
new disk usually takes a bit less than 2 days on this array and that
conversion took closer to 4. However, at the slowest rate I reported
above it would have taken something 11 months - definitely a whole
different ballpark.

At any rate, apparently one of my other drives in the array was
throwing some read errors. Eventually it did something unrecoverable
and was dropped from the array. Once that happened the speed returned
to a more normal level, but I stopped the arrays to run a complete
read test on every drive before continuing. With an already degraded
array, losing that drive killed any failure buffer I had left. I want
to make quite sure all the other drives will finish the reshape
properly before risking it. Then I guess it's just a matter of waiting
3 or 4 days for both reshapes to complete.

Mike
