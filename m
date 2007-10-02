From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Raid performance problems (pdflush / raid5 eats 100%)
Date: Tue, 02 Oct 2007 19:11:15 +0200
Message-ID: <87odfhl9vw.fsf@informatik.uni-tuebingen.de>
References: <87sl4tlefa.fsf@informatik.uni-tuebingen.de>
	<Pine.LNX.4.64.0710021218490.10536@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710021218490.10536@p34.internal.lan> (Justin
	Piszcz's message of "Tue, 2 Oct 2007 12:19:20 -0400 (EDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> Have you tried a 1024k stripe and 16384k stripe_cache_size?
>
> I'd be curious what kind of performance/write speed you get with that
> configuration.
>
> Justin.

stripe_cache_size is not in KiB of memory but in multiples of some
internal structures. So 16384 * 4 raids is ~1.6GB ram. We only have
2GB ram in the system so this is very near an OOM just for the stripe
cache:

Mem:   2062468k total,  1735048k used,   327420k free,     4096k buffer
Swap:        0k total,        0k used,        0k free,     9924k cached

1 Thread:
 9442 root      16   0     0    0    0 R   73  0.0   3:33.89 pdflush
 9590 root      10  -5     0    0    0 S   57  0.0   1:29.73 md0_raid5
 9747 root      25   0 28364 1392  184 R   85  0.1   1:06.09 iozone
  257 root      10  -5     0    0    0 D   23  0.0   4:47.50 kswapd1
  256 root      10  -5     0    0    0 S   12  0.0   4:11.17 kswapd0

2 Threads:
  257 root      11  -5     0    0    0 D   27  0.0   4:55.46 kswapd1
 9442 root      16   0     0    0    0 S   23  0.0   4:49.65 pdflush
  256 root      10  -5     0    0    0 S    9  0.0   4:26.57 kswapd0
 9590 root      10  -5     0    0    0 R   40  0.0   2:36.91 md0_raid5
 9596 root      10  -5     0    0    0 S   35  0.0   0:50.62 md1_raid5
 9487 root      15   0     0    0    0 S   35  0.0   0:37.14 pdflush
 9759 root      18   0 28360 1420  216 R   59  0.1   0:11.61 iozone
 9758 root      18   0 28360 1420  216 R   70  0.1   0:10.17 iozone

With 4 raid5s:
           write  rewrite read   reread
1 Thread : 193887 196092  365965 401978  <-- use 1 raid5
2 Threads: 221221 255069  430061 365904  <-- use 2 raid5
4 Threads: 238220 257221  395603 409954  <-- use 4 raid5


With just 1 raid5 (and more free mem):

2 Threads:
 9590 root      10  -5     0    0    0 R   93  0.0   7:45.04 md0_raid5
 9487 root      16   0     0    0    0 S   27  0.0   5:13.43 pdflush
  257 root      10  -5     0    0    0 S    5  0.0   6:28.48 kswapd1
  256 root      10  -5     0    0    0 S    5  0.0   5:33.40 kswapd0
 9818 root      18   0 28364 1416  208 R   56  0.1   0:47.70 iozone
 9819 root      18   0 28364 1416  208 D   62  0.1   0:46.58 iozone
         
           write  rewrite read   reread
1 Thread : 206299 201120  400244 390185
2 Threads: 210888 202785  411502 400532
4 Threads: 200829 145307  400252 395568

MfG
        Goswin
