From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 09 May 2017 10:58:34 +0100
Message-ID: <87efvy73n9.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <591171BD.3060707@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <591171BD.3060707@hesbynett.no> (David Brown's message of "Tue,
        09 May 2017 09:37:33 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 May 2017, David Brown spake thusly:

> On 08/05/17 16:50, Nix wrote:
>
>> I wonder... scrubbing is not very useful with md, particularly with RAID
>> 6, because it does no writes unless something mismatches, and on failure
>> there is no attempt to determine which of the N disks is bad and rewrite
>> its contents from the other devices (nor, as I understand it, does it
>> clearly say which drive gave the error, so even failing it out and
>> resyncing it is hard).
>
> Please read Neil Brown's article on this: "Smart or simple RAID
> recovery?" <http://neil.brown.name/blog/20100211050355>

I have. THe simple recovery is too simple. So you have a 40TiB RAID-6
array, say, and mismatch_cnt is consistently >0, but a low value, on
scrub. What can you do? The drive is probably not faulty or you'd have
many more mismatches from persistent misdirected reads or writes. md
doesn't repair the corruption, even though on RAID-6 it could. It
doesn't tell you which disk disagreed so you can fail it out. It doesn't
even tell you where the disagreement was so you can try to rebuild it by
hand. What on earth are you supposed to do in this case? Wipe the entire
array and restore from backup? For a *single* sector?

Right now I'm doing scrubs and ignoring the mismatch_cnt, because all it
can do is increase my worry level to no gain at all. I could just as
well do a dd over /dev/md*. It would have the same effect (only without
md's progress feedback and bandwidth throttling. You get progress
feedback, but you don't get told where errors are found?!)

> When the disk is asked to read a block, it pulls up the data and the ECC
> bits, and uses this to check and re-construct the 4K of data, and a
> measure of how many errors were corrected.  On modern high-capacity
> drives, it is normal that some errors are corrected on a read.  But if
> more than a certain level occur, then the firmware will trigger a
> re-write automatically to the same sector.  This will then be re-read.
> If the error rate is low, fine.  If it is high, then the sector will be
> remapped by the disk.
>
> So simply /reading/ the data, as far as the processor is concerned, will
> cause re-writes as and when needed.

Last time I asked a disk manufacturer about this, they said oh no we
never correct on read, we can't: if we needed to correct on read, the
data would already be unreadable: you have to trigger a write to get
sparing. Nice to see the drive firmware has improved in the last few
years... but one wonders how many disks actually *do* this. It's hard to
tell because sector sparing is so quiet: it's not always even reflected
in the SMART data, AIUI.
