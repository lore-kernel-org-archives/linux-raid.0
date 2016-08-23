From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Tue, 23 Aug 2016 14:26:04 -0500
Message-ID: <CAJvUf-ApkKJXm7Jjiq=gXY9b9RrEvwA5u35xrMUjX2x0btVL4g@mail.gmail.com>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-Dqesy2TJX7W-bPakzeDcOoNy0VoSWWM06rKMYMhyhY7g@mail.gmail.com>
 <CAFx4rwSQQuqeCFm+60+Gm75D49tg+mVjU=BnQSZThdE7E6KqPQ@mail.gmail.com>
 <CAJvUf-BoEJte8TF7_Su90CnjAiJ6q57m+PdGhxHA4cx5AEtxSg@mail.gmail.com>
 <51443e5b-3eef-c35f-8ee7-ad3e85e4e76c@redhat.com> <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwT0jt9NCu4imruPUhfAR71=cvHwx-kdZxoTniZaQcPByQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: Doug Ledford <dledford@redhat.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug & Doug,

Thank you for your helpful replies.  I merged both of your posts into
one, see inline comments below:

On Tue, Aug 23, 2016 at 2:10 PM, Doug Ledford <dledford@redhat.com> wrote:
> Of course.  I didn't mean to imply otherwise.  The read size is the read
> size.  But, since the OPs test case was to "read random files" and not
> "read random blocks of random files" I took it to mean it would be
> sequential IO across a multitude of random files.  That assumption might
> have been wrong, but I wrote my explanation with that in mind.

Yes, multiple parallel sequential reads.  Our test program generates a
bunch of big random files (file size has an approximately normal
distribution, centered around 500 MB, going down to 100 MB or so, up
to a few multi-GB outliers).  The file generation is a one-time thing,
and we don't really care about its performance.

The read testing program just randomly picks one of those files, then
reads it start-to-finish using "dd".  But it kicks off several "dd"
threads at once (currently 50, though this is a run-time parameter).
This is how we generate the read load, and I use iostat while this is
running to see how much read throughput I'm getting from the array.


On Tue, Aug 23, 2016 at 1:00 PM, Doug Ledford <dledford@redhat.com> wrote:
> This depends a lot on how you structured your raid array.  I didn't see
> your earlier emails, so I'm inferring from the "one out of 22 reads will
> be to the bad drive" that you have a 24 disk raid6 array?  If so, then
> that's 22 data disks and 2 parity disks per stripe.  I'm gonna use that
> as the basis for my next statement even if it's slightly wrong.

Yes, that is exactly correct, here's the relevant part of /proc/mdstat:

Personalities : [raid1] [raid6] [raid5] [raid4]

md0 : active raid6 sdl[11] sdi[8] sdx[23] sdc[2] sdo[14] sdn[13]
sdm[12] sdr[17] sdk[10] sdb[1] sdu[20] sdp[15] sdq[16] sds[18] sdt[19]
sdw[22] sdv[21] sda[0](F) sdj[9] sde[4] sdd[3] sdf[5] sdh[7] sdg[6]

      44005879808 blocks super 1.2 level 6, 512k chunk, algorithm 2
[24/23] [_UUUUUUUUUUUUUUUUUUUUUUU]

      bitmap: 0/15 pages [0KB], 65536KB chunk


> Doug was right in that you will have to read 21 data disks and 1 parity
> disk to reconstruct reads from the missing block of any given stripe.
> And while he is also correct that this doubles IO ops needed to get your
> read data, it doesn't address the XOR load to get your data.  With 19
> data disks and 1 parity disk, and say a 64k chunk size, you have to XOR
> 20 64k data blocks for 1 result.  If you are getting 200MB/s, you are
> actually achieving more like 390MB/s of data read, with 190MB/s of it
> being direct reads, and then you are using XOR on 200MB/s in order to
> generate the other 10MB/s of results.

Most of this morning I've been setting/unsetting/changing various
tunables, to see if I could increase the read speed.  I got a huge
boost by increasing the /sys/block/md0/md/stripe_cache_size parameter
from the default (256 IIRC) to 16384.  Doubling it again to 32k didn't
seem to bring any further benefit.  So with the stripe_cache_size
increased to 16k, I'm now getting around 1000 MB/s read in the
degraded state.  When the degraded array was only doing 200 MB/s, the
md0_raid6 process was taking about 50% CPU according to top.  Now I
have a 5x increase in read speed, and md0_raid6 is taking 100% CPU.
I'm still degraded by a factor of eight, though, where I'd expect only
two.

> 1) 200MB/s of XOR is not insignificant.  Due to our single thread XOR
> routines, you can actually keep a CPU pretty busy with this.  Also, even
> though the XOR routines try to time their assembly 'just so' so that
> they can use the cache avoiding instructions, this fails more often than
> not so you end up blowing CPU caches while doing this work, which of
> course effects the overall system.

