From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 21:01:07 +0100
Message-ID: <87mval4x6k.fsf@esperi.org.uk>
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
        <878tm65kyx.fsf@esperi.org.uk>
        <1f354d53-9eeb-7e00-d2c0-f2fa571cf8c8@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f354d53-9eeb-7e00-d2c0-f2fa571cf8c8@turmel.org> (Phil Turmel's
        message of "Tue, 9 May 2017 15:16:23 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, Phil Turmel told this:

> On 05/09/2017 07:27 AM, Nix wrote:
>> The same, it seems to me, is true of cases in which one drive in a
>> RAID-6 reports a few mismatched blocks. It is true that you don't know
>> the cause of the mismatches, but you *do* know which bit of the mismatch
>> is wrong and what data should be there, subject only to the assumption
>> that sufficiently few drives have made simultaneous mistakes that
>> redundancy is preserved. And that's the same assumption RAID >0 makes
>> all the time anyway!
>
> You are completely ignoring the fact that reconstruction from P,Q is
> mathematically correct only if the entire stripe is written together.

Ooh, true.

> Any software or hardware problem that interrupts a complete stripe write
> or a short-circuited P,Q update can and therefore often will deliver a
> *wrong* assessment of what device is corrupted.  In particular, you
> can't even tell which devices got new data and which got old data.  Even
> worse, cable and controller problems have been known to create patterns
> of corruption to the way to one or more drives.  You desperately need to
> know if this happens to your array.  It is not only possible, but
> *likely* in systems without ECC ram.

Is this still true if the md cache or PPL is in use? The whole point of
these, after all, is to ensure that stripe writes either happen
completely or not at all. (But, again, that'll only guard against things
like power failure interruptions, not bad cabling. However, again, if
you have bad cabling or a bad controller you can expect to have *lots
and lots* of errors -- a small number of errors are much less likely to
be something of this nature. So, again, a threshold like md already
applies elsewhere might seem to be worthwhile. If you are seeing *lots*
of mismatches, clearly correction is unwise -- heck, writing to the
array at all is unwise, and the whole thing might profitably be
remounted ro. I suspect the filesystems will have been remounted ro by
the kernel by this point in any case.)

The point made elsewhere that all your arguments also apply against fsck
still stands. (Why bother with it? If it gave an error, you have a
kernel bug or a bad disk controller, RAM, or cabling, and nothing on
your filesystem can be trusted! just restore from backup!)

Your arguments are absolutely classic "the perfect is the enemy of the
good" arguments, in my view. I can understand falling into that trap on
a RAID list, it's all about paranoia :) but that doesn't mean I agree
with them. I *have* excellent backups, but that doesn't mean I want to
waste hours to days restoring and/or revalidating everything just
because of a persistent mismatch_cnt > 0 which md won't localize for me
or even try to fix because it *might*, uh... no, as far as I can tell
you're worrying that it might in some cases cause corruption of data
that is *already known to be corrupt*. You'll pardon me if this
possibility does not fill me with fear.

> The bottom line is that any kernel that implements the auto-correct you
> seem to think is a slam dunk will be shunned by any system administrator
> who actually cares about their data.  Your obtuseness notwithstanding.

Gee, thanks heaps. Next time I want randomly insulting by someone who
doesn't bother to tell me his actual *arguments* in any message before
the one that starts on the insults, I'll come straight to you.
