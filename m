From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Read-Balancing
Date: Mon, 2 Feb 2004 15:56:26 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16413.55418.495610.479519@notabene.cse.unsw.edu.au>
References: <200401311747.23263.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Corey McGuire on Saturday January 31
To: Corey McGuire <coreyfro@coreyfro.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 31, coreyfro@coreyfro.com wrote:
> Hey folks,
> 
> Quick question.
> 
> I have been reading up on read-balancing, and I understand that 2.6
> has been tuned to have the drive head closest to the data perform
> the read to reduce seak times. This is neat, but can it prevent two
> disks from working together to read the same, nonfragmented file?
> Did read-balancing ever allow the ability for mirrored drives to
> work together on a sequential read?  Seams that in a large read,
> each drive in a mirror could pick up a piece to read, and then
> reassembled the sequential read in RAM. 

It is not trivial to get the two drives to work together on a single
large read.
To get any performance value, you would either need to align the
read request with tracks (you read that track, I read the next track,
and so on) which is not really possible with modern drives, or you
would need each drive to read several tracks.
I'm not sure how big a track is on modern drives, but I suspect it is
several 10s of Kilobytes.  So you you probably need a 100K read on
each drive before you could see any benefit.

There is code in 2.4 to limit each drive to 128 sectors (64k) before
it must try a different drive.  This code seems to have
disappeared from 2.6.
I have no idea if it ever did anything useful.
If you are really interested you could try doing some speed testing to
see if you could demonstrate a improvement in throughput by
alternating requests between two drives.

NeilBrown


> 
> Also, does this prevent balancing multiple separate reads in the same file, or will the idle disk seak and read while the drive closer to the action is busy?  Assuming, of course, the data isn't in cache.
> 
> Just therory stuff, really, but a curiosity none the less.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
