From: Spelic <spelic@shiftmail.org>
Subject: Re: Absymal performance of O_DIRECT write on parity raid
Date: Wed, 05 Jan 2011 12:51:47 +0100
Message-ID: <4D245B53.9090505@shiftmail.org>
References: <4D1D5D7A.6010804@shiftmail.org>
 <AANLkTinm=1Nu2L3dLBqBsZ+QKu=XJN=SQL0wWAB2JvOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTinm=1Nu2L3dLBqBsZ+QKu=XJN=SQL0wWAB2JvOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/31/2010 06:36 AM, Doug Dumitru wrote:

>     With direct IO, the
>  IO must complete and "sync" before dd continues.  Thus each 1M write
>  will do reads from 4 drives and then 2 writes.  I am not sure about
>  iostat not seeing this.  I ran this here against 8 SSDs.
>

I confirm. It is the stripe_cache doing that.
You need to raise the stripe cache to 32768, then do a little I/O the
first time (less than 32768*4k*number of disks) so the stripe cache fills up
Then do it again and you will see no reads.
I found how to clear that: bring stripe_cache_size to 32 then again to
32768. After that it will read again.

If you test that, it will probably be lightning fast for you because you
have SSDs.
So do mdstat -x 10 (10 seconds) so you will see a "frozen" summary; you
will see no reads.

Thanks for all your info, it's interesting stuff, and I confirm you are
right with parallelism: with fio with 20 threads doing random 1M direct
writes, the bandwitdh sums up proportionally like you say.

However:
I confirm that in my case, even when it DOESN'T read (stripe_cache
effect) sequential dd with O_DIRECT bs=1M is dog slow on my raid-5

What I see with iostat (I paid more attention now) is that, every other
second, the iostat -x 1 shows ZERO I/O and exactly one disk (below the
md raid) with 1 in avgqu-sz. I go to the /sys/block/<disk>  in question
and I can see it's an inflight write. That disk has 1 inflight write
100% of the time. This is for a while. After some time the disk changes,
now it's another disk of the array which has 1 inflight write 100% of
the time... It cycles through all disks of the array with this pattern:
[3] [2] [1] [0] [6] [4] (I am remapping it to device order in that array
from cat /proc/mdstat) I don't have a disk 5 in that array, maybe a
problem when I created it, if I had a disk "5" instead of disk "6" it
probably would have been 3 2 1 0 5 4 . I think it varies with the
position of either the data disk being written or the parity disk being
written.

My interpretation is that since it's a (direct and hence) sync I/O, MD
waits for completion of inflight writes before submitting another one,
and every certain number of requests there is one that stays stuck for
1-2 seconds and so everything freezes for 1-2 seconds. That's why it is
dog slow.

Now why does that inflight write take so long??

I thought this might be a bug of my controller, it's a 3ware 9650SE =
not the best for MD...

However please note that I see this problem in all raid-5 arrays on most
"bs" sizes (disappearing around bs=4M: bs=4M has a very variable speed
from attempt to attempt) and I do NOT see the problem in raid-10 or
raid-1 arrays, like when doing dd sequential O_DIRECT writes of bs=1M or
any other bs to a raid10 array and note that this is a very similar
scenario because:
- it is direct
- it is sync
- does not read
- generates IOPS to every disk enormously higher than in the problematic
raid-5 case I am reporting
still I don't see this problem of hanging requests, and dd goes very
fast at any block size (obviously faster for reasonably big sizes).

So I am wondering if there can be a contribution of MD to this "bug"...?

Thank you

