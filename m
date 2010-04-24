From: Joe Williams <jwilliams315@gmail.com>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Sat, 24 Apr 2010 16:45:07 -0700
Message-ID: <p2y11f0870e1004241645je58c24bbn504b64cd7b998289@mail.gmail.com>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[end of last message was truncated, here is the rest]

Next I tried 2560 for stripe_cache_size, since that is the 512KB x 5
stripe width.

                                                            random
random
              KB  reclen   write rewrite    read    reread    read   write
         4194304      64  201919  141025   139386   134252    7421
13327
         4194304     128  194337  123513   237911   237901   13002
22758
         4194304     256  181426  142159   256929   252772   21986
30099
         4194304     512  183168  175516   234975   234090   32614
40375
         4194304    1024  169051  163818   220393   233060   54738
58653
         4194304    2048  173281  141452   237993   234881   95969
77678
         4194304    4096  162690  142784   208838   211268   90016
96876
         4194304    8192  151361  125652   197484   197278  124009
112708
         4194304   16384  138971  106200   183750   183659  135876
121704

So the sequential reads at 200+ MB/s look okay (although I do not
understand the huge throughput variability with record size), but the
writes are not as high as with 16MB stripe cache. This may be the
setting that I decide to stick with, but I would like to understand
what is going on.

Why did increasing the stripe cache from 256 KB to 16 MB decrease the
sequential read speeds?

Also, let me know what other parameters I should tune during my optimizations.
