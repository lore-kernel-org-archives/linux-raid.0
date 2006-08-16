From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 12:00:02 +0200
Message-ID: <62b0912f0608160300g58bef34cj87300b32a83b17f0@mail.gmail.com>
References: <200608160906.k7G96A204753@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200608160906.k7G96A204753@inv.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> 1) I would like raid request retries to be done with exponential
>    delays, so that we get a chance to overcome network brownouts.
>
> I presume the former will either not be objectionable

You want to hurt performance for every single MD user out there, just
because things doesn't work optimally under enbd, which is after all a
rather rare use case compared to using MD on top of real disks.

Uuuuh..  yeah, no objections there.

Besides, it seems a rather pointless exercise to try and hide the fact
from MD that the device is gone, since it *is* in fact missing.  Seems
wrong at the least.

> 2) I would like some channel of communication to be available
>    with raid that devices can use to say that they are
>    OK and would they please be reinserted in the array.
>
> The latter is the RFC thing

It would be reasonable for MD to know the difference between
 - "device has (temporarily, perhaps) gone missing" and
 - "device has physical errors when reading/writing blocks",

because if MD knew that, then it would be trivial to automatically
hot-add the missing device once available again.  Whereas the faulty
one would need the administrator to get off his couch.

This would help in other areas too, like when a disk controller dies,
or a cable comes (completely) loose.

Even if the IDE drivers are not mature enough to tell us which kind of
error it is, MD could still implement such a feature just to help
enbd.

I don't think a comm-channel is the right answer, though.

I think the type=(missing/faulty) information should be embedded in
the I/O error message from the block layer (enbd in your case)
instead, to avoid race conditions and allow MD to take good decisions
as early as possible.


The comm channel and "hey, I'm OK" message you propose doesn't seem
that different from just hot-adding the disks from a shell script
using 'mdadm'.


> When the device felt good (or ill) it notified the raid arrays it
> knew it was in via another ioctl (really just hot-add or hot-remove),
> and the raid layer would do the appropriate catchup (or start
> bitmapping for it).

No point in bitmapping.  Since with the network down and all the
devices underlying the RAID missing, there's nowhere to store data.
Right?
Some more factual data about your setup would maybe be good..


> all I can do is make the enbd device block on network timeouts.
> But that's totally unsatisfactory, since real network outages then
> cause permanent blocks on anything touching a file system
> mounted remotely.  People don't like that.

If it's just this that you want to fix, you could write a DM module
which returns I/O error if the request to the underlying device takes
more than 10 seconds.

Layer that module on top of the RAID, and make your enbd device block
on network timeouts.

Now the RAID array doesn't see missing disks on network outages, and
users get near-instant errors when the array isn't responsive due to a
network outage.
