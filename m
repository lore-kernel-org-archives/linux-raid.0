From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 10 Aug 2004 17:37:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4119400A.40307@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com>	<16590.38597.170409.499394@cse.unsw.edu.au>	<40D9FA9E.9010003@steeleye.com>	<40F7E50F.2040308@steeleye.com> <16649.61212.310271.36561@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16649.61212.310271.36561@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I've implemented the improvements that you've suggested below, and 
preliminary tests are showing some very good results!

The latest patches are available at:

http://www.parisc-linux.org/~jejb/md_bitmap/

Further details below...

Thanks,
Paul


Neil Brown wrote:
> It's looking a lot better.  I can start focussing on deeper issues
> now.
> 
> It really bothers me that all the updates are synchronous - that isn't
> a good approach for getting good performance.

Yes, that's quite true. In fact, in my simple write performance tests I 
used to see a slowdown of around 30% with the bitmap file...now, the 
difference is not even measurable! (This is with the bitmap file located 
on a dedicated disk, in order to reduce disk head movement, which tends 
to degrade performance).


> This is how I think it should happen:
> 
>   When a write request arrives for a block where the corresponding bit
>   is already set on disk, continue with the request (as currently
>   happens).
> 
>   When a write request arrives for a block where the corresponding bit 
>   is *not* set on disk, set the bit in ram (if not already set), queue
>   the write request for later handling, and queue the bitmap block to
>   be written.  Also mark the queue as "plugged".
>
>   When an unplug request comes, Send all queued bitmap blocks to disk,
>   then wait for them all to complete, then send all queue raid write
>   requests to disk.
> 
>   When a write request completes, decrement the corresponding
>   counter but don't clear the "shadow" bit if the count hits zero.
>   Instead flag the block as "might have unsynced-zeros".
> 
>   The write-back thread slowly walks around the bitmap looking for
>   blocks which might have an unsynced zero.  They are checked to see
>   if they still do.  If they do, the disk-bit is cleared and the
>   disk-block is queued for writing.
> 
> 
> There might need to be a couple of refinements to this, but I think it
> is the right starting point.

I've implemented more or less what you've described above in this latest 
patch.

> With this approach you wouldn't need the "bitmap_update" in r1bio_s as
> the write-back daemon doesn't have a list of things to do, but instead
> it periodically scans to see what needs to be done.

Yes, getting rid of the bitmap_update structure was a very good idea. 
The code is much cleaner without that...

