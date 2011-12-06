From: Phil Turmel <philip@turmel.org>
Subject: Re: need a little help rebuilding a raid 10
Date: Tue, 06 Dec 2011 09:52:11 -0500
Message-ID: <4EDE2C1B.8000008@turmel.org>
References: <CAGpXXZKdbs+Y3qNHnVmFGB3sKE5R7viRajrVM+udUqoDgsA0yg@mail.gmail.com> <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGpXXZKWB7qpRtWK7GuohuF-OOuAGQ_tSODCnLCouS+Z-SWZDA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Greg,

On 12/06/2011 09:11 AM, Greg Freemyer wrote:
> Hmm...
> 
> My rebuild failed.  At first glance I had both a failed drive and a failed slot?
> 
> What I don't understand is I have I/O errors in /var/log/messages from
> when the rebuild failed over night.

Something in your system is untrustworthy.

> But this morning, hdparm --read-sector is reading the "bad" sectors fine.

What does smartctl say about your drives (all of them)?

> I already tried replacing the drive and the replacement drive also
> reported media errors during the rebuild, that's why I came to believe
> I had a bad slot.
> 
> Now I have non-repeatable media errors.
> 
> fyi: I have the problem drive connected via eSata now, so it's a
> different controller totally than where it was when the failure first
> occurred.

Are the errors in /var/log/messages only from that drive?  If so, then that
drive is probably toast.

> Any thoughts?

Your prior e-mail said that you re-created the array.  I didn't see that you
had definitively nailed down the problem at that point, so it probably wasn't
a good idea.  In particular, it destroys all prior metadata on the array
members.  If you didn't keep the output of "mdadm -E" for each drive, that
information is now lost.

In general, "--create" is a last resort, and only to be used for recovery
when you have absolute confidence you understand the layout (mdadm -E
printouts of the original array).  "--assemble --force" is the proper step
after "--assemble" fails.

I would completely scrub the questionable drive with random data, run a long
smartctl test on it, and replace it if it reports any re-allocated sectors at
that point.

I would also run long smartctl tests on the other drives, looking for pending
sectors or re-allocated sectors.  If any, I would plan on replacements for
them as well, and would try to validate the content of your files.  You do
have a backup to compare against, after all.

If you are running a Debian-based distro, and the array contains your rootfs,
you might find "debsums" useful.

HTH,

Phil
