From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Wed, 10 May 2017 05:49:05 +0100
Message-ID: <59129BC1.2090005@youngman.org.uk>
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
 <59121C1C.1050101@youngman.org.uk>
 <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/05/17 04:53, Chris Murphy wrote:
> On Tue, May 9, 2017 at 1:44 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> 
>>> This is totally non-trivial, especially because it says raid6 cannot
>>> detect or correct more than one corruption, and ensuring that
>>> additional corruption isn't introduced in the rare case is even more
>>> non-trivial.
>>
>> And can I point out that that is just one person's opinion?
> 
> Right off the bat you ask a stupid question that contains the answer
> to your own stupid question. This is condescending and annoying, and
> it invites treating you with suspicious as a troll. But then you make
> it worse by saying it again:
> 
Sorry. But I thought we were talking about *Neil's* paper. My bad for
missing it.

>> A
>> well-informed, respected person true, but it's still just opinion.
> 
> Except it is not just an opinion, it's a fact by any objective reader
> who isn't even a programmer, let alone if you know something about
> math and/or programming. Let's break down how totally stupid your
> position is.
> 

<snip ad hominems :-) >
> 
>> At the end of the day, md should never corrupt data by default. Which is
>> what it sounds like is happening at the moment, if it's assuming the
>> data sectors are correct and the parity is wrong. If one parity appears
>> correct then by all means rewrite the second ...
> 
> This is an obtuse and frankly malicious characterization. Scrubs don't
> happen by default. And scrub repair's assuming data strips are correct
> is well documented. If you don't like this assumption, don't use scrub
> repair. You can't say corruption happens by default unless you admit
> that there's URE's on a drive by default - of course that's absurd and
> makes no sense.
> 
Documenting bad behaviour doesn't turn it into good behaviour, though ...
>>
>> But the current setup, where it's currently quite happy to assume a
>> single-drive error and rewrite it if it's a parity drive, but it won't
>> assume a single-drive error and and rewrite it if it's a data drive,
>> just seems totally wrong. Worse, in the latter case, it seems it
>> actively prevents fixing the problem by updating the parity and
>> (probably) corrupting the data.
> 
> The data is already corrupted by definition. No additional damage to
> data is done. What does happen is good P and Q are replaced by bad P
> and Q which matches the already bad data.

Except, in my world, replacing good P & Q by bad P & Q *IS* doing
additional damage! We can identify and fix the bad data. So why don't
we? Throwing away good P & Q prevents us from doing that, and means we
can no longer recover the good data!
> 
> And nevertheless you have the very real problem that drives lie about
> having committed data to stable media. And they reorder writes,
> breaking the write order assumptions of things. And we have RMW
> happening on live arrays. And that means you have a real likelihood
> that you cannot absolutely determine with the available information
> why P and Q don't agree with the data, you're still making probability
> assumptions and if that assumption is wrong any correction will
> introduce more corruption.
> 
> The only unambiguous way to do this has already been done and it's ZFS
> and Btrfs. And a big part of why they can do what they do is because
> they are copy on write. IIf you need to solve the problem of ambiguous
> data strip integrity in relation to P and Q, then use ZFS. It's
> production ready. If you are prepared to help test and improve things,
> then you can look into the Btrfs implementation.

So how come btrfs and ZFS can handle this, and md can't? Can't md use
the same techniques. (Seriously, I don't know the answer. But, like Nix,
when I feel I'm being fed the answer "we're not going to give you the
choice because we know better than you", I get cheesed off. If I get the
answer "we're snowed under, do it yourself" then that is normal and
acceptable.)
> 
> Otherwise I'm sure md and LVM folks have a feature list that
> represents a few years of work as it is without yet another pile on.
> 
>>
>> Report the error, give the user the tools to fix it, and LET THEM sort
>> it out. Just like we do when we run fsck on a filesystem.
> 
> They're not at all comparable. One is a file system, the other a raid
> implementation, they have nothing in common.
> 
> 
And what are file systems and raid implementations? They are both data
store abstractions. They have everything in common.

Oh and by the way, now I've realised my mistake, I've taken a look at
the paper you mention. In particular, section 4. Yes it does say you
can't detect and correct multi-disk errors - but that's not what we're
asking for!

By implication, it seems to be saying LOUD AND CLEAR that you CAN detect
and correct a single-disk error. So why the blankety-blank won't md let
you do that!

Neil's point seems to be that it's a bad idea to do it automatically. I
get his logic. But to then actively prevent you doing it manually - this
is the paternalistic attitude that gets my goat.

Anyways, I've been thinking about this, and I've got a proposal (RFC?).
I haven't got time right now - I'm supposed to be at work - but I'll
write it up this evening. If the response is "we're snowed under - it
sounds a good idea but do it yourself", then so be it. But if the
response is "we don't want the sysadmin to have the choice", then expect
more flak from people like Nix and me.

(And the proposal involves giving sysadmins CHOICE. If they want to take
the hit, it's *their* decision, not a paternalistic choice forced on them.)

(Sorry to keep on about paternalism, but there is a sense that decisions
have been made, and they're not going to be reversed "because I say so".
I'm NOT getting a "you want it, you write it" vibe, and that's what gets
to me.)

Cheers,
Wol
