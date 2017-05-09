From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 21:52:39 +0100
Message-ID: <59122C17.8010801@youngman.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
 <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <87fugd4wdv.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fugd4wdv.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/05/17 21:18, Nix wrote:
> (Neil said: "Similarly a RAID6 with inconsistent P and Q could well not
> be able to identify a single block which is "wrong" and even if it could
> there is a small possibility that the identified block isn't wrong, but
> the other blocks are all inconsistent in such a way as to accidentally
> point to it. The probability of this is rather small, but it is
> non-zero". As far as I can tell the probability of this is exactly the
> same as that of multiple read errors in a single stripe -- possibly far
> lower, if you need not only multiple wrong P and Q values but *precisely
> mis-chosen* ones. If that wasn't acceptably rare, you wouldn't be using
> RAID-6 to begin with.

This to me is the crux of the argument.

What is the probability of CORRECTLY identifying a single-disk error?

What is the probability of WRONGLY mistaking a multi-disk error for a
single-disk error?

My gut instinct is that the second scenario is much less likely. So, in
that case, the current setup is that we DELIBERATELY CORRUPT a
recoverable error because of the TINY risk that we might have got it
wrong. Picking probabilities at random, let's say the first probability
is 99 in a hundred, the second is one in a thousand.

On a four-disk raid-6, that means we're throwing away about 500 chances
of recovering the correct data, so that on one occasion we can avoid
corruption. To me that's an insane trade-off.

Neil goes on about "what if a write fails? What if the power goes down?
What if what if?" Those are the wrong questions!!! The correct question
is "can we identify the difference between a single-disk failure and a
multi-disk failure". We don't care what *caused* that failure.

If the power goes down and only the first disk in a stripe is written,
we can correct it back to what it was. If only the last disk failed to
be written, we can correct it back to what it should have been. If at
least two disks are written and at least two disks are not, CAN WE
DETECT THAT? Surely we can - we don't care how many disks are or aren't
written - in that scenario surely all the parities mess up. In which
case we give up and say "corrupt data". Which is no different from at
present other than at present we fix the parity and pretend nothing is
wrong :-(

The problem is that at present we fix the parity and pretend nothing is
wrong when the reality is we *could* have corrected the data, if we
could have been bothered.

So we have to write an mdfsck. Okay. So we have to make sure that no
filesystems on the array are mounted. Okay, that's a bit harder. So we
have to assume that sysadmins are sensible beings who don't screw things
up - okay that's a lot harder :-) But we shouldn't be throwing away LOTS
of data that's easy to recover, because we MIGHT "recover" data that's
wrong.

Yes, yes, I know - code welcome ... :-)

Cheers,
Wol
