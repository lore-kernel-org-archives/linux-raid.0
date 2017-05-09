From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 21:18:20 +0100
Message-ID: <87fugd4wdv.fsf@esperi.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        (Chris Murphy's message of "Tue, 9 May 2017 11:25:30 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9 May 2017, Chris Murphy verbalised:

> On Tue, May 9, 2017 at 5:58 AM, David Brown <david.brown@hesbynett.no> wrote:
>
>> I thought you said that you had read Neil's article.  Please go back and
>> read it again.  If you don't agree with what is written there, then
>> there is little more I can say to convince you.

The entire article is predicated on the assumption that when an
inconsistent stripe is found, fixing it is simple because you can just
fail whichever device is inconsistent... but given that the whole
premise of the article is that *you cannot tell which that is*, I don't
see the point in failing anything.

The first comment in the article is someone noting that md doesn't say
which device is failing, what the location of the error is or anything
else a sysadmin might actually find useful for fixing it. "Hey, you have
an error somewhere on some disk on this multi-terabyte array which might
be data corruption and if a disk fails will be data corruption!" is not
too useful :( The fourth comment notes that the "smart" approach, given
RAID-6, has a significantly higher chance of actually fixing the problem
than the simple approach. I'd call that a fairly important comment...

(Neil said: "Similarly a RAID6 with inconsistent P and Q could well not
be able to identify a single block which is "wrong" and even if it could
there is a small possibility that the identified block isn't wrong, but
the other blocks are all inconsistent in such a way as to accidentally
point to it. The probability of this is rather small, but it is
non-zero". As far as I can tell the probability of this is exactly the
same as that of multiple read errors in a single stripe -- possibly far
lower, if you need not only multiple wrong P and Q values but *precisely
mis-chosen* ones. If that wasn't acceptably rare, you wouldn't be using
RAID-6 to begin with.

I've been talking all the time about a stripe which is singly
inconsistent: either all the data blocks are fine and one of P or Q is
fine, or both P and Q and all but one data block is fine, and the
remaining block is inconsistent with all the rest. Obviously if more
blocks are corrupt, you can do nothing but report it. The redundancy
simply isn't there to attempt repair.)

> H. Peter Anvin's RAID 6 paper, section 4 is what's apparently under discussion
> http://milbret.anydns.info/pub/linux/kernel/people/hpa/raid6.pdf
>
> This is totally non-trivial, especially because it says raid6 cannot
> detect or correct more than one corruption, and ensuring that
> additional corruption isn't introduced in the rare case is even more
> non-trivial.

Yeah. Testing this is the bastard problem, really. Fault injection via
dm is the only approach that seems remotely practical to me.

> I do think it's sane for raid6 repair to avoid the current assumption
> that data strip is correct, by doing the evaluation in equation 27. If
> there's no corruption do nothing, if there's corruption of P or Q then
> replace, if there's corruption of data, then report but do not repair

At least indicate *where* the corruption is in the report. (I'd say
"repair, as a non-default option" for people with a different
availability/P(corruption) tradeoff -- since, after all, if you're using
RAID In the first place you value high availability across disk problems
more than most people do, and there is a difference between one bit of
unreported damage that causes a near-certain restore from backup and
either zero or two of them plus a report with an LBA attached so you
know you need to do something...)

> as follows:
>
> 1. md reports all data drives and the LBAs for the affected stripe
> (otherwise this is not simple if it has to figure out which drive is
> actually affected but that's not required, just a matter of better
> efficiency in finding out what's really affected.)

Yep.

> 2. the file system needs to be able to accept the error from md

It would probably need to report this as an -EIO, but I don't know of
any filesystems that can accept asynchronous reports of errors like
this. You'd need reverse mapping to even stand a chance (a non-default
option on xfs, and of course available on btrfs and zfs too). You'd
need self-healing metadata to stand a chance of doing anything about it.
And god knows what a filesystem is meant to do if part of the file data
vanishes. Replace it with \0? ugh. I'd almost rather have the error
go back out to a monitoring daemon and have it send you an email...

> 3. the file system reports what it negatively impacted: file system
> metadata or data and if data, the full filename path.
> 
> And now suddenly this work is likewise non-trivial.

Yeah, it's all the layers stacked up to the filesystem that are buggers
to deal with... and now the optional 'just repair it dammit' approach
seems useful again, if just because it doesn't have to deal with all
these extra layers.

> And there is already something that will do exactly this: ZFS and
> Btrfs. Both can unambiguously, efficiently determine whether data is
> corrupt even if a drive doesn't report a read error.

Yeah. Unfortunately both have their own problems: ZFS reimplements the
page cache and adds massive amounts of ineffiicency in the process, and
btrfs is... well... not really baked enough for the sort of high-
availability system that's going to be running RAID, yet. (Alas!)

(Recent xfs can do the same with metadata, but not data.)

-- 
NULL && (void)
