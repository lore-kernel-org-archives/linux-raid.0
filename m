From: David Brown <david@westcontrol.com>
Subject: Re: A few questions regarding RAID5/RAID6 recovery
Date: Tue, 26 Apr 2011 09:21:53 +0200
Message-ID: <ip5rnd$g96$1@dough.gmane.org>
References: <002001cc0370$cd40ac90$67c205b0$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002001cc0370$cd40ac90$67c205b0$@priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/04/2011 19:47, K=C5=91v=C3=A1ri P=C3=A9ter wrote:
> Hi all,
>
> Since this is my first post here, let me first thank all developers
> for their great tool. It really is a wonderfull piece of soft. ;)
>
> I heard a lot of horror stories about the event, when a member of a
> raid5/6 array gets kicked off due to I/O errors, and then, after the
> replacement and during the recostruction, another drive fails, and
> the array become unusable. (For raid6, add another drive to the
> story, and the problem is the same, so let=E2=80=99s just talk about =
raid5
> now). I want to prepare myself for this kind of unlucky event, and
> build up a strategy that I can follow once it happens. (I hope never,
> but...)
>
> Let=E2=80=99s assume we have a 4 drives RAID5, that has been degraded=
, the
> failed drive has been replaced, then the rebuild process failed, and
> now we have an array with 2 good disks, one failed disk and one which
> is partially synchronized (the new one). And, we also have the disk
> out of the array, which was originally failed. If I assume, that both
> of the failed disks have some bad sectors but otherwise both are in
> an operative condition (can be dd-ed for example), then, except the
> unlikely event, when both disks have failed on the very same physical
> sector (chunk?), then theoretically the data is there and could be
> retrieved. So my question is, can we retrieve them by using mdadm and
> some =E2=80=9Etricks=E2=80=9D? I think of something like this:
>
> 1. I assemble (or --create --assume-clean) the array in degraded mode
> using the 2 good drives, and one of the 2 failed drives which has
> it's bad sectors behind the point than the other failed drive. 2. Add
> the new drive, let the array start rebuilding, and wait for the
> process go beyond the point where the other failed drive has it's bad
> sectors. 3. Stop/pause/??? the rebuild process. And - if possible -
> make a note of the exact sector (chunk) where the rebuild has been
> paused. 4. Assemble (or --create --assume-clean) the array again, but
> this time using the other failed drive, 5. Add the new drive again,
> and continue to rebuild from the point where the last rebuild has
> been paused. Since we are over the point where the failed disk has
> it's bad sectors, the rebuild should finish fine. 6. Finally remove
> the failed disk and replace it with another new drive.
>
> Can this be done using mdadm somehow?
>
> My next question is not really a question but rather a wish. In my
> point of view, the above written situation is by far the biggest
> weekness of not just linux software raid but all other harware raid
> solutions that i know of (don't know many, though). Even nowadays,
> when we use larger and largers disks. So i'm wondering if there is
> any raid or raid-kind solution that - along with redundancy, -
> provides some automatic stipe (chunk) reallocation feature? Something
> like modern hard disks do with their "reallocated sectors", something
> like: the raid driver reserves some chunks/stripes for
> "reallocation", and once an I/O error happens on any of the
> active/working chunks, then instead of kicking the disk off, it marks
> the stripe/chunk bad, and moves the data to one of the reserved ones,
> and continues (along with some warning of course). Only, if writing
> to the reserved chunk fails, would be necessary to immediately kick
> the member off.
>
> The other thing I wonder is why raid solutions (that i know of) use
> the "first remove the failed, then add the new" strategy instead of
> "add the new, I try to recover, then remove the failed" strategy.
> They use the former even when a spare drive is available, because -as
> far as i know - they won't utilize the failed disk for rebuild. Why?
> By using the latter strategy, it would be a joy to recover from
> situations like above.
>
> Thanks for your response.
>
> Best regards, Peter
>

You are not alone in these concerns.  A couple of months ago there was =
a=20
long thread here about a roadmap for md raid.  The first two entries ar=
e=20
a "bad block log" to allow reading of good blocks from a failing disk,=20
and "hot replace" to sync a replacement disk before removing the failin=
g=20
one.  Being on a roadmap doesn't mean that these features will make it=20
to md raid in the near future - but it does mean that there are already=
=20
rough plans to solve these problems.

<http://neil.brown.name/blog/20110216044002>



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
