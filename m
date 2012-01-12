From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Thu, 12 Jan 2012 10:33:51 +0000
Message-ID: <20238.46863.861112.697884@tree.ty.sabi.co.UK>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
	<20110501082717.5116e575@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
In-Reply-To: <20110501082717.5116e575@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> * Can Linux MD do "abbreviated" read-modify-write RAID6
>> updates like for RAID5? That is where not the whole stripe is
>> read in, modified and written, but just the block to be
>> updated and the parity wblocks.

> No.  (patches welcome).

>> * When reading or writing part of RAID[456] stripe for
>> example smaller than a sector, what is the minimum unit of
>> transfer with Linux MD? The full stripe, the chunk containing
>> the sector, or just the sector containing the bytes to be
>> written or updated (and potentially the parity sectors)? I
>> would expect reads to always read just the sector, but not so
>> sure about writing.

> 1 "PAGE" - normally 4K.

In retrospect I should have expected this, the "page cache"
seems to matter here :-).

Recently I was thinking again about the above, please let know
some more details.

To make some questions unambiguous, let's imagine a setup with a
disk with 512B sectors, an architecture page size of 4KiB, an MD
chunk size of 16KiB, and an array with 6 drives.

* Does MD consider a chunk*width "stripe" (96KiB) as made of a
  set of page*width "stripelets" (24KiB) *in general*? In other
  words, is the "fundamental" unit (if any) of MD array-wide
  work the "stripe" or "stripelet"?

* With RAID6, are the two parities computed per "stripelet" or
  per "stripe" (that is, are parity blocks 4KiB or 16Kib)? Does
  this make a difference?

* With RAID6, does MD perform RMW on a "stripe" of a "stripelet"?
