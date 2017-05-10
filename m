From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 21:53:52 -0600
Message-ID: <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <59121C1C.1050101@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59121C1C.1050101@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 1:44 PM, Wols Lists <antlists@youngman.org.uk> wrote:

>> This is totally non-trivial, especially because it says raid6 cannot
>> detect or correct more than one corruption, and ensuring that
>> additional corruption isn't introduced in the rare case is even more
>> non-trivial.
>
> And can I point out that that is just one person's opinion?

Right off the bat you ask a stupid question that contains the answer
to your own stupid question. This is condescending and annoying, and
it invites treating you with suspicious as a troll. But then you make
it worse by saying it again:

> A
> well-informed, respected person true, but it's still just opinion.

Except it is not just an opinion, it's a fact by any objective reader
who isn't even a programmer, let alone if you know something about
math and/or programming. Let's break down how totally stupid your
position is.

1. Opinions don't count for much.
2. You have presented no code that contradicts the opinion that this
is hard. You've opined that an opinion is to be discarded at face
value. Therefore your own opinion is just an opinion and likewise
discardable.
3. How do do the thing you think is trivial has been well documented
for some time and yet there are essentially no implementations. That
it's simple to do (your idea) and yet does not exist (fact) means this
is a big fat conspiracy to fuck you over, on purpose.

It's so asinine I feel trolled right now.

>And
> imho the argument that says raid should not repair the data applies
> equally against fsck - that shouldn't do any repair either! :-)

And now the dog shit cake has cat shit icing on it. Great.


>> And there is already something that will do exactly this: ZFS and
>> Btrfs. Both can unambiguously, efficiently determine whether data is
>> corrupt even if a drive doesn't report a read error.
>>
> Or we write an mdfsck program. Just like you shouldn't run fsck with
> write privileges on a mounted filesystem, you wouldn't run mdfsck with
> filesystems in the array mounted.

Who is we? Are you volunteering other people build you a feature?


> At the end of the day, md should never corrupt data by default. Which is
> what it sounds like is happening at the moment, if it's assuming the
> data sectors are correct and the parity is wrong. If one parity appears
> correct then by all means rewrite the second ...

This is an obtuse and frankly malicious characterization. Scrubs don't
happen by default. And scrub repair's assuming data strips are correct
is well documented. If you don't like this assumption, don't use scrub
repair. You can't say corruption happens by default unless you admit
that there's URE's on a drive by default - of course that's absurd and
makes no sense.

>
> But the current setup, where it's currently quite happy to assume a
> single-drive error and rewrite it if it's a parity drive, but it won't
> assume a single-drive error and and rewrite it if it's a data drive,
> just seems totally wrong. Worse, in the latter case, it seems it
> actively prevents fixing the problem by updating the parity and
> (probably) corrupting the data.

The data is already corrupted by definition. No additional damage to
data is done. What does happen is good P and Q are replaced by bad P
and Q which matches the already bad data.

And nevertheless you have the very real problem that drives lie about
having committed data to stable media. And they reorder writes,
breaking the write order assumptions of things. And we have RMW
happening on live arrays. And that means you have a real likelihood
that you cannot absolutely determine with the available information
why P and Q don't agree with the data, you're still making probability
assumptions and if that assumption is wrong any correction will
introduce more corruption.

The only unambiguous way to do this has already been done and it's ZFS
and Btrfs. And a big part of why they can do what they do is because
they are copy on write. IIf you need to solve the problem of ambiguous
data strip integrity in relation to P and Q, then use ZFS. It's
production ready. If you are prepared to help test and improve things,
then you can look into the Btrfs implementation.

Otherwise I'm sure md and LVM folks have a feature list that
represents a few years of work as it is without yet another pile on.

>
> Report the error, give the user the tools to fix it, and LET THEM sort
> it out. Just like we do when we run fsck on a filesystem.

They're not at all comparable. One is a file system, the other a raid
implementation, they have nothing in common.


-- 
Chris Murphy
