From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-5 Parity calculation
Date: Fri, 15 Oct 2004 10:57:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16751.8299.762282.747032@cse.unsw.edu.au>
References: <1097778662.2926.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yinan Liu on Thursday October 14
To: Yinan Liu <yinan@ele.uri.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 14, yinan@ele.uri.edu wrote:
> Hi, I am a new guy for a Linux programming. I got a question for a
> software RAID-5 parity calculation. 
> 
> If we suppose for data block D1, D2, D3, D4 with a parity block P, When
> some data block is changed, P will be changed. I am not so clear how
> does Linux md handle the parity re calculating, when data changed . 
> 
> Suppose there will be three cases, 
> 
> 1. sequential write, is that get new P' directly with new data D1', D2',
> D3' and D4' or need read D1-4 out from disk doing the normal operation. 
> 
> 2. if we changed there blocks, D1',D2' and D3', does md read D1, D2, D3
> out to rebuild P or just read D4 out from disk and rebuild P with D1',
> D2', D3' and D4. 
> 
> 3. is the simple case, just change one block. 
> 
> Thanks a lot, if some can help me get understand it. 

There are two ways raid5 can update the parity block:

 1/ read the old parity block and the old data blocks for all changed
 blocks, do the appropriate calculation, and write out the new parity
 and new data blocks.  This is called READ_MODIFY_WRITE.
 2/ read all data blocks in the stripe that *aren't* being changed,
 calculate the new parity from those and the changed blocks, and write
 out the new parity and new blocks.  This is called RECONSTRUCT_WRITE.

Both require the same number of writes, but possibly different numbers
of reads.  Having some blocks already in the cache may also affect the
number of reads required.
raid5 delays processing stripes as long as possible (but no longer) in
the "hope" of gathering multiple updates in a single stripe.  It then
calculates how many reads will be needed to updated the parity using
each mechanism, and chooses the mechanism that results in the fewest reads.

NeilBrown
