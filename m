From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 11:25:30 -0600
Message-ID: <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk>
 <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5911AED4.9030007@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Nix <nix@esperi.org.uk>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 9, 2017 at 5:58 AM, David Brown <david.brown@hesbynett.no> wrote:

> I thought you said that you had read Neil's article.  Please go back and
> read it again.  If you don't agree with what is written there, then
> there is little more I can say to convince you.
>
> One thing I can try, is to note that you are /not/ the first person to
> think "Surely with RAID-6 we can correct mismatches - it should be
> easy?".

H. Peter Anvin's RAID 6 paper, section 4 is what's apparently under discussion
http://milbret.anydns.info/pub/linux/kernel/people/hpa/raid6.pdf

This is totally non-trivial, especially because it says raid6 cannot
detect or correct more than one corruption, and ensuring that
additional corruption isn't introduced in the rare case is even more
non-trivial.

I do think it's sane for raid6 repair to avoid the current assumption
that data strip is correct, by doing the evaluation in equation 27. If
there's no corruption do nothing, if there's corruption of P or Q then
replace, if there's corruption of data, then report but do not repair
as follows:

1. md reports all data drives and the LBAs for the affected stripe
(otherwise this is not simple if it has to figure out which drive is
actually affected but that's not required, just a matter of better
efficiency in finding out what's really affected.)

2. the file system needs to be able to accept the error from md

3. the file system reports what it negatively impacted: file system
metadata or data and if data, the full filename path.

And now suddenly this work is likewise non-trivial.

And there is already something that will do exactly this: ZFS and
Btrfs. Both can unambiguously, efficiently determine whether data is
corrupt even if a drive doesn't report a read error.



-- 
Chris Murphy
