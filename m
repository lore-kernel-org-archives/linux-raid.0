From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Mon, 3 Mar 2008 01:17:34 +0100
Message-ID: <bb145bd20803021617j1b15c667j96d3ee12829ee75a@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <47CAC5BF.6060600@msgid.tls.msk.ru>
	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
	 <47CAF30F.7040502@msgid.tls.msk.ru>
	 <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
	 <47CB228D.5020709@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CB228D.5020709@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  I highly doubt chunk size makes any difference.  Bitmap is the primary
>  suspect here.

Some tests:

raid5, chunk size goes from 16k to 1m. arrays created with --assume-clean

dd-tests
========

read / write 4GB in 4-chunk blocks directly on the md device.

dd-read
-------
unaffected by bitmap as expected
gets MUCH better with inc. chunk size			 71 -> 219 MS/s
reads go up near theoretical bus maximum (266MB/s)
the maximum total reached via parallel single-disk reads is 220 MB/s

Conclusion: reads are fine

dd-write
--------
with bitmap: gets SLOWLY worse with inc. chunk size	 30 ->  27 MB/s
without bitmap: gets MUCH worse with inc chunk size	100 ->  59 MB/s

Conclusion: needs explanation / tuning

even omitting the bitmap the writes just touch 100 MB/s, more like 80
on any chunk size with nice reads.
why would it get worse? Anything tunable here?
the maximum total reached via parallel single-disk writes is 150 MB/s


mke2fs-tests
============

create ext3 fs with correct stride, get a 10-second vmstat average 10
seconds in and abort the mke2fs

with bitmap: goes down SLOWLY from 64k chunks		 17 ->  13 MB/s
without bitmap: gets MUCH worse with inc. chunk size	 80 ->  34 MB/s

Conclusion: needs explanation / tuning

the maximum total reached via parallel single-disk mke2fs is 150 MB/s.


Comments welcome.

Next step: smaller bitmap
When the performance seems normal I'll revisit the responsiveness-issue.

>  Umm..  You mixed it all ;)
>  Bitmap is a place (stored somewhere... ;) where each equally-sized
>  block of the array has a single bit of information - namely, if that
>  block has been written recently (which means it was dirty) or not.
>  So for each block (which is in no way related to chunk size etc!)

Aren't these blocks-represented-by-a-bit-in-the-bitmap called chunks,
too? Sorry for the confusion.

>  This has nothing to do with window between first and second disk
>  failure.  Once first disk fails, bitmap is of no use anymore,
>  because you will need a replacement disk, which has to be
>  resyncronized in whole,

Yes, that makes sense. Still sounds useful, since a lot of my
"failures" have been of the intermittent (SATA cables / connectors,
port resets, slow bad-sector remap) variety.

>  If the bitmap is unaccessible, it's handled as there was no bitmap
>  at all - ie, if the array was dirty, it will be resynced as a whole;
>  if it was clean, nothing will be done.

Ok, good to hear. In theory that's the sane mode of operation, in
practice it might just have been that the array refuses to assemble
without its bitmap.

>  Yes, external bitmaps are supported and working.  It doesn't mean
>  they're faster however - I tried placing a bitmap into a tmpfs (just
>  for testing) - and discovered about 95% drop in speed

Interesting ... what are external bitmaps good for, then?

Thank you, I appreciate your patience.

C.
