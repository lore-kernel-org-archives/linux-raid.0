From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Resize RAID-0?
Date: Thu, 11 Mar 2010 21:17:36 -0800
Message-ID: <4877c76c1003112117q55547296oabfd3925496b33c@mail.gmail.com>
References: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 11, 2010 at 7:39 PM, Patrick J. LoPresti <lopresti@gmail.co=
m> wrote:
> From reading the documentation and source code, I gather "mdadm
> --grow" is not supported for RAID-0 devices.
>
> In my application, I am using md RAID-0 to stripe among several
> (identical) hardware RAID-0 chassis. =A0I would like to extend my set=
up
> by adding another chassis, but apparently, I cannot (?).
>
> The next time I build a system like this, is there any way to get wha=
t
> I want using Linux? =A0That is, striping among devices, no parity, bu=
t
> with the ability to grow in the future?
>
> Thanks!
>
> =A0- Pat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I THINK that LVM may allow you to do that.  I know the newer version
of the labels supports /mixing/ how many stripes are in a given
segment of storage. You may be able to, via some slightly non-trivial
complexity but with existing commands and a little free space, shuffle
your data out of an M device set of storage in to an N device set of
storage striping.

I don't actually see any technical reason why restriping raid0 or
another raid level to any other should be impossible to support. I
just don't believe the feature currently exists, and possibly that the
metadata might need changes to allow for different segments of backing
storage and use within the same md container.  However were it even
possible to store two types then only a small critical window would
need backup, and everything else could sync to the largest portion of
non-overlap.  The worse case would be same size to same size reshape;
a literal nightmare performance wise since the whole set would be a
critical section.  Even reserving a fraction of a megabyte at creation
time would at least allow the operation on /that/ to be done as a
non-critical section.  Alternatively if a write-intent map were in use
it could instead be destroyed and it's space used for the critical
section.  The map might then flop between front and back during
different reshapes or shifts.

I just got done glancing at a few locations (website, documentation,
and kernel code) and didn't see anything like a representation of what
the metablock might look like, so I can't say for sure if looks like I
expect from the behavior.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
