From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Need clarification on raid1 resync behavior with bitmap support
Date: Fri, 3 Aug 2007 09:41:05 -0400
Message-ID: <170fa0d20708030641l258ff0adrfdfa7726f746969e@mail.gmail.com>
References: <170fa0d20707210959q11153d38u3281062c98d3adb7@mail.gmail.com>
	 <18084.22271.122052.80056@notabene.brown>
	 <170fa0d20707230547y3accc5c9v14805fdb3637e9c0@mail.gmail.com>
	 <18098.52840.936611.7816@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18098.52840.936611.7816@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/3/07, Neil Brown <neilb@suse.de> wrote:
> On Monday July 23, snitzer@gmail.com wrote:
> > On 7/23/07, Neil Brown <neilb@suse.de> wrote:
> > > Can you test this out and report a sequence of events that causes a
> > > full resync?
> >
> > Sure, using an internal-bitmap-enabled raid1 with 2 loopback devices
> > on a stock 2.6.20.1 kernel, the following sequences result in a full
> > resync.  (FYI, I'm fairly certain I've seen this same behavior on
> > 2.6.18 and 2.6.15 kernels too but would need to retest):
> >
> > 1)
> > mdadm /dev/md0 --manage --fail /dev/loop0
> > mdadm -S /dev/md0
> > mdadm --assemble /dev/md0 /dev/loop0 /dev/loop1
> >   mdadm: /dev/md0 has been started with 1 drive (out of 2).
> >   NOTE: kernel log says:  md: kicking non-fresh loop0 from array!
> > mdadm /dev/md0 --manage --re-add /dev/loop0
>
>
> sorry for the slow response.
>
> It looks like commit 1757128438d41670ded8bc3bc735325cc07dc8f9
> (December 2006) set conf->fullsync a litte too often.
>
> This seems to fix it, and I'm fairly sure it is correct.
>
> Thanks,
> NeilBrown
>
> ----------------------------------
> Make sure a re-add after a restart honours bitmap when resyncing.
>
> Commit 1757128438d41670ded8bc3bc735325cc07dc8f9 was slightly bad.
> If and array has a write-intent bitmap, and you remove a drive,
> then readd it, only the changes parts should be resynced.
> This only works if the array has not been shut down and restarted.
>
> The above mentioned commit sets 'fullsync' at little more often
> than it should.  This patch is more careful.

I hand-patched your change into a 2.6.20.1 kernel (I'd imagine your
patch is against current git).  I didn't see any difference because
unfortunately both of my full resync scenarios included stopping a
degraded raid after either: 1) having failed but not been removed a
member 2) having failed and removed a member.  In both scenarios if I
didn't stop the array and I just removed and re-added the faulty drive
the array would _not_ do a full resync.

My examples clearly conflict with your assertion that: "This only
works if the array has not been shut down and restarted."

But shouldn't raid1 be better about leveraging the bitmap of known
good (fresh) members even after having stopped a degraded array?  Why
is it that when an array is stopped raid1 seemingly loses the required
metadata that enables bitmap resyncs to just work upon re-add IFF the
array is _not_ stopped?  Couldn't raid1 be made to assemble the array
to look like the array had never been stopped, leaving the non-fresh
members out as it already does, and only then re-add the "non-fresh"
members that were provided?

To be explicit: isn't the bitmap still valid on the fresh members?  If
so, why is raid1 just disregarding the fresh bitmap?

Thanks, I really appreciate your insight.
Mike
