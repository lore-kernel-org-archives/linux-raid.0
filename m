From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: raid6's using not the best bandwidth method && raid6 algo is significantly slower in x86_64.
Date: Sun, 16 Nov 2008 23:18:54 +0700
Message-ID: <43d009740811160818v49c530b1r9e01b79c1d9dcfdd@mail.gmail.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi!

Recently I've decided to give a try to x86_64 version of mine distro
of choice (subject to change).
I prefer using own compiled kernels, so I know that in both x86_32 and
x86_64 modes .configs are very similar to each other.

The first quote is x86_32 kernel's dmesg (2.6.27.6-1khz i686):

    [    0.000000] Linux version 2.6.27.6-1khz
(poige@arch.localdomain) (gcc version 4.2.4)
    [    0.021589] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor
6000+ stepping 03

    [    0.092818] Total of 2 processors activated (12061.15 BogoMIPS).

    [    0.093095] xor: automatically using best checksumming function: pIII_sse
    [    0.097988]    pIII_sse  :  9164.000 MB/sec
    [    0.098027] xor: using function: pIII_sse (9164.000 MB/sec

    [    2.392055] raid6: int32x1   1121 MB/s
    [    2.409048] raid6: int32x2   1226 MB/s
    [    2.412224] input: AT Translated Set 2 keyboard as /class/input/input0
    [    2.426040] raid6: int32x4   1191 MB/s
    [    2.443066] raid6: int32x8    882 MB/s
    [    2.460013] raid6: mmxx1     2453 MB/s
    [    2.477014] raid6: mmxx2     4574 MB/s
    [    2.494024] raid6: sse1x1    2441 MB/s
    [    2.511014] raid6: sse1x2    4222 MB/s
    [    2.528013] raid6: sse2x1    4187 MB/s
    [    2.545004] raid6: sse2x2    5562 MB/s
    [    2.545042] raid6: using algorithm sse2x2 (5562 MB/s)

And now follows x86_64:

    [    0.000000] Linux version 2.6.27.6-64_1khz (root@archlive) (gcc
version 4.3.1 (GCC) )
    [    0.019180] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor
6000+ stepping 03

    [    0.091750] Total of 2 processors activated (12061.66 BogoMIPS).

    [    0.092073] xor: automatically using best checksumming
function: generic_sse
    [    0.096986]    generic_sse:  9192.000 MB/sec
    [    0.097024] xor: using function: generic_sse (9192.000 MB/sec)

    [    2.583571] md: raid0 personality registered for level 0
    [    2.583614] md: raid1 personality registered for level 1
    [    2.600025] raid6: int64x1   2722 MB/s
    [    2.617010] raid6: int64x2   3660 MB/s
    [    2.634006] raid6: int64x4   3265 MB/s
    [    2.651012] raid6: int64x8   2593 MB/s
    [    2.668034] raid6: sse2x1    1476 MB/s
    [    2.685021] raid6: sse2x2    2316 MB/s
    [    2.702022] raid6: sse2x4    3175 MB/s
    [    2.702060] raid6: using algorithm sse2x4 (3175 MB/s)

So, there're 2 strange things in those dmesgs. The first one might be
unrelated to Linux RAID but affects it -- have you noticed that in
x86_64, raid6 algorithm is ~ 50 % slower, than in x86_32? Is that due
to not too optimized code for x86_64 mode? And the second -- why is
raid6 using algorithm sse2x4 (3175 MB/s), whereas int64x2 gives
slightly better (~ 15 %) throughput -- 3660 MB/s?

Has anyone on the list similar observations? Can gcc's version
difference affect so much? I doubt that, but I can try build x86_32
with gcc 4.3.1 (as x86_64 was).

-- 
End of message. Next message?
