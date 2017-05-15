From: Nix <nix@esperi.org.uk>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault tolerance with badblocks)
Date: Mon, 15 May 2017 12:11:53 +0100
Message-ID: <87vap2tlvq.fsf@esperi.org.uk>
References: <591314F4.2010702@youngman.org.uk>
        <87lgpyn5sf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgpyn5sf.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 15 May 2017 13:43:44 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15 May 2017, NeilBrown told this:

> On Wed, May 10 2017, Wols Lists wrote:
>
>> This discussion seems to have become a bit heated, but I think we have
>> the following:
>
> ... much of which is throwing baseless accusations at the people who
> provide you will an open operating system kernel without any charge.
> This is not an approach that is likely to win you any friends.

For what it's worth, I intend no accusations. Nobody cackled and cried
"oh yeah let's avoid repairing things! That way my disk-fault army shall
TAKE OVER THE WORLD!!!!"

I just thought that doing something might be preferable to doing nothing
in those limited cases where you can be sure that one side is definitely
wrong, even if you don't know that the other side is definitely right.
I'm fairly sure this was a misconception on my part: see below. "Smart"
repair is, I think, impossible to do reliably, no matter how much parity
you have: you need actual ECC, which is of course a completely different
thing from RAID.

>> FURTHER FACTUAL TIDBITS:
>>
>> The usual response seems to be to push the problem somewhere else. For
>> example "The user should keep backups". BUT HOW? I've investigated!
>>
>> Let's say I buy a spare drive for my backup. But I installed raid to
>> avoid being at the mercy of a single drive. Now I am again because my
>> backup is a single drive! BIG FAIL.
>
> Not necessarily.  What is the chance that your backup device and your
> main storage device both fail at the same time?  I accept that it is
> non-zero, but so is the chance of being hit by a bus.  Backups don't
> help there.

This very fact, after all, the reason why RAID 6 is better than RAID 5
in the first place :)

>> Okay, I'll buy two drives, and have a backup raid. But what if my backup
>> raid is reporting a mismatch count too? Now I have TWO copies where I
>> can't vouch for their integrity. Double the trouble. BIG FAIL.
>
> Creating a checksum of each file that you backup is not conceptually
> hard -

In fact with many backup systems, particularly those based on
content-addressable filesystems like git, it is impossible to avoid.

>         much easier that always having an accurate checksum of all files
> that are currently 'live' on your system.  That would allow you to check
> the integrity of your backups.

I actually cheat. I *could* diff everything, but given that the time it
takes to do that is dominated hugely by the need to reread everything to
re-SHA-1 it, I diff my backups by running another one. 'git diff' on the
resulting commits tells me very rapidly exactly what has changed (albeit
in a somewhat annoying format consisting of variable-size blocks of
files, but it's easy to tell what files and what metadata have altered).
This does waste space with a "useless" backup, though: if I thought
there might be massive corruption I'd symlink my bup backup somewhere
else and do the test comparison backup there. It's easier to delete the
rubble that way. (But, frankly, in that case I'd probably have seen the
massive corruption and be doing a restore from backup in any case.)

>> PROPOSAL: Enable integrity checking.
>>
>> We need to create something like /sys/md/array/verify_data_on_read. If
>> that's set to true and we can check integrity (ie not raid-0), rather
>> than reading just the data disks, we read the entire stripe, check the
>> mirror or parity, and then decide what to do. If we can return

How *do* you decide what to do, though? That's the root of this whole
argument. This isn't something the admin has *time* to respond to, nor a
UI in place to do so.

>> error-corrected data obviously we do. I think we should return an error
>> if we can't, no?
>
> Why "obviously"?  Unless you can explain the cause of an inconsistency,
> you cannot justify one action over any other.  Probable cause is
> sufficient.
>
> Returning a read error when inconsistency is detected, is a valid response.

It *is* one that programs are likely to react rather violently to (how
many programs test for -EIO at all?) or ignore (if it happens on
close()) but frankly if you hit an I/O error there isn't much most
programs *can* do to continue normally, and at least it'll tell you what
program's data is unhappy and the program might tell you what file is
affected. What does a filesystem do if its metadata is -EIOed, though?
That might be... less pleasant.

I think the point here is that we'd like some way to recover that lets
us get back to the most-likely-consistent state. However, on going over
the RAID-6 maths again I think I see where I was wrong. In the absence
of P, Q, P *or* Q or one of P and Q and a data stripe, you can
reconstruct the rest, but the only reason you can do that is because
they are either correct or absent: you can trust them if they're there,
and you cannot mistake a missing stripe for one that isn't missing.

If one syndrome is *wrong* the probability is equal that it is wrong
because it was mis-set by some read or write error or that *the other
syndrome* is wrong, or that both are right and *one stripe* is wrong:
any change to the data in that stripe will affect *both* of them, so you
have no grounds to say "Q is inconsistent, fix it". It could just as
well be P, or a random stripe, and you have no idea which. There are
always changes to the data that will affect only P, and not Q, so there
are no errors you can reliably identify by P/Q consistency checks. (Here
I assume that no error can affect both, which is clearly not true but
just makes everything even harder to get right!)

Reporting the location of the error so you can fix it without wiping and
rewriting the whole filesystem does seem desirable, though. :) I/O
errors are reported in dmesg by the block layer: so should this be.

>> NEVER THROW AWAY USER DATA IF YOU CAN RECONSTRUCT IT !!!

I don't think you can in this case. If Q "looks wrong", it might be
because Q was damaged or because *any one stripe* was damaged in a
countervailing fashion (you don't need two, you only need one). You
likely have more data stripes than P/Q, but P/Q are written more often.
It does indeed seem to be a toss-up, or rather down to the nature of the
failure, which is more likely. And nobody has a clue what that failure
will be in advance and probably not even when it happens.

And so another lovely idea is destroyed by merciless mathematics. This
universe sucks, I want a better one. Also Neil should solve the halting
problem for us in 4.13. RAID is meant to stop things halting, right? :P
