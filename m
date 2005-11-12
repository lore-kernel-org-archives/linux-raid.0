From: Neil Brown <neilb@suse.de>
Subject: Re: doubts about intent-logging
Date: Sat, 12 Nov 2005 22:26:01 +1100
Message-ID: <17269.53577.252401.852495@cse.unsw.edu.au>
References: <17268.41714.819859.813819@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Friday November 11
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 11, carlos@fisica.ufpr.br wrote:
> If I understand the Compendium (also known as mdadm manpage :-) ) the
> intent-logging bitmap is stored near the superblock when the name
> "internal" is specified. Does this mean that it'll be in the 128KB
> area of the superblock? If so, what happens if there isn't enough
> space? This is likely for medium-to-large arrays, say 500+GB with the
> default chunk 4K.

It will live in the 60K after the 4K superblock.  There will always be
at least 60K of space.
For 'internal' bitmaps, the default chunk size is not 4K, but is
chosen to be a power of two so that the bitmap is between 30K and 60K
(though the chunksize will never be less than 4K).

So there is always room.  Possible the Compendium needs to be
clarified in this respect.

> 
> About the size of the bitmap-chunk, wouldn't it be better if it were
> the size of a stripe? I ask this because I thought all IO to an array
> was done in multiples of the stripe size even if the write request is
> smaller.

IO is done in PAGE_SIZE units.  A whole stripe of pages are most
efficient for writes, but any individual PAGE can be accessed.  Thus
the smallest bitmap chunk size that is used is one page (4K).

> 
> What's the influence of intent-logging in the performance of a raid5
> array? It seems that it'll increase the number of writes, so a
> degradation is likely, no? This is important to decide if
> intent-logging is worth. I'd think that it's only worth for machines
> that crash often and leave the array dirty.

This is a very good question.  Testing this has been on my todo list
for weeks, and I may actually do some of it next week.  I suspect some
decrease in write speed.  I have no idea how much.

It's like insurance.... you know how insurance works:
  They pay you whenever your house burns down,
  You pay them whenever it doesn't.

Insurance always feels like money-down-the drain, until your house
burns down.  Then you are SO glad that you have it.
The question is "How painful is a full resync?"  If you can live with
it, then don't pay the price of intent-logging.

Intent-logging was written specifically for situations where resync
was very expensive (RAID1 with one mirror over a slow link).  It may
be useful in other situations.

NeilBrown
