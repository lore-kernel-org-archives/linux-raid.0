From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 23 Jan 2014 06:24:39 -0600
Message-ID: <52E10A07.3070302@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140123091319.GB2306@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/23/2014 3:13 AM, Marc MERLIN wrote:
> On Wed, Jan 22, 2014 at 08:37:49PM -0600, Stan Hoeppner wrote:
>> On 1/22/2014 11:48 AM, Marc MERLIN wrote:
>> ...
>>> If crypt is on top of raid5, it seems (and that makes sense) that no
>>> encryption is neded for the rebuild. However in my test I can confirm that
>>> the rebuild time is exactly the same. I only get 19MB/s of rebuild bandwidth
>>> and I think tha'ts because of the port multiplier.
>>
>> I didn't address this earlier as I assumed you, and anyone else reading
>> this thread, would do a little background reading and realize no SATA
>> PMP would behave in this manner.  No SATA PMP, not Silicon Image, not
>> Marvell, none of them, will limit host port throughput to 20MB/s.  All
>> of them achieve pretty close to wire speed throughput.
> 
> I haven't answered your other message, as I'm getting more data to do
> so, but I can assure you that this is incorrect :)
> 
> I've worked with 3 different PMP boards and three different SATA cards
> over the last 6 years (sil3124, 3132, and marvel), and got similarly
> slow results on all of them.
> The marvel was faster than sil3124 but it stopped being stable in
> kernels in the last year and fell unsupported (no one to fix the bugs),
> so I went back to sil3124.
>
> I'm not saying that they can't go faster somehow, but in my experience
> that has not been the case.

Others don't seem to be having such PMP problems.  Not in modern times
anyway.  Maybe it's just your specific hardware mix.

If eliminating the PMP increased your read-only resync speed by a factor
of 5x, I'm elated to be wrong here.

> In case you don't believe me, I just switched my drives from the PMP to
> directly connected to the motherboard and a marvel card, and my rebuild
> speed changed from 19MB/s to 99MB/s.
> (I made no other setting changes, but I did try your changes without
> saving them before and after the PMP change and will report below)

Why would you assume I wouldn't believe you?

> You also said:
>> Ok, now I think we're finally getting to the heart of this.  Given the
>> fact that you're doing full array encryption, and after reading your bio
>> on your website the other day, I think I've been giving you too much
>> credit.  So let's get back to md basics.  Have you performed any md
>> optimizations?  The default value of
> 
> Can't hurt to ask, you never know if I may have forgotten or not know about one.
> 
>> /sys/block/mdX/md/stripe_cache_size
>> is 256.  This default is woefully inadequate for modern systems, and
>> will yield dreadfully low throughput.  To fix this execute
>> ~$ echo 2048 > /sys/block/mdX/md/stripe_cache_size
> 
> Thanks for that one.
> It made no speed difference on the PMP or without, but can't hurt to do anyway.

If you're not writing it won't.  The problem here is that you're
apparently using a non-destructive resync as a performance benchmark.
Don't do that.  It's representative of nothing but read-only resync speed.

Increasing stripe_cache_size above the default as I suggested will
ALWAYS increase write speed, often by a factor of 2-3x or more on modern
hardware.  It should speed up destructive resyncs considerably, as well
as normal write IO.  Once your array has settled down after the inits
and resyncs and what not, run some parallel FIO write tests with the
default of 256 and then with 2048.  You can try 4096 as well, but with 5
rusty drives 4096 will probably cause a slight tailing off of
throughput.  2048 should be your sweet spot.  You can also just time a
few large parallel file copies.  You'll be amazed at the gains.

The reason is simply that the default of 256 was selected some ~10 years
ago when disks were much slower.  Increasing this default has been a
topic of much discussion recently, because bumping it up increases
throughput for everyone, substantially, even with 3 disk RAID5 arrays.

>> To specifically address slow resync speed try
>> ~$ echo 50000 > /proc/sys/dev/raid/speed_limit_min
> 
> I had this, but good reminder.
> 
>> And you also likely need to increase readahead from the default 128KB to
>> something like 1MB (in 512KiB units)
>>
>> ~$ blockdev --setra 2048 /dev/mdX
> 
> I had this already set to 8192, but again, thanks for asking too.
>
>> Since kernel 2.6.23 Linux does on demand readahead, so small random IO
>> won't trigger it.  Thus a large value here will not negatively impact
>> random IO.  See:  http://lwn.net/Articles/235181/
>>
>> Please test and post your results.  I don't think your problems have
>> anything to do with crypto.  However, after you get md running at peak
>> performance you then may start to see limitations in your crypto setup,
>> if you have chosen to switch to dmcrypt above md.
> 
> Looks like so far my only problem was the PMP.

That's because you've not been looking deep enough.

> Thank you for your suggestions though.

You're welcome.

> Back to my original questions:
>> Question #1:
>> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
>> (raid5 first, and then dmcrypt)
>> I used:
>> cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/sd[mnopq]1
>  
> As you did point out, the array will be faster when I use it because the
> encryption will be sharded over my CPUs, but rebuilding is going to create 5 encryption
> threads whereas if md5 is first and encryption is on top, rebuilds do
> not involve any encryption on CPU.
> 
> So it depends what's more important.

Yep.  If you post what CPU you're using I can probably give you a good
idea if one core is sufficient for dmcrypt.

I'll also reiterate that encrypting a 16TB array device is silly when
you can simply carve off an LV for files that need to be encrypted, and
run dmcrypt only against that LV.  You can always expand an LV.  This is
a huge performance win for all other files, such your media collections,
which don't need to be encrypted.

>> Question #2:
>> In order to copy data from a working system, I connected the drives via an external
>> enclosure which uses a SATA PMP. As a result, things are slow:
>>
>> md5 : active raid5 dm-7[5] dm-6[3] dm-5[2] dm-4[1] dm-2[0]
>>       15627526144 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [UUUU_]
>>       [>....................]  recovery =  0.9% (35709052/3906881536) finish=3406.6min speed=18939K/sec
>>       bitmap: 0/30 pages [0KB], 65536KB chunk
>>
>> 2.5 days for an init or rebuild is going to be painful.

With stripe_cache_size=2048 this should drop from 2.5 days to less than
a day.

>> I already checked that I'm not CPU/dmcrpyt pegged.
>>
>> I read Neil's message why init is still required:
>> http://marc.info/?l=linux-raid&m=112044009718483&w=2
>> even if somehow on brand new blank drives full of 0s I'm thinking this could be faster
>> by just assuming the array is clean (all 0s give a parity of 0).
>> Is it really unsafe to do so? (actually if you do this on top of dmcrypt
>> like I did here, I won't get 0s, so that way around, it's unfortunately
>> necessary).
> 
> Still curious on this: if the drives are brand new, is it safe to assume
> t> hey're full of 0's and tell mdadm to skip the re-init?
> (parity of X x 0 = 0)

No, for a few reasons:

1.  Because not all bits are always 0 out of the factory.
2.  Bad sectors may exist and need to be discovered/remapped
3.  With the increased stripe_cache_size, and if your CPU turns out to
be fast enough for dmcrypt in front of md, resync speed won't be as much
of an issue, eliminating your motivation for skipping the init.


-- 
Stan

