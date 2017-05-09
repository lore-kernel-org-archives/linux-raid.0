From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 10:53:20 +0100
Message-ID: <87inla73vz.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> (Anthony
        Youngman's message of "Mon, 8 May 2017 21:27:13 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 May 2017, Anthony Youngman told this:

> If the scrub finds a mismatch, then the drives are reporting
> "everything's fine here". Something's gone wrong, but the question is
> what? If you've got a four-drive raid that reports a mismatch, how do
> you know which of the four drives is corrupt? Doing an auto-correct
> here risks doing even more damage. (I think a raid-6 could recover,
> but raid-5 is toast ...)

With a RAID-5 you are screwed: you can reconstruct the parity but cannot
tell if it was actually right. You can make things consistent, but not
correct.

But with a RAID-6 you *do* have enough data to make things correct, with
precisely the same probability as recovery of a RAID-5 "drive" of length
a single sector. It seems wrong that not only does md not do this but
doesn't even tell you which drive made the mistake so you could do the
millions-of-times-slower process of a manual fail and readdition of the
drive (or, if you suspect it of being wholly buggered, a manual fail and
replacement).

> And seeing as drives are pretty much guaranteed (unless something's
> gone BADLY wrong) to either (a) accurately return the data written, or
> (b) return a read error, that means a data mismatch indicates
> something is seriously wrong that is NOTHING to do with the drives.

This turns out not to be the case. See this ten-year-old paper:
<https://indico.cern.ch/event/13797/contributions/1362288/attachments/115080/163419/Data_integrity_v3.pdf>.
Five weeks of doing 2GiB writes on 3000 nodes once every two hours
found, they estimated, 50 errors possibly attributable to disk problems
(sector- or page-size regions of corrupted data) on 1/30th of their
nodes. This is *not* rare and it is hard to imagine that 1/30th of disks
used by CERN deserve discarding. It is better to assume that drives
misdirect writes now and then, and to provide a means of recovering from
them that does not take days of panic. RAID-6 gives you that means: md
should use it.

The page-sized regions of corrupted data were probably software -- but
the sector-sized regions were just as likely the drives, possibly
misdirected writes or misdirected reads.

Neil decided not to do any repair work in this case on the grounds that
if the drive is misdirecting one write it might misdirect the repair as
well -- but if the repair is *consistently* misdirected, that seems
relatively harmless (you had corruption before, you have it now, it just
moved), and if it was a sporadic error, the repair is worthwhile. The
only case in which a repair should not be attempted is if the drive is
misdirecting all or most writes -- but in that case, by the time you do
a scrub, on all but the quietest arrays you'll see millions of
mismatches and it'll be obvious that it's time to throw the drive out.
(Assuming md told you which drive it was.)

>> If a sector weakens purely because of neighbouring writes or temperature
>> or a vibrating housing or something (i.e. not because of actual damage),
>> so that a rewrite will strengthen it and relocation was never necessary,
>> surely you've just saved a pointless bit of sector sparing? (I don't
>> know: I'm not sure what the relative frequency of these things is. Read
>> and write errors in general are so rare that it's quite possible I'm
>> worrying about nothing at all. I do know I forgot to scrub my old
>> hardware RAID array for about three years and nothing bad happened...)
>>
> Yes you have saved a sector sparing. Note that a consumer 3TB drive
> can return, on average, one error every time it's read from end to end
> 3 times, and still be considered "within spec" ie "not faulty" by the

Yeah, that's why RAID-6 is a good idea. :)

> manufacturer. And that's a *brand* *new* drive. That's why building a
> large array using consumer drives is a stupid idea - 4 x 3TB drives
> and a *within* *spec* array must expect to handle at least one error
> every scrub.

That's just one reason why. The lack of control over URE timeouts is
just as bad.

> Okay - most drives are actually way over spec, and could probably be
> read end-to-end many times without a single error, but you'd be a fool
> to gamble on it.

I'm trying *not* to gamble on it -- but I don't want to end up in the
current situation we seem to have with md6, which is "oh, you have a
mismatch, it's not going away, but we're neither going to tell you where
it is nor what disk it's on nor repair it ourselves, even though we
could, just to make it as hard as possible for you to repair the problem
or even tell if it's a consistent one" (is the single mismatch an
expected, spurious read error because of the volume of data you're
reading, or one that's consistent and needs repair? All mismatch_cnt
tells you is that there's a mismatch).

-- 
NULL && (void)
