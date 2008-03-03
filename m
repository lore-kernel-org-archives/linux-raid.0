From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Mon, 03 Mar 2008 05:58:19 +0300
Message-ID: <47CB694B.9000807@msgid.tls.msk.ru>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>	 <47CAC5BF.6060600@msgid.tls.msk.ru>	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>	 <47CAF30F.7040502@msgid.tls.msk.ru>	 <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>	 <47CB228D.5020709@msgid.tls.msk.ru> <bb145bd20803021617j1b15c667j96d3ee12829ee75a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803021617j1b15c667j96d3ee12829ee75a@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
>>  I highly doubt chunk size makes any difference.  Bitmap is the primary
>>  suspect here.

I meant something else.  Sure thing chunk size will have quite
significant impact on write performance, see below.  What I meant
is that the PROBLEM you're facing is not due to chunk size but
due to bitmap.

> Some tests:
> 
> raid5, chunk size goes from 16k to 1m. arrays created with --assume-clean
> 
> dd-tests
> ========
[]
> dd-write
> --------
> with bitmap: gets SLOWLY worse with inc. chunk size	 30 ->  27 MB/s
> without bitmap: gets MUCH worse with inc chunk size	100 ->  59 MB/s

In other words, bitmap makes HUGE impact - when it's on, everything is
so damn slow that other factors aren't even noticeable.  When bitmap
is off, write speed drops when increasing chunk size.

> Conclusion: needs explanation / tuning

You know how raid5 process writes, right?  The read-modify-write or
similar technique, that involves READING as well as writing, reading
from other disks in order to calculate/update parity.  Unless you
write complete stripe (all chunks).

So the bigger your chunk size is, the less chances you have to perform
full-stripe write, just because "large, properly aligned" writes are
much less frequent than "smaller, unaligned" ones - at least for a
typical filesystem usage (special usage patterns exists for sure).

Here, both linux write-back cache (writes don't go directly to disk
but to kernel memory first, and kernel does some reordering/batching
here) and md stripe-cache makes huge difference, for obvious reasons.

> even omitting the bitmap the writes just touch 100 MB/s, more like 80
> on any chunk size with nice reads.
> why would it get worse? Anything tunable here?

Yes.  See your read-test with small chunk size.  Here, you've got
better "initial" results.  Why the reading with small chunk size
is so slow?  Because of the small request size to the underlying
device, that's why - each drive effectively is reading by 16Kb at
once, spending much time rotating and communicating with the controller...

But unlike for reads, increasing chunk size does not help writes -
because of the above reasons (writing "half" stripes more often and
hence requiring read-modify-write cycle more often etc).

You can get best results when writing WITHOUT a filesystem
(directly to /dev/mdFOO) with dd and blocksize equal to the
total strip size (chunk size * number of data disks, or
16k * 3 ..... 1M * 3, since in your raid 3 disks are data
in each strip), and trying direct write at the same time.
Yes it will be a bit worse than read speed, but it should be
pretty descent still.

I said "without a filesystem" because alignment is very important
too, -- to the same level as full-strip vs "half"-strip writes,
and with a filesystem in place, you can't be sure anymore how
your files are aligned on disk (xfs tries to align files correctly,
at least under some conditions).

> the maximum total reached via parallel single-disk writes is 150 MB/s
> 
> 
> mke2fs-tests
> ============
> 
> create ext3 fs with correct stride, get a 10-second vmstat average 10
> seconds in and abort the mke2fs
> 
> with bitmap: goes down SLOWLY from 64k chunks		 17 ->  13 MB/s
> without bitmap: gets MUCH worse with inc. chunk size	 80 ->  34 MB/s
> 
> Conclusion: needs explanation / tuning

The same thing.  Bitmap makes HUGE impact, and w/o bitmap, write speed
drops when increasing chunk size.

> Comments welcome.

I see one problem (the bitmap thing, finally discovered and confirmed),
and a need to tune your system beforehand -- it's the chunk size.  And
here, you're pretty much a wizard - it's your guess.  In any case,
unless your usage pattern will be special and optimized for such a
setup, don't try to choose large chunk size for raid456.  Choosing large
chunk size for raid0 and raid10 makes sense, but with raid456 it has
immediately bad sides.

> Next step: smaller bitmap
> When the performance seems normal I'll revisit the responsiveness-issue.
> 
>>  Umm..  You mixed it all ;)
>>  Bitmap is a place (stored somewhere... ;) where each equally-sized
>>  block of the array has a single bit of information - namely, if that
>>  block has been written recently (which means it was dirty) or not.
>>  So for each block (which is in no way related to chunk size etc!)
> 
> Aren't these blocks-represented-by-a-bit-in-the-bitmap called chunks,
> too? Sorry for the confusion.

Well yes, but I especially avoided using of *this* "chunk" in my sentence ;)
In any case, the chunk as in "usual-raid-chunk-size" and "chunk-represented-
by-a-bit-in-the-bitmap" are different chunks, the latter consists of one
or more the formers.  Oh well.

>>  This has nothing to do with window between first and second disk
>>  failure.  Once first disk fails, bitmap is of no use anymore,
>>  because you will need a replacement disk, which has to be
>>  resyncronized in whole,
> 
> Yes, that makes sense. Still sounds useful, since a lot of my
> "failures" have been of the intermittent (SATA cables / connectors,
> port resets, slow bad-sector remap) variety.

Yes, you're right.  Annoying stuff, and bitmaps definitely helps here.

>>  If the bitmap is unaccessible, it's handled as there was no bitmap
>>  at all - ie, if the array was dirty, it will be resynced as a whole;
>>  if it was clean, nothing will be done.
> 
> Ok, good to hear. In theory that's the sane mode of operation, in
> practice it might just have been that the array refuses to assemble
> without its bitmap.

I had the opposite here.  Due to various reasons, including operator
errors, bugs in mdadm and md kernel code, and probably phases of the
Moon, after creating a bitmap on a raid array and rebooting, I were
discovering that the bitmap isn't here anymore, -- it's gone.  It all
was down to the case when bitmap data (information about bitmap
presence and location) were not passed to the kernel correctly - either
because I forgot to specify it in a config file, or because mdadm didn't
pass that info in several cases or because with that superblock version
bitmaps were handled incorrectly....

>>  Yes, external bitmaps are supported and working.  It doesn't mean
>>  they're faster however - I tried placing a bitmap into a tmpfs (just
>>  for testing) - and discovered about 95% drop in speed
> 
> Interesting ... what are external bitmaps good for, then?

I had no time to investigate, and now I don't have a hardware to test
again.  In theory it should work, but I guess only a few people are
using them if at all - most are using internal bitmaps.

/mjt
