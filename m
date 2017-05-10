From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Fault tolerance with badblocks
Date: Wed, 10 May 2017 11:18:12 -0600
Message-ID: <CAJCQCtRfe36Gbcmbqv+9EUM4fOg_hD2C0OFxCAZ2YyiFdwtqoA@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <59121C1C.1050101@youngman.org.uk> <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
 <59129BC1.2090005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59129BC1.2090005@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 10:49 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 10/05/17 04:53, Chris Murphy wrote:
>> On Tue, May 9, 2017 at 1:44 PM, Wols Lists <antlists@youngman.org.uk> wrote:
>>
>>>> This is totally non-trivial, especially because it says raid6 cannot
>>>> detect or correct more than one corruption, and ensuring that
>>>> additional corruption isn't introduced in the rare case is even more
>>>> non-trivial.
>>>
>>> And can I point out that that is just one person's opinion?
>>
>> Right off the bat you ask a stupid question that contains the answer
>> to your own stupid question. This is condescending and annoying, and
>> it invites treating you with suspicious as a troll. But then you make
>> it worse by saying it again:
>>
> Sorry. But I thought we were talking about *Neil's* paper. My bad for
> missing it.

Doesn't matter. Your standard is mere opinions are ignorable, and
therefore by your own standard you can be ignored for posing mere
opinions yourself. You set your own trap but you clearly want to hold
a double standard: your opinions are valid and should be listened to,
and others' opinions are merely opinion and can be easily discarded.


>>> A
>>> well-informed, respected person true, but it's still just opinion.
>>
>> Except it is not just an opinion, it's a fact by any objective reader
>> who isn't even a programmer, let alone if you know something about
>> math and/or programming. Let's break down how totally stupid your
>> position is.
>>
>
> <snip ad hominems :-) >

It is not an ad hominem attack to evaluate your lack of logic. An ad
hominem attack is one on the person rather than their arguments. I
haven't attacked you, I've attacked your arguing style and the deep
ignorance that style conveys. And you shouldn't like it, but you have
only yourself to blame, you didn't exactly bother to do any list
archive research before demanding everyone's foolish for having
withheld this feature from you personally. It almost immediately
became noise.


>>> At the end of the day, md should never corrupt data by default. Which is
>>> what it sounds like is happening at the moment, if it's assuming the
>>> data sectors are correct and the parity is wrong. If one parity appears
>>> correct then by all means rewrite the second ...
>>
>> This is an obtuse and frankly malicious characterization. Scrubs don't
>> happen by default. And scrub repair's assuming data strips are correct
>> is well documented. If you don't like this assumption, don't use scrub
>> repair. You can't say corruption happens by default unless you admit
>> that there's URE's on a drive by default - of course that's absurd and
>> makes no sense.
>>
> Documenting bad behaviour doesn't turn it into good behaviour, though ...

It is a common loophole to describe the chosen behavior when good
behavior is difficult or infeasible. It happens all the time.
Complaining here isn't going to change this.


>>>
>>> But the current setup, where it's currently quite happy to assume a
>>> single-drive error and rewrite it if it's a parity drive, but it won't
>>> assume a single-drive error and and rewrite it if it's a data drive,
>>> just seems totally wrong. Worse, in the latter case, it seems it
>>> actively prevents fixing the problem by updating the parity and
>>> (probably) corrupting the data.
>>
>> The data is already corrupted by definition. No additional damage to
>> data is done. What does happen is good P and Q are replaced by bad P
>> and Q which matches the already bad data.
>
> Except, in my world, replacing good P & Q by bad P & Q *IS* doing
> additional damage!

Arguing about it doesn't make it true. The primary data is corrupt and
in normal operation P & Q are not checked, so it will always silently
return corrupt data in normal operation, and if there is a failure
that does not exactly coincide with the corruption, the corruption
that is read in the ensuing reconstruction will corrupt the
reconstruction even though P & Q are good. So what you want to fix is
a lot of buck for almost no gain.

>We can identify and fix the bad data. So why don't
> we? Throwing away good P & Q prevents us from doing that, and means we
> can no longer recover the good data!

There is no possible way to know that P & Q are both good. That
requires assumption. So you've arbitrarily traded an assumption you
don't like for one that you do like, but have no evidence for in
either case.

There are better ways to solve this problem. md and LVM raid are
really about solving one, or two particular problemswhich is not data
integrity, it is data availability and recovery via reconstruction
rather than from backups being restored.

Better is defined by the use case at hand. Some use cases will want
this solved at the file system level, which points to ZFS or Btrfs -
the very problem you're talking about is one of those problems that
led to the design of both of those file systems. Other use cases can
have it solved at an application level. And still others will solve it
with a cluster file system, like glusterfs does with per file
checksums and replication.


>> And nevertheless you have the very real problem that drives lie about
>> having committed data to stable media. And they reorder writes,
>> breaking the write order assumptions of things. And we have RMW
>> happening on live arrays. And that means you have a real likelihood
>> that you cannot absolutely determine with the available information
>> why P and Q don't agree with the data, you're still making probability
>> assumptions and if that assumption is wrong any correction will
>> introduce more corruption.
>>
>> The only unambiguous way to do this has already been done and it's ZFS
>> and Btrfs. And a big part of why they can do what they do is because
>> they are copy on write. IIf you need to solve the problem of ambiguous
>> data strip integrity in relation to P and Q, then use ZFS. It's
>> production ready. If you are prepared to help test and improve things,
>> then you can look into the Btrfs implementation.
>
> So how come btrfs and ZFS can handle this, and md can't?

