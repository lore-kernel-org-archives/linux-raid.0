From: freaky <freaky@bananateam.nl>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported
 through LIO (iSCSI)
Date: Wed, 19 Sep 2012 15:08:19 +0200
Message-ID: <5059C3C3.8020808@bananateam.nl>
References: <50588731.5050502@bananateam.nl> <20568.54327.717927.127094@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20568.54327.717927.127094@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18-09-12 22:06, Peter Grandi wrote:
> [ ... ]
>
>> I noticed in iostat something I personally find very weird.
>> All the disks in the RAID set (minus the spare) seem to read
>> 6-7 times as much as they write. Since there is no other I/O
>> (so there aren't really any reads issued besides some very
>> occasional overhead for NTFS perhaps once in a while) I find
>> this really weird. Note also that iostat doesn't show the
>> reads in iostat on the md device (which is the case if the
>> initiator issues reads) but only on the active disks in the
>> RAID set, which to me (unknowingly as I am :)) indicates mdadm
>> in the kernel is issuing those reads. [ ... ]
> It is not at all weird. The performance of MD ('mdadm' is just
> the user level tool to configure it) is pretty good in this case
> even if the speed is pretty low. MD is working as expected when
> read-modify-write (or some kind of resync or degraded operation)
> is occurring. BTW I like your use of the term "RAID set" because
> that's what I use myself (because "RAID array" is redundant
> :->).

Yes, with read-modify-write this is to be expected. However, I'm copying
a large file (largely sequentially thus especially since there was no
other I/O), which is buffered in which case most of the writes should be
entire stripes.

I wouldn't have mentioned it if IETD didn't perform this much better.
Since I'm not aware of kernel internals I figured it might have
something to with the ways the buffers are committed. As in with IETD it
recognizes it's a large contiguous part of data and consolidates it to a
single stripe write and with LIO it writes 64k chunks synchronously
causing it to write say chunk 1 out of 6, reads chunks 2-6, calculates
parity and writes chunk 1 and the parity block and thus has a lot more
operations to write the same stripe. It is also why for example vmware,
which does nothing but sync I/O, has extremely lousy performance on
non-caching RAID controllers. By far the easiest way to show people in
my experience.

Anyway, to me it looks like that's what going on - but I didn't want to
jump to conclusions w/o in-depth kernel knowledge. As far as I know
there aren't any separate buffers though, so LIO and IETD would be using
the same buffers / infrastructure in which case my assumption will be
embarrassingly wrong.

Concerning the RAID set terminology, I didn't even realise that.

> Apparently awareness of the effects of RMW )or resyncing or
> degraded operation) is sort of (euphemism) unspecial RAID
> knowledge, but only the very elite of sysadms seem to be aware
> of it :-). A recent similar enquiry was the (euphemism) strange
> concern about dire speed by someone who had (euphemism) bravely
> setup RAID6 running deliberately in degraded mode.

Even less seem to be aware of the write-hole :D

> My usual refrain is: if you don't know better, never use parity
> RAID, only use RAID1 or RAID10 (if you want redundancy).
>
> But while the performance of MD you report is good, the speed is
> bad even for a mere RMW/resync/degraded issue, so this detail
> matters:
>
>> Do note - I'm running somewhat unorthodox. I've created a
>> RAID-5 of 7 disks + hotspare
> One could (euphemism) wonder how well a 6x stripe/stripelet size
> is going to play with 4KiB aligned NTFS operations...
It's formatted with a 64kiB blocksize (or cluster size in NTFS
terminology) . This is also the RAID's chunk size.

>> (it was originally a RAID-6 w/o hotspare but converted it to
>> RAID-5 in hopes of improving performance).
> A rather (euphemism) audacious operation, especially because of
> the expectation that reshaping a RAID set leaves the content in
> an optimal stripe layout. I am guessing that you reshaped rather
> than recreated because you did not want to dump/reload the
> content, rather (euphemism) optimistically.
Correct. Also, with exception of 3 machines it actually does back up
itself, other jobs replicate to it. If it really would go wrong I'd have
to drive by a customer or 6 to seed-load the other ~50 servers on it
again. Given the risk (never had issues with reshaping) we took it.
Loosing the data is thus not life threatening, just very very annoying /
time consuming. So I was either guaranteed to loose a lot of time moving
the data (and an investment on something to store it on), or take the
risk of loosing a bit more time. It turned out well :). Did use a log
file for the reshaping btw. So it could survive reboots (would have had
to manually restart/bring it up).

> There are likely to be other (euphemism) peculiarities in your
> setup, probably to do with network flow control, but the above
> seems enough...
>
> Sometimes it is difficult for me to find sufficiently mild yet
> suggestive euphemisms to describe some of the stuff that gets
> reported here. This is one of those cases.
>
> Unless you are absolutely sure you know better:
>
> * Never grow or reshape a RAID set or a filetree.
> * Just use RAID1 or RAID10 (or a 3 member RAID5 in some cases
>   where writes are rare).
> * Don't partition the member or array devices or use GPT for
>   both if you must.
Not really an option to use msdos partitioning (way larger than 2TiB)
:). Did look seriously at the offsets being a multiple of 64 so it
doesn't start somewhere in the middle of a chunk. Parted also reports
aligning is properly (I do seriously despise these kind of tools, that
work with blocksizes specifically, using decimal instead of binary
k/M/G's etc).

> If you are absolutely sure you know better then you will not
> need to ask for help here :-).
Do note I'm specifically asking about the interaction with LIO :). Don't
have the benchmarks any more, but several local tests (on the machine
itself w/o the iSCSI layer in between) showed very acceptable numbers. I
just need some descent performance (~50MB/s sequential and in the order
of 10MB/s random - the local benches were way faster than that) and a
lot of storage in this case as it's just to store back-ups (image based
- very large files) and their incrementals. On a daily basis some
incrementals are merged but a lot of the I/O should be sequential and
large (often causing entire stripe writes when buffered/cached - or well
they should and it seems to do this just fine with IET, but not with LIO).

I'll never put anything (random) I/O intensive on anything but 10 :). Or
there must be some really fancy new developments (haven't digged into
ZFS and the likes deep enough yet).

>> This disk is about 12TB. It's partitioned with GPT in ~9TB
> At least you used GPT partitioning, which is commendable, even
> if you regret it below...

Yea, not that I had a choice :P.

>> and ~2.5TB (there's huge rounding differences at these sizes
>> 1000 vs 1024et al :)).
> It is very nearly 5%/7% depending which way.
>
>> With msdos partitions I could easily mess with it myself. [
>> ... ]
> MSDOS style labels are fraught with subtle problem that require
> careful handling.

But they're very easy to backup/restore with dd :).

Thanks for the re' :).