While 200 MB/s of XOR sounds high, the kernel is "advertising" over
8000 MB/s, per dmesg:

[    6.386820] xor: automatically using best checksumming function:
[    6.396690]    avx       : 24064.000 MB/sec
[    6.414706] raid6: sse2x1   gen()  7636 MB/s
[    6.431725] raid6: sse2x2   gen()  3656 MB/s
[    6.448742] raid6: sse2x4   gen()  3917 MB/s
[    6.465753] raid6: avx2x1   gen()  5425 MB/s
[    6.482766] raid6: avx2x2   gen()  7593 MB/s
[    6.499773] raid6: avx2x4   gen()  8648 MB/s
[    6.499773] raid6: using algorithm avx2x4 gen() (8648 MB/s)
[    6.499774] raid6: using avx2x2 recovery algorithm

(CPU is: Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz.)

I'm assuming however the kernel does its testing is fairly optimal,
and probably assumes ideal cache behavior... so maybe actual XOR
performance won't be as good as what dmesg suggests... but still, 200
MB/s (or even 1000 MB/s, as I'm now getting), is much lower than 8000
MB/s...

Is it possible to pin kernel threads to a CPU?  I'm thinking I could
reboot with isolcpus=2 (for example) and if I can force that md0_raid6
thread to run on CPU 2, at least the L1/L2 caches should be minimally
affected...

> Possible fixes for this might include:
>         c) Creating a consolidated page cache/stripe cache (if we can read more
> of the blocks needed to get our data from cache instead of disk it helps
> reduce that IO ops issue)

I suppose this might be an explanation for why increasing the array's
stripe_cache_size gave me such a boost?

>         d) Rearchitecting your arrays into raid50 instead of big raid6 array

My colleague tested that exact same config with hardware raid5, and
striped the three raid5 arrays together with software raid1.  So
clearly not apples-to-apples, but he did get dramatically better
degraded and rebuild performance.  I do intend to test a pure software
raid-50 implementation.

> (or conversely has the random head seeks just gone so
> radically through the roof that the problem here really is the time it
> takes the heads to travel everywhere we are sending them).

I'm certain head movement time isn't the issue, as these are SSDs.  :)

On Tue, Aug 23, 2016 at 1:27 PM, Doug Dumitru <doug@easyco.com> wrote:
> Can you run an iostat during your degraded test, and also a top run
> over 20+ seconds with kernel threads showing up.  Even better would be
> a perf capture, but you might not have all the tools installed.  You
> can always try:
>
> perf record -a sleep 20
>
> then
>
> perf report
>
> should show you the top functions globally over the 20 second sample.
> If you don't have perf loaded, you might (or might not) be able to
> load it from the distro.

Running top for 20 or more seconds, the top processes in terms of CPU
usage are pretty static:

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 1228 root      20   0       0      0      0 R 100.0  0.0 562:16.83 md0_raid6
 1315 root      20   0    4372    684    524 S  17.3  0.0  57:20.92 rngd
  107 root      20   0       0      0      0 S   9.6  0.0  65:16.63 kswapd0
  108 root      20   0       0      0      0 S   8.6  0.0  65:19.58 kswapd1
19424 root      20   0  108972   1676    560 D   3.3  0.0   0:00.52 dd
 6909 root      20   0  108972   1676    560 D   2.7  0.0   0:01.53 dd
18383 root      20   0  108972   1680    560 D   2.7  0.0   0:00.63 dd


I truncated the output.  The "dd" processes are part of our testing
tool that generates the huge read load on the array.  Any given "dd"
process might jump around, but those four kernel processes are always
the top four.  (Note that before I increased the stripe_cache_size (as
mentioned above), the md0_raid6 process was only consuming around 50%
CPU.)

Here is a representative view of a non-first iteration of "iostat -mxt 5":