All data and metadata blocks are checksummed, and they're always
verified during normal operation for every read. The data checksums
are themselves checksummed. Even if a drive does not report an error,
error can be detected, and trigger reconstruction if redundant
metadata or data is available.

md does not checksum anything but its own metadata which is just the
superblock, there isn't much of anything else to it. There's no
checksums for data strips, parity strips, there's no timestamp for any
of the writes, there's a distinct lack of information to be able to do
an autopsy after the fact without any assumptions.

> Can't md use
> the same techniques. (Seriously, I don't know the answer. But, like Nix,
> when I feel I'm being fed the answer "we're not going to give you the
> choice because we know better than you", I get cheesed off. If I get the
> answer "we're snowed under, do it yourself" then that is normal and
> acceptable.)

No they operate on completely different architecture and assumptions.
You really should search the archives, all of these things you're
wanting to discuss now have already been discussed and argued and
nothing has changed.



>>
>> Otherwise I'm sure md and LVM folks have a feature list that
>> represents a few years of work as it is without yet another pile on.
>>
>>>
>>> Report the error, give the user the tools to fix it, and LET THEM sort
>>> it out. Just like we do when we run fsck on a filesystem.
>>
>> They're not at all comparable. One is a file system, the other a raid
>> implementation, they have nothing in common.
>>
>>
> And what are file systems and raid implementations? They are both data
> store abstractions. They have everything in common.

They have almost nothing in common. File systems store files. RAIDs do
not know anything at all about files. RAID has a superblock, and a
couple of optional logs for very specific purposes, there are no
trees. RAID works by logical assumptions where things are located, it
doesn't do lookups using metadata to find your data, it's all
determined by geometry, totally unlike a file system.


>
> Oh and by the way, now I've realised my mistake, I've taken a look at
> the paper you mention. In particular, section 4. Yes it does say you
> can't detect and correct multi-disk errors - but that's not what we're
> asking for!
>
> By implication, it seems to be saying LOUD AND CLEAR that you CAN detect
> and correct a single-disk error. So why the blankety-blank won't md let
> you do that!

It's one particular kind of error and there isn't enough on disk
metadata to differentiate this particular kind of error after the
fact. You're looking at this problem in total isolation to all other
problems. And you're not familiar with the lack of information
available in the corpse.

Neil's version of this explanation:

"Similarly a RAID6 with inconsistent P and Q could well not be able to
identify a single block which is "wrong" and even if it could there is
a small possibility that the identified block isn't wrong, but the
other blocks are all inconsistent in such a way as to accidentally
point to it. The probability of this is rather small, but it is
non-zero."

The autofix in such a case could cause more damage.


>
> Neil's point seems to be that it's a bad idea to do it automatically. I
> get his logic. But to then actively prevent you doing it manually - this
> is the paternalistic attitude that gets my goat.

You have no example code. You've basically come on the list, without
any prior research, and said "GIMME!"

*shrug*



>
> Anyways, I've been thinking about this, and I've got a proposal (RFC?).
> I haven't got time right now - I'm supposed to be at work - but I'll
> write it up this evening. If the response is "we're snowed under - it
> sounds a good idea but do it yourself", then so be it. But if the
> response is "we don't want the sysadmin to have the choice", then expect
> more flak from people like Nix and me.

1. The default response without having to say it is "we're snowed
under, show us a proof of concept first".
2. You have no imagination by having assumed this has never come up
before, instead thinking you're the first to have this feature in mind
3. You took the ensuing resistance personally.

You have an idea, the burden is on you to demonstrate a need, provide
code examples, and ask the right questions like "would the maintainers
accept some changes for error reporting for scrub checks?" At the very
least what you suggest indicates error reporting enhancements so why
not ask about those parameters?

Instead, from the outset you treated this resistance as if other
people are your grumpy daddy and they're just being mean to you.
That's why you got the reception you did. Mischaracterizing other
people as being paternalistic isn't going to help get a different
perception. (I was thinking of Commander Sela, referring to Toral,
when she said "Silence the child or send him away!")

My proposal for your proposal is a patch that implements equation 27
from HPA's paper, and enhances error reporting per its descriptive
outcomes.

md: error: mismatch, P corruption, array logical <LBA>
md: error: mismatch, Q corruption, array logical <LBA>
md: error: mismatch, data corruption suspected, array logical <LBA>

That's subject to wording and formatting discussion, I have not looked
at existing formatting, but you need to ask if approximately this
would be accepted.

However, the main point is that you need to find out what the
computational cost is for this scrub enhancement is. If it takes 5
times longer, even you will laugh and say it's not worth it. Stop
asking "why isn't this already implemented! do it now! now! now! now!"
 Instead ask "what is the ballpark maximum performance impact to scrub
that would be accepted? And if that maximum is busted would
maintainers consider a new value "check2" to write to echo check >
/sys/block/mdX/md/sync_action?"

Once you have better error reporting, a user space tool could use the
array metadata, and the error reporting LBA to lookup that stripe and
reconstruct just that stripe with the assumption that P & Q are
correct and hopefully fix your data. Or whatever other assumptions you
want to try and make to attempt different recoveries. That user space
tool could also backup the existing stripe so the fixes are all
reversible.


-- 
Chris Murphy
