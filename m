From: Mark Smith <nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
Subject: Interesting RAID checking observations - I'm getting it too
Date: Wed, 30 Aug 2006 19:24:10 +0930
Message-ID: <20060830192410.332db788.nanog@fa1c52f96c54f7450e1ffb215f29991e.nosense.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a note, I've noticed this problem too. I run a RAID1 check once
every 24 hours, and while developing the script to do it, noticed that
the machine became virtually unusable - mouse was jumpy, typing lagged.

I run this check every morning at 4.00am so I'm usually asleep and
don't notice it, so it hasn't been a big bother to me.

The data may be a bit corse, however here is what sysstat/sar says my
machine does during the check. Let me know if you want any more or other
sar data.

sar 
~~~
00:01:01          CPU     %user     %nice   %system   %iowait    %steal     %idle
.
.
03:51:01          all      0.68      0.00      0.33      0.00      0.00     98.99
03:56:01          all      1.03      0.00      0.39      0.00      0.00     98.58
04:01:01          all      0.73      0.01     20.70      0.01      0.00     78.55
04:06:01          all      1.32      0.00     82.81      0.07      0.00     15.80
04:11:01          all      1.26      0.00     67.91      0.20      0.00     30.63
04:16:01          all      1.18      0.00     58.14      0.22      0.00     40.46
04:21:01          all      1.00      0.00     79.94      0.16      0.00     18.89
04:26:01          all      1.09      0.00     94.54      0.28      0.00      4.09
04:31:01          all      1.33      0.00     84.23      0.13      0.00     14.30
04:36:01          all      1.58      0.00     71.76      0.19      0.00     26.47
04:41:01          all      0.68      0.00      0.35      0.00      0.00     98.97
04:46:01          all      0.82      0.00      0.42      0.00      0.00     98.76
.
.

sar -b (Report  I/O  and transfer rate statistics)
~~~~~~
00:01:01          tps      rtps      wtps   bread/s   bwrtn/s
.
.
03:51:01         0.45      0.00      0.45      0.00      4.19
03:56:01         0.98      0.00      0.98      0.00     10.53
04:01:01       294.21    293.21      1.00  37529.57     10.01
04:06:01      1198.39   1197.36      1.03 153262.11      9.22
04:11:01       995.09    994.64      0.45 127314.06      4.11
04:16:01       852.48    852.03      0.45 109060.47      4.19
04:21:01      1161.13   1160.17      0.96 148500.42      9.15
04:26:01      1361.27   1360.51      0.76 174144.93      7.33
04:31:01      1226.02   1225.36      0.66 156846.40      6.13
04:36:01      1052.60   1051.96      0.65 134650.39      6.03
04:41:01         0.73      0.00      0.73      0.00      6.61
04:46:01         0.45      0.00      0.45      0.00      4.19
.
.
.
sar -B (Report paging statistics)
~~~~~~
00:01:01     pgpgin/s pgpgout/s   fault/s  majflt/s
.
.
03:51:01         0.00      1.16      5.05      0.00
03:56:01         0.00      2.47     15.38      0.00
04:01:01         0.01      2.54     21.32      0.00
04:06:01         0.00      2.57      6.94      0.00
04:11:01         0.00      1.15      5.04      0.00
04:16:01         0.00      1.16      5.04      0.00
04:21:01         0.01      2.36      6.24      0.00
04:26:01         0.00      1.88      4.88      0.00
04:31:01         0.00      1.63      8.35      0.00
04:36:01         0.00      1.63      5.04      0.00
04:41:01         0.00      1.81     11.12      0.00
04:46:01         0.00      1.16      5.04      0.00
04:51:01         0.00      1.07      5.05      0.00
04:56:01         0.00      1.16      5.05      0.00
.
.
sar -q (Report queue length and load averages)
~~~~~~
00:01:01      runq-sz  plist-sz   ldavg-1   ldavg-5  ldavg-15
.
.
03:51:01            0       106      0.00      0.00      0.00
03:56:01            0       106      0.00      0.00      0.00
04:01:01            3       117      7.14      2.19      0.76
04:06:01            0       113      7.97      6.23      2.95
04:11:01            0       113      7.95      7.29      4.31
04:16:01            0       113      7.56      7.48      5.20
04:21:01            1       110      6.38      7.35      5.81
04:26:01            1       107      2.07      4.33      4.96
04:31:01            0       107      2.16      2.94      4.17
04:36:01            0       106      1.57      2.19      3.50
04:41:01            0       106      0.01      0.79      2.52
04:46:01            0       106      0.00      0.28      1.81
04:51:01            0       106      0.00      0.09      1.30
04:56:01            0       106      0.00      0.03      0.93
.
.

Regards,
Mark.

-- 

        "Sheep are slow and tasty, and therefore must remain constantly
         alert."
                                   - Bruce Schneier, "Beyond Fear"