08/23/2016 01:37:59 PM
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           4.84    0.00   27.41   67.59    0.00    0.17

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy               0.00     0.40    0.80    0.60     0.05     0.00
83.43     0.00    1.00    0.50    1.67   1.00   0.14
sdz               0.00     0.40    0.00    0.60     0.00     0.00
10.67     0.00    2.00    0.00    2.00   2.00   0.12
sdd           12927.00     0.00  204.40    0.00    51.00     0.00
511.00     5.93   28.75   28.75    0.00   4.31  88.10
sde           13002.60     0.00  205.20    0.00    51.20     0.00
511.00     6.29   30.39   30.39    0.00   4.59  94.12
sdf           12976.80     0.00  205.00    0.00    51.00     0.00
509.50     6.17   29.76   29.76    0.00   4.57  93.78
sdg           12950.20     0.00  205.60    0.00    50.80     0.00
506.03     6.20   29.75   29.75    0.00   4.57  93.88
sdh           12949.00     0.00  207.20    0.00    50.90     0.00
503.11     6.36   30.35   30.35    0.00   4.59  95.10
sdb           12196.40     0.00  192.60    0.00    48.10     0.00
511.47     5.48   28.15   28.15    0.00   4.38  84.36
sda               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdi           12923.00     0.00  208.40    0.00    51.00     0.00
501.20     6.79   32.31   32.31    0.00   4.65  96.84
sdj           12796.20     0.00  206.80    0.00    50.50     0.00
500.12     6.62   31.73   31.73    0.00   4.62  95.64
sdk           12746.60     0.00  204.00    0.00    50.20     0.00
503.97     6.38   30.77   30.77    0.00   4.60  93.86
sdl           12570.00     0.00  202.20    0.00    49.70     0.00
503.39     6.39   31.19   31.19    0.00   4.63  93.68
sdn           12594.00     0.00  204.20    0.00    49.95     0.00
500.97     6.40   30.99   30.99    0.00   4.58  93.54
sdm           12569.00     0.00  203.80    0.00    49.90     0.00
501.45     6.30   30.58   30.58    0.00   4.45  90.60
sdp           12568.80     0.00  205.20    0.00    50.10     0.00
500.03     6.37   30.79   30.79    0.00   4.52  92.72
sdo           12569.20     0.00  204.00    0.00    49.95     0.00
501.46     6.40   31.07   31.07    0.00   4.58  93.42
sdw           12568.60     0.00  206.20    0.00    50.00     0.00
496.60     6.34   30.71   30.71    0.00   4.24  87.48
sdx           12038.60     0.00  197.40    0.00    47.60     0.00
493.84     6.01   30.21   30.21    0.00   4.40  86.86
sdq           12570.20     0.00  204.20    0.00    50.15     0.00
502.97     6.23   30.41   30.41    0.00   4.44  90.68
sdr           12571.00     0.00  204.60    0.00    50.25     0.00
502.99     6.15   30.26   30.26    0.00   4.18  85.62
sds           12495.20     0.00  203.80    0.00    49.95     0.00
501.95     6.00   29.62   29.62    0.00   4.24  86.38
sdu           12695.60     0.00  207.80    0.00    50.65     0.00
499.17     6.22   30.00   30.00    0.00   4.16  86.38
sdv           12619.00     0.00  207.80    0.00    50.35     0.00
496.22     6.23   30.03   30.03    0.00   4.20  87.32
sdt           12671.20     0.00  206.20    0.00    50.50     0.00
501.56     6.05   29.30   29.30    0.00   4.24  87.44
sdc           12851.60     0.00  203.00    0.00    50.70     0.00
511.50     5.84   28.49   28.49    0.00   4.17  84.64
md126             0.00     0.00    0.60    1.00     0.05     0.00
71.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.60    0.80     0.05     0.00
81.14     0.00    2.29    0.67    3.50   1.14   0.16
dm-1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00 4475.20    0.00  1110.95     0.00
508.41     0.00    0.00    0.00    0.00   0.00   0.00


sdy and sz are the system drives, so they are uninteresting.

sda is the md0 drive I failed, that's why it stays at zero.

And lastly, here's the output of the perf commands you suggested (at
least the top part):

Samples: 561K of event 'cycles', Event count (approx.): 318536644203
Overhead  Command         Shared Object                 Symbol
  52.85%  swapper         [kernel.kallsyms]             [k] cpu_startup_entry
   4.47%  md0_raid6       [kernel.kallsyms]             [k] memcpy
   3.39%  dd              [kernel.kallsyms]             [k] __find_stripe
   2.50%  md0_raid6       [kernel.kallsyms]             [k] analyse_stripe
   2.43%  dd              [kernel.kallsyms]             [k] _raw_spin_lock_irq
   1.75%  rngd            rngd                          [.] 0x000000000000288b
   1.74%  md0_raid6       [kernel.kallsyms]             [k] xor_avx_5
   1.49%  dd              [kernel.kallsyms]             [k]
copy_user_enhanced_fast_string
   1.33%  md0_raid6       [kernel.kallsyms]             [k] ops_run_io
   0.65%  dd              [kernel.kallsyms]             [k] raid5_compute_sector
   0.60%  md0_raid6       [kernel.kallsyms]             [k] _raw_spin_lock_irq
   0.55%  ps              libc-2.17.so                  [.] _IO_vfscanf
   0.53%  ps              [kernel.kallsyms]             [k] vsnprintf
   0.51%  ps              [kernel.kallsyms]             [k] format_decode
   0.47%  ps              [kernel.kallsyms]             [k] number.isra.2
   0.41%  md0_raid6       [kernel.kallsyms]             [k] raid_run_ops
   0.40%  md0_raid6       [kernel.kallsyms]             [k] __blk_segment_map_sg


That's my first time using the perf tool, so I need a little hand-holding here.

Thanks again all!
Matt
