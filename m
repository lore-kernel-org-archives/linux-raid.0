From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 09:12:42 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15965.15322.459068.818409@notabene.cse.unsw.edu.au>
References: <3E5D078C.72A523AE@SteelEye.com>
	<200302261915.h1QJFfS17808@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Wednesday February 26
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Some observations on the idea of an intent-logging bitmap.

1/ You don't want or need very fine granularity.  The value of this is
   to speed up resync time.  Currently it is limited by drive
   bandwidth.  If you have lots of little updates due to fine
   granularity, you will be limited by seek time.

   One possibly reasonable approach would be to pick a granulatity
   such that it takes about as long to read or write a chunk and it
   would to seek to the next one.  This probably means a few hundred
   kilobytes.  i.e. one bit in the bitmap for every hundred K.
   This would require a 125K bitmap for a 100Gig drive.

   Another possibility would be a fixed size bitmap - say 4K or 8K.

   An 8K bitmap used to map a 100Gig drive would be 1.5Meg per bit.
 
   This may seem biggish, but if your bitmap were sparse, resync would
   still be much much faster, and if it were dense,  having a finer
   grain in the bitmap isn't going to speed things up much.

2/ You cannot allocate the bitmap on demand.  
   Demand happens where you are writing data out, and when writing
   data out due to high memory pressure, kmalloc *will* fail.
   Relying on kmalloc in the write path is BAD.  That is why we have
   mempools which pre-allocate.
   For the bitmap, you simply need to pre-allocate everything.

3/ Internally, you need to store a counter for each 'chunk' (need a
   better word, this is different from the raid chunksize, this is the
   amount of space that each bit refers to).
   The counter is needed so you know when the bit can be cleared.
   This too must be pre-allocated and so further limits the size of
   your bitmap.

   16 bit counters would use less ram and would allow 33553920 bytes 
   (65535 sectors) per 'chunk' which, with an 8K bitmap, puts an upper
   limit of 2 terabytes per device, which I think is adequate. (that's
   per physical device, not per raid array).

   Or you could just use 32 bit counters.

4/ I would use device plugging to help reduce the number of times you
   have to write the intent bitmap.
   When a write comes in, you set the bit in the bitmap, queue the
   write on a list of 'plugged' requests, and mark the device as
   'plugged'.  The device will eventually be unplugged, at which point
   you write out the bitmap, then release all the requests to the
   lower devices.

   You could optimise this a bit, and not bother plugging the device
   if it wasn't already plugged, and the request only affected bits
   that were already set.


NeilBrown
