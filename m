From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid5 write latency is 10x the drive latency
Date: Sun, 16 Mar 2014 11:10:50 +0200
Message-ID: <CAGRgLy5BwxJ02m4yV=-emjTK=ouTqP23HHD=BSo38yaZE4H3ow@mail.gmail.com>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<20140305155811.652628e6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140305155811.652628e6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Yair Hershko <yair@zadarastorage.com>, Peter Grandi <pg@lxra2.for.sabi.co.uk>
List-Id: linux-raid.ids

Thank you, Neil and Peter, for your comments.

On Wed, Mar 5, 2014 at 6:58 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 3 Mar 2014 15:28:02 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>>
>> We are testing a fully random 8K write IOMETER workload on a raid5 md,
>> composed of 5 drives. Initial resync is fully completed.
>>
>> We see that the write latency that the MD device demonstrates is 10
>> times the latency of individual drives. Typical iostat output is:
>>
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> dm-28             0.00     0.00  235.05  883.51   940.21  3448.97
>> 7.85    77.88   62.86   50.68   66.10   0.67  75.46
>> dm-30             0.00     0.00  230.93  881.44   923.71  3440.72
>> 7.85    68.90   55.31   59.45   54.22   0.70  77.94
>> dm-32             0.00     0.00  185.57  846.39   742.27  3300.52
>> 7.84    59.39   51.10   44.98   52.44   0.56  57.73
>> dm-33             0.00     0.00  232.99  864.95   931.96  3374.74
>> 7.85    46.72   34.92   31.06   35.96   0.45  49.48
>> dm-35             0.00     0.00  265.98  895.88  1063.92  3498.45
>> 7.85    62.14   46.43   41.09   48.01   0.56  65.15
>> md4               0.00     0.00    0.00  263.92     0.00 12338.14
>> 93.50     0.00    0.00    0.00    0.00   0.00   0.00
>> dm-37             0.00     0.00    0.00  263.92     0.00 12338.14
>> 93.50   128.54  505.81    0.00  505.81   3.89 102.68
>>
>> dm-28,30,32,33,35 are MD individual devices.
>> dm-37 is a linear Device Mapper device stacked on top of md4, to see
>> the MD performance (for some reason MD doesn't show r/w latencies in
>> iostat).
>>
>> I understand that with RMW that raid5 is doing, we can expect 2x of
>> the drive latency (1x to load the stipe-head, 1x to update the
>> required stripe-head blocks on disk). However, I am trying to
>> understand where the rest of the latency is coming from.
>>
>> One thing I see is that with such random workload, raid5d thread is
>> busy updating the bitmap in stack like this:
>> [<ffffffff81569f05>] md_super_wait+0x55/0x90
>> [<ffffffff815709e8>] bitmap_unplug.part.21+0x158/0x160
>> [<ffffffff81570a12>] bitmap_unplug+0x22/0x30
>> [<ffffffffa0702f57>] raid5d+0xe7/0x570 [raid456]
>> [<ffffffff8156344d>] md_thread+0x10d/0x140
>> [<ffffffff8107f050>] kthread+0xc0/0xd0
>> [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> So I understand that given a single-threaded nature of raid5, when
>> raid5d() is doing the bitmap update, it delays the processing of all
>> stripe-heads.
>>
>> So I commented out the bitmap_unplug call, just to see if there is
>> some other problem. Things are better now, but still:
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> dm-27             0.00     0.00  254.74 1317.89  1018.95  5271.58
>> 8.00   137.68   87.55   92.98   86.50   0.49  77.05
>> dm-29             0.00     0.00  269.47 1345.26  1077.89  5381.05
>> 8.00   146.44  104.24   81.36  108.82   0.52  83.79
>> dm-32             0.00     0.00  267.37 1345.26  1069.47  5381.05
>> 8.00   130.10   94.34   73.72   98.44   0.48  76.63
>> dm-33             0.00     0.00  267.37 1343.16  1069.47  5372.63
>> 8.00    87.61   54.40   52.19   54.84   0.34  55.16
>> dm-36             0.00     0.00  271.58 1355.79  1086.32  5423.16
>> 8.00   136.33   97.45   81.77  100.59   0.47  76.63
>> md4               0.00     0.00    0.00  454.74     0.00 21911.58
>> 96.37     0.00    0.00    0.00    0.00   0.00   0.00
>> dm-37             0.00     0.00    0.00  454.74     0.00 21911.58
>> 96.37   132.05  330.82    0.00  330.82   2.31 105.26
>
> Peter already hinted something along these lines, but to make it explicit:
>
> Consider the wkB/s column:  The number for md4 is about the same as the sum
>  of any 4 numbers for dm-27..dm-36.  This is expected as the writes will be
>  spread evenly and parity writes will be added.
> Now consider the rkB/s column in comparison.  We see about 1/5 the reads to
> writes.  For a read-modify-write cycle you would see equal numbers.  The 1:5
> ratio suggests that on average one device is read for each whole-stripe write.
>
> Now look at w/s.  Each device sees about 1300 write requests.  md4 sees about
> 450.  So the array sees 4 times the kB/sec, but 1/3 the ops per sec.  This
> averages out at the operations seen by the array being 12 times the
> size of the requests seen by the devices.  The device requests are at least
> 4K, so the array requests are at least 48K.
> A 48K write to a 5-drive raid5 with 8k chunks will fill 1.5 full stripes.  No
> wonder most of the writes don't require a read.
>
> I don't really know how to interpret the *await fields.  When I care about
> latency I prefer to run blktrace and extract out the actual events I'm
> interested in.  Then find the latency for each and graph them,
>
> By the way, commenting out bitmap_unplug effectively removes the bitmap
> protection.  It allows data to be written while the bit is still clear in the
> bitmap so in the case of a crash the resync might not fix everything.
>
> NeilBrown
>
>
>
>>
>> So it looks like about ~100ms are lost somewhere (assuming ~100ms +
>> ~100ms for reading and writing the stripe head).
>>
>> I tried to profile raid5d looking for some other blocking operation it
>> might be doing. And I don't see one. Typically - without the bitmap
>> update - raid5 call takes 400-500us, so I don't understand how the
>> additional ~100ms of latency is gained. (With the bitmap update,
>> raid5d is significantly delayed by it, which delayes all the
>> processing). Do you have an idea why there is a latency difference?
>>
>> Thanks,
>> Alex.
>
