From: Borg Onion <borg.onion@gmail.com>
Subject: Re: RAID1 round robin read support in md?
Date: Sun, 4 Dec 2011 21:21:48 -0800
Message-ID: <CAAs5ODtObyOaSebofD-Kf2HcYU_7zRv0+oUmWPnnzU=gYn24Ug@mail.gmail.com>
References: <CAAs5ODuHAE=K-nbd=YuMq-FL33x-22TM2cnmBHud9mEhwuJFOw@mail.gmail.com>
	<CALFpzo48C2-HHgw=iOefdHaAUCwEJfjoiXjq=Ngv62a-0yEpcQ@mail.gmail.com>
	<CAAs5ODv01LE6HRZjteYYsaMF5stTNv-8pdK9JDP18u4QeNGUOQ@mail.gmail.com>
	<CALFpzo7WqkXNF9DcCNJn_D1ZP=Jgpb85u6H=5_KPONQMy7FpYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec544ed20d2093004b3517ebe
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo7WqkXNF9DcCNJn_D1ZP=Jgpb85u6H=5_KPONQMy7FpYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--bcaec544ed20d2093004b3517ebe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 4 December 2011 19:13, Marcus Sorensen <shadowsor@gmail.com> wrote:
> Keep forgetting to reply all on these.
>
> Here is my dd test, split ~50/50. Again, one thread will leave half of
> each disk idle, as it makes requests serially:
>
> [root@server ~]# dd if=3D/dev/md0 of=3D/dev/null & iostat -xk 1 /dev/sda =
/dev/sdb
> [1] 5293
> Linux 2.6.32-71.29.1.el6.x86_64 (server) =A0 =A0 =A0 =A012/04/2011 =A0 =
=A0 =A0_x86_64_ =A0 =A0 =A0 =A0(4 CPU)
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 2.65 =A0 =A00.00 =A0 =A06.67 =A0 =A00.03 =A0 =A00.00 =
=A0 90.65
>
> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 =A0=
rkB/s =A0 =A0wkB/s
> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> sdb =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.44 =A0 =A0 0.44 =A0 =A04.24 =A0 =A09.50=
 =A0 172.99 =A0 =A056.46
> 33.39 =A0 =A0 0.07 =A0 =A04.78 =A0 2.41 =A0 3.31
> sda =A0 =A0 =A0 =A0 =A0 =A0 =A0 0.43 =A0 =A0 0.44 =A0 =A04.26 =A0 =A09.50=
 =A0 173.30 =A0 =A056.46
> 33.39 =A0 =A0 0.07 =A0 =A04.81 =A0 2.39 =A0 3.29
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 6.42 =A0 =A00.00 =A0 21.48 =A0 22.96 =A0 =A00.00 =A0 =
49.14
>
> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 =A0=
rkB/s =A0 =A0wkB/s
> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> sdb =A0 =A0 =A0 =A0 =A0 =A08776.00 =A0 =A0 0.00 =A0292.00 =A0 10.00 36320=
.00 =A0 =A083.00
> 241.08 =A0 =A0 1.07 =A0 =A03.56 =A0 1.85 =A055.90
> sda =A0 =A0 =A0 =A0 =A0 =A08080.00 =A0 =A0 2.00 =A0269.00 =A0 =A00.00 332=
72.00 =A0 =A0 0.00
> 247.38 =A0 =A0 0.98 =A0 =A03.40 =A0 1.81 =A048.80
>
> avg-cpu: =A0%user =A0 %nice %system %iowait =A0%steal =A0 %idle
> =A0 =A0 =A0 =A0 =A0 6.90 =A0 =A00.00 =A0 21.67 =A0 22.91 =A0 =A00.00 =A0 =
48.52
>
> Device: =A0 =A0 =A0 =A0 rrqm/s =A0 wrqm/s =A0 =A0 r/s =A0 =A0 w/s =A0 =A0=
rkB/s =A0 =A0wkB/s
> avgrq-sz avgqu-sz =A0 await =A0svctm =A0%util
> sdb =A0 =A0 =A0 =A0 =A0 =A06903.00 =A0 =A0 0.00 =A0231.00 =A0 40.00 28288=
.00 =A0 =A047.00
> 209.11 =A0 =A0 2.01 =A0 =A07.41 =A0 2.21 =A059.80
> sda =A0 =A0 =A0 =A0 =A0 =A07264.00 =A0 =A0 1.00 =A0242.00 =A0 54.00 30148=
.00 =A0 131.50
> 204.59 =A0 =A0 1.64 =A0 =A05.76 =A0 1.77 =A052.50


OK it seems to be sporadic.  There are long periods of time when one
drive is idle.  Pardon the long trace, but you'll see how the load
shifts to just 1 drive many times.  I've produced a graph which is a
lot easier to read, here: http://i.imgur.com/XfYhY.gif .  It's also
attached, if the list doesn't strip it.  I'm not sure how to check for
write-mostly.  I think the 0.90 superblock doesn't even support that?
Could that be part of the problem?


server # mdadm --detail /dev/md127 && dd if=3D/dev/md127 of=3D/dev/null
bs=3D128k & iostat -xk 1 /dev/md127 /dev/sdy /dev/sdz
[1] 26208
Linux 3.1.4-gentoo (server)         12/04/11        _x86_64_        (24 CPU=
)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.06    0.00    0.27    0.12    0.00   98.54

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy             293.37    57.63   14.33    7.15  1385.16   259.74
153.18     0.06    2.87    1.02    6.59   0.42   0.91
sdz              32.46    57.61    6.29    7.17   299.74   259.74
83.15     0.04    3.29    0.57    5.68   0.24   0.33
md127             0.00     0.00  346.36   64.43  1684.66   257.72
9.46     0.00    0.00    0.00    0.00   0.00   0.00

/dev/md127:
        Version : 0.90
  Creation Time : Mon Nov 28 20:36:04 2011
     Raid Level : raid1
     Array Size : 232286272 (221.53 GiB 237.86 GB)
  Used Dev Size : 232286272 (221.53 GiB 237.86 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Sun Dec  4 20:41:34 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 57f9a386:d4e46e7a:78a9b883:5f5f67d5
         Events : 0.3971

    Number   Major   Minor   RaidDevice State
       0      65      130        0      active sync   /dev/sdy2
       1      65      146        1      active sync   /dev/sdz2
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.51    0.00   10.06    5.83    0.00   83.59

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           28285.00     0.00  976.00    2.00 117316.00     8.00
239.93     1.01    1.03    1.02    5.00   0.58  57.00
sdz           23379.00     0.00  958.00    2.00 97264.00     8.00
202.65     0.73    0.76    0.75    5.00   0.47  45.00
md127             0.00     0.00 53644.00    0.00 214576.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.46    0.00    5.06    4.14    0.00   90.34

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           24623.00     0.00  841.00    0.00 101664.00     0.00
241.77     0.83    0.99    0.99    0.00   0.55  46.00
sdz           29971.00     0.00 1010.00    0.00 124200.00     0.00
245.94     0.97    0.96    0.96    0.00   0.52  53.00
md127             0.00     0.00 56466.00    0.00 225864.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.77    0.00    5.83    3.97    0.00   89.43

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy            9069.00     0.00  333.00    0.00 37948.00     0.00
227.92     0.30    0.90    0.90    0.00   0.51  17.00
sdz           52843.00     0.00 1743.00    0.00 218100.00     0.00
250.26     1.50    0.86    0.86    0.00   0.48  83.00
md127             0.00     0.00 64012.00    0.00 256048.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.16    0.00    3.50    2.13    0.00   94.21

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy            7412.00     0.00  289.00    0.00 30896.00     0.00
213.81     0.20    0.69    0.69    0.00   0.42  12.00
sdz           55156.00     0.00 1853.00    0.00 228288.00     0.00
246.40     1.64    0.89    0.89    0.00   0.48  89.00
md127             0.00     0.00 64765.00    0.00 259060.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.21    0.00    5.07    3.44    0.00   91.29

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           25766.00  1060.00  869.00   56.00 106628.00  4464.00
240.20     1.41    1.52    0.92   10.89   0.51  47.00
sdz           30453.00  1067.00 1064.00   47.00 126312.00  4464.00
235.42     2.29    2.06    0.93   27.66   0.51  57.00
md127             0.00     0.00 58234.00 1114.00 232936.00  4456.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.70    0.00    7.20    5.53    0.00   86.57

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           15413.00     0.00  524.00    0.00 63812.00     0.00
243.56     0.43    0.82    0.82    0.00   0.42  22.00
sdz           43092.00     0.00 1424.00    0.00 178128.00     0.00
250.18     1.47    1.03    1.03    0.00   0.55  78.00
md127             0.00     0.00 60517.00    0.00 242068.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.21    0.00    1.25    6.51    0.00   92.03

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           35370.00   196.00 1146.00    9.00 146068.00   824.00
254.36     1.24    1.07    1.08    0.00   0.57  66.00
sdz           19614.00   194.00  681.00   12.00 81256.00   824.00
236.88     0.61    0.88    0.90    0.00   0.48  33.00
md127             0.00     0.00 56799.00  204.00 227196.00   816.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.39    0.00    4.13   11.59    0.00   83.89

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           41724.00     0.00 1439.00    0.00 172532.00     0.00
239.79     1.38    0.96    0.96    0.00   0.51  74.00
sdz           20375.00     0.00  692.00    0.00 84440.00     0.00
244.05     0.50    0.72    0.72    0.00   0.39  27.00
md127             0.00     0.00 64275.00    0.00 257100.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.86    0.00    2.97    8.82    0.00   87.35

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           22819.00     0.00  783.00    0.00 94756.00     0.00
242.03     0.64    0.82    0.82    0.00   0.42  33.00
sdz           48043.00     0.00 1603.00    0.00 198664.00     0.00
247.87     1.39    0.87    0.87    0.00   0.42  68.00
md127             0.00     0.00 73291.00    0.00 293164.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.21    0.00    1.41    3.85    0.00   94.54

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           38957.00     0.00 1289.00    0.00 160908.00     0.00
249.66     1.39    1.08    1.08    0.00   0.61  78.00
sdz           15029.00     0.00  487.00    0.00 62064.00     0.00
254.88     0.37    0.76    0.76    0.00   0.45  22.00
md127             0.00     0.00 55783.00    0.00 223132.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.37    0.00    4.70    8.00    0.00   86.93

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           38457.00   614.00 1303.00   40.00 159248.00  2620.00
241.05     1.11    0.83    0.72    4.25   0.42  56.00
sdz           28957.00   613.00  961.00   42.00 119500.00  2620.00
243.51     0.99    1.00    0.80    5.48   0.44  44.00
md127             0.00     0.00 69711.00  653.00 278844.00  2612.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.81    0.00    5.08    9.52    0.00   84.59

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy            6050.00     0.00  202.00    0.00 25008.00     0.00
247.60     0.18    0.89    0.89    0.00   0.45   9.00
sdz           77234.00     0.00 2542.00    0.00 319236.00     0.00
251.17     1.57    0.62    0.62    0.00   0.36  91.00
md127             0.00     0.00 86061.00    0.00 344244.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.71    0.00    4.35   11.83    0.00   83.11

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           35507.00     0.00 1250.00    0.00 147148.00     0.00
235.44     0.78    0.62    0.62    0.00   0.37  46.00
sdz           40901.00     0.00 1364.00    0.00 169404.00     0.00
248.39     1.01    0.74    0.74    0.00   0.40  54.00
md127             0.00     0.00 79138.00    0.00 316552.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.23    0.00    3.12    6.28    0.00   90.38

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           50797.00     0.00 1779.00    0.00 210564.00     0.00
236.72     1.27    0.71    0.71    0.00   0.37  65.00
sdz           25779.00     0.00  923.00    0.00 106968.00     0.00
231.78     0.61    0.66    0.66    0.00   0.38  35.00
md127             0.00     0.00 79383.00    0.00 317532.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.87    0.00    2.48   10.73    0.00   85.93

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           17467.00     0.00  673.00    0.00 72860.00     0.00
216.52     0.46    0.68    0.68    0.00   0.37  25.00
sdz           45804.00     0.00 1606.00    0.00 189584.00     0.00
236.09     1.39    0.87    0.87    0.00   0.47  75.00
md127             0.00     0.00 65611.00    0.00 262444.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.15    0.00    1.84    5.00    0.00   93.02

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           24057.00     0.00  822.00    0.00 99464.00     0.00
242.00     0.67    0.82    0.82    0.00   0.46  38.00
sdz           33170.00     0.00 1106.00    0.00 137364.00     0.00
248.40     1.10    0.99    0.99    0.00   0.56  62.00
md127             0.00     0.00 59219.00    0.00 236872.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.06    0.00    1.55    5.54    0.00   92.85

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           25155.00  1076.00  903.00   42.00 104600.00  4472.00
230.84     1.36    1.44    1.09    9.05   0.60  57.00
sdz           28702.00  1078.00  978.00   40.00 118588.00  4472.00
241.77     1.22    1.20    0.82   10.50   0.45  46.00
md127             0.00     0.00 55785.00 1116.00 223144.00  4464.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.11    0.00    3.40   12.15    0.00   83.34

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           12051.00     0.00  408.00    0.00 49636.00     0.00
243.31     0.33    0.81    0.81    0.00   0.44  18.00
sdz           60427.00     0.00 1987.00    0.00 249988.00     0.00
251.62     1.53    0.77    0.77    0.00   0.41  82.00
md127             0.00     0.00 74910.00    0.00 299636.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.07    0.00    3.06    6.11    0.00   90.76

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           28577.00     0.00  960.00    0.00 118220.00     0.00
246.29     0.75    0.78    0.78    0.00   0.42  40.00
sdz           44592.00     0.00 1471.00    0.00 184296.00     0.00
250.57     1.04    0.71    0.71    0.00   0.41  61.00
md127             0.00     0.00 75625.00    0.00 302504.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.46    0.00    4.76    9.64    0.00   85.13

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           57918.00     0.00 1883.00    0.00 239452.00     0.00
254.33     1.48    0.79    0.79    0.00   0.45  84.00
sdz           11124.00     0.00  428.00    0.00 46084.00     0.00
215.35     0.29    0.68    0.68    0.00   0.37  16.00
md127             0.00     0.00 71384.00    0.00 285536.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.55    0.00    3.01    6.02    0.00   90.42

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           64465.00     0.00 2081.00    0.00 266060.00     0.00
255.70     1.68    0.81    0.81    0.00   0.47  97.00
sdz            2545.00     0.00   88.00    0.00 10780.00     0.00
245.00     0.06    0.68    0.68    0.00   0.34   3.00
md127             0.00     0.00 69210.00    0.00 276840.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.24    0.00    1.99    4.70    0.00   93.07

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           26655.00     0.00  945.00    0.00 110552.00     0.00
233.97     0.66    0.70    0.70    0.00   0.39  37.00
sdz           43003.00     0.00 1410.00    0.00 177652.00     0.00
251.99     1.11    0.79    0.79    0.00   0.45  63.00
md127             0.00     0.00 72051.00    0.00 288204.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.44    0.00    3.61   11.48    0.00   84.46

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           36943.00  1069.00 1192.00   60.00 152544.00  4516.00
250.89     2.02    1.61    1.21    9.67   0.65  82.00
sdz           15378.00  1068.00  498.00   61.00 63504.00  4516.00
243.36     1.14    2.04    0.60   13.77   0.45  25.00
md127             0.00     0.00 54012.00 1127.00 216048.00  4508.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.93    0.00    6.51    7.90    0.00   84.66

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           37451.00     0.00 1225.00    0.00 154872.00     0.00
252.85     0.93    0.76    0.76    0.00   0.44  54.00
sdz           39693.00     0.00 1311.00    0.00 163848.00     0.00
249.96     0.88    0.67    0.67    0.00   0.36  47.00
md127             0.00     0.00 79680.00    0.00 318720.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.17    0.00    4.52    6.45    0.00   88.87

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdz           76542.00     0.00 2487.00    0.00 316288.00     0.00
254.35     1.78    0.72    0.72    0.00   0.40 100.00
md127             0.00     0.00 79040.00    0.00 316160.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.16    0.00    3.09    4.93    0.00   91.82

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy            1779.00     0.00   66.00    0.00  7132.00     0.00
216.12     0.05    0.76    0.76    0.00   0.45   3.00
sdz           68544.00     0.00 2234.00    0.00 283296.00     0.00
253.62     1.68    0.76    0.76    0.00   0.43  97.00
md127             0.00     0.00 72639.00    0.00 290556.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.37    0.00    3.54    5.49    0.00   90.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           71774.00   477.00 2327.00   35.00 296432.00  2048.00
252.73     1.90    0.80    0.75    4.57   0.42 100.00
sdz               1.00   475.00    3.00   37.00    16.00  2048.00
103.20     0.07    1.75    0.00    1.89   0.25   1.00
md127             0.00     0.00 74112.00  510.00 296448.00  2040.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.29    0.00    2.15    5.42    0.00   92.14

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           71460.00   579.00 2317.00   18.00 295152.00  2388.00
254.85     2.84    1.22    0.77   58.89   0.43 100.00
sdz               1.00   579.00    3.00   18.00    16.00  2388.00
228.95     0.09    4.29    0.00    5.00   0.48   1.00
md127             0.00     0.00 73792.00  595.00 295168.00  2380.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.21    0.00    3.72    5.19    0.00   90.88

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           81107.00     0.00 2646.00    0.00 335096.00     0.00
253.28     1.66    0.63    0.63    0.00   0.38 100.00
sdz               0.00     0.00    2.00    0.00     8.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 83776.00    0.00 335104.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.78    0.00    4.13    9.21    0.00   85.87

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           49380.00     0.00 1609.00    0.00 204044.00     0.00
253.63     1.19    0.74    0.74    0.00   0.44  70.00
sdz           22655.00     0.00  732.00    0.00 93548.00     0.00
255.60     0.56    0.77    0.77    0.00   0.41  30.00
md127             0.00     0.00 74389.00    0.00 297556.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.92    0.00    3.18   11.37    0.00   84.54

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           72799.00     0.00 2362.00    0.00 300760.00     0.00
254.67     1.98    0.84    0.84    0.00   0.42 100.00
sdz               0.00     0.00    1.00    0.00     4.00     0.00
8.00     0.01   10.00   10.00    0.00  10.00   1.00
md127             0.00     0.00 75200.00    0.00 300800.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.28    0.00    3.53    6.13    0.00   90.06

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           75862.00     1.00 2522.00   68.00 313668.00   276.00
242.43     1.74    0.68    0.69    0.00   0.39 100.00
sdz               0.00     1.00    2.00   68.00     8.00   276.00
8.11     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 78419.00   67.00 313676.00   268.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.80    0.00    3.20    9.16    0.00   86.84

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           62589.00  1061.00 2061.00   87.00 258684.00  4600.00
245.14     2.36    1.10    0.73    9.77   0.40  86.00
sdz           10630.00  1061.00  371.00   87.00 44112.00  4600.00
212.72     1.34    2.93    1.51    8.97   0.41  19.00
md127             0.00     0.00 75696.00 1148.00 302784.00  4592.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.32    0.00    2.40    7.51    0.00   89.77

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           41672.00     0.00 1365.00    0.00 172300.00     0.00
252.45     1.02    0.75    0.75    0.00   0.41  56.00
sdz           37268.00     0.00 1252.00    0.00 154212.00     0.00
246.35     0.80    0.64    0.64    0.00   0.36  45.00
md127             0.00     0.00 81631.00    0.00 326524.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.21    0.00    4.73    8.36    0.00   86.70

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           74771.00     0.00 2507.00    0.00 309352.00     0.00
246.79     1.72    0.69    0.69    0.00   0.40 100.00
sdz               0.00     0.00    6.00    0.00    24.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 77344.00    0.00 309376.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.72    0.00    4.46    7.52    0.00   87.30

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           78441.00     0.00 2561.00    0.00 323960.00     0.00
252.99     1.70    0.66    0.66    0.00   0.39  99.00
sdz               0.00     0.00    2.00    0.00     8.00     0.00
8.00     0.01    5.00    5.00    0.00   5.00   1.00
md127             0.00     0.00 80992.00    0.00 323968.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.23    0.00    3.45    5.95    0.00   90.36

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           77922.00     0.00 2569.00    0.00 322244.00     0.00
250.87     1.72    0.67    0.67    0.00   0.39 100.00
sdz               1.00     0.00   12.00    0.00    60.00     0.00
10.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 80576.00    0.00 322304.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.29    0.00    4.05    4.93    0.00   90.73

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           76787.00     0.00 2478.00    0.00 317056.00     0.00
255.90     1.68    0.68    0.68    0.00   0.40 100.00
sdz               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 79264.00    0.00 317056.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.64    0.00    4.56    5.72    0.00   89.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           75114.00  1060.00 2422.00   57.00 310144.00  4468.00
253.82     2.11    0.85    0.67    8.60   0.40 100.00
sdz               0.00  1058.00    0.00   59.00     0.00  4468.00
151.46     0.53    8.98    0.00    8.98   0.51   3.00
md127             0.00     0.00 77536.00 1115.00 310144.00  4460.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.27    0.00    2.89    5.27    0.00   91.58

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           75165.00     0.00 2444.00    0.00 310364.00     0.00
253.98     1.69    0.69    0.69    0.00   0.41  99.00
sdz               4.00     0.00    5.00    0.00    36.00     0.00
14.40     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 77600.00    0.00 310400.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.12    0.00    3.05    4.79    0.00   92.04

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           75971.00     0.00 2485.00    0.00 313972.00     0.00
252.69     1.70    0.68    0.68    0.00   0.40  99.00
sdz               1.00     0.00    2.00    0.00    12.00     0.00
12.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 78496.00    0.00 313984.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.91    0.00    3.42   10.65    0.00   85.02

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           75028.00   481.00 2464.00   13.00 310096.00  1976.00
251.98     1.88    0.76    0.74    4.62   0.40 100.00
sdz               0.00   481.00    2.00   13.00     8.00  1976.00
264.53     0.02    1.33    0.00    1.54   0.67   1.00
md127             0.00     0.00 77526.00  492.00 310104.00  1968.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.31    0.00    2.41    8.45    0.00   88.84

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           77012.00     0.00 2537.00    0.00 318204.00     0.00
250.85     1.92    0.76    0.76    0.00   0.39 100.00
sdz               0.00     0.00    1.00    0.00     4.00     0.00
8.00     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 79552.00    0.00 318208.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.48    0.00    5.38    9.56    0.00   84.58

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           73600.00   596.00 2466.00   43.00 304464.00  2564.00
244.74     1.91    0.76    0.74    2.09   0.40 100.00
sdz             262.00   594.00   12.00   46.00  1096.00  2564.00
126.21     0.04    0.69    0.00    0.87   0.17   1.00
md127             0.00     0.00 76390.00  639.00 305560.00  2556.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.92    0.00    4.39    9.15    0.00   85.54

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           74577.00     0.00 2475.00    0.00 308360.00     0.00
249.18     1.73    0.70    0.70    0.00   0.40 100.00
sdz               3.00     0.00   11.00    0.00    68.00     0.00
12.36     0.00    0.00    0.00    0.00   0.00   0.00
md127             0.00     0.00 77107.00    0.00 308428.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.34    0.00    2.28    6.92    0.00   90.46

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           70017.00     0.00 2316.00    0.00 289496.00     0.00
250.00     1.87    0.81    0.81    0.00   0.43 100.00
sdz               2.00     0.00    8.00    0.00    40.00     0.00
10.00     0.07    8.75    8.75    0.00   1.25   1.00
md127             0.00     0.00 72384.00    0.00 289536.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.09    0.00    3.15    8.33    0.00   88.43

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           64289.00     0.00 2129.00    3.00 266028.00    12.00
249.57     1.64    0.77    0.77    0.00   0.43  91.00
sdz            5375.00     0.00  175.00    3.00 22080.00    12.00
248.22     0.14    0.79    0.80    0.00   0.51   9.00
md127             0.00     0.00 71995.00    1.00 287980.00     4.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.76    0.00    3.94   11.82    0.00   83.47

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           34027.00     0.00 1102.00    0.00 140392.00     0.00
254.79     0.89    0.81    0.81    0.00   0.46  51.00
sdz           40199.00     0.00 1318.00    0.00 166244.00     0.00
252.27     0.94    0.71    0.71    0.00   0.39  51.00
md127             0.00     0.00 76691.00    0.00 306764.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.37    0.00    4.12   10.92    0.00   84.58

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           63785.00  1081.00 2134.00   25.00 263672.00  4432.00
248.36     2.53    1.17    1.05   11.20   0.46  99.00
sdz              49.00  1080.00    6.00   27.00   220.00  4432.00
281.94     0.25    7.58    1.67    8.89   0.91   3.00
md127             0.00     0.00 65973.00 1106.00 263892.00  4424.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.28    0.00    2.44    5.93    0.00   91.35

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           22142.00     0.00  762.00    0.00 91992.00     0.00
241.45     0.43    0.56    0.56    0.00   0.35  27.00
sdz           45677.00     0.00 1531.00    0.00 188784.00     0.00
246.62     1.34    0.88    0.88    0.00   0.48  73.00
md127             0.00     0.00 70194.00    0.00 280776.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.43    0.00    2.70    5.72    0.00   91.16

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           48812.00     0.00 1679.00    0.00 202004.00     0.00
240.62     1.24    0.74    0.74    0.00   0.42  70.00
sdz           23931.00     0.00  834.00    0.00 99352.00     0.00
238.25     0.52    0.62    0.62    0.00   0.37  31.00
md127             0.00     0.00 75339.00    0.00 301356.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.30    0.00    2.54    5.06    0.00   92.10

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           58871.00     0.00 1964.00    0.00 243464.00     0.00
247.93     1.33    0.68    0.68    0.00   0.39  77.00
sdz           19190.00     0.00  651.00    0.00 79448.00     0.00
244.08     0.43    0.66    0.66    0.00   0.37  24.00
md127             0.00     0.00 80728.00    0.00 322912.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.17    0.00    1.81    5.74    0.00   92.28

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           47404.00     0.00 1562.00    0.00 196172.00     0.00
251.18     1.67    1.07    1.07    0.00   0.59  92.00
sdz            3889.00     0.00  153.00    0.00 15976.00     0.00
208.84     0.16    1.05    1.05    0.00   0.59   9.00
md127             0.00     0.00 53037.00    0.00 212148.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.85    0.00    4.49    8.08    0.00   86.58

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy            9363.00  1053.00  304.00   58.00 38668.00  4444.00
238.19     0.68    1.88    0.89    7.07   0.47  17.00
sdz           62479.00  1060.00 2016.00   48.00 258008.00  4444.00
254.31     2.44    1.18    0.70   21.25   0.41  85.00
md127             0.00     0.00 74169.00 1109.00 296676.00  4436.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.42    0.00    5.22    9.73    0.00   84.63

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdy           20569.00     0.00  676.00    0.00 84772.00     0.00
250.80     0.38    0.56    0.56    0.00   0.37  25.00
sdz           64949.00     0.00 2098.00    0.00 268408.00     0.00
255.87     1.34    0.64    0.64    0.00   0.36  75.00
md127             0.00     0.00 88293.00    0.00 353180.00     0.00
 8.00     0.00    0.00    0.00    0.00   0.00   0.00

^C
server #


--Borg Onion

--bcaec544ed20d2093004b3517ebe
Content-Type: image/gif; name="raid1.gif"
Content-Disposition: attachment; filename="raid1.gif"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvt15s3p0

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
6czUlT3Zck5r4ErEswzouIDK9ACDfp54wo5sFh3jP0s0binT/npN6r5t4NOOy46Ov1u55cme36xe
7LeNkGu+mABGZVZRyrZeCW3u5gh+09Z+7VEb1hRtwtvO7fSc6v6ZC8Ye5siu6W/s4kfq7JL+4que
6Ace4mtRNTyuDlujzOGcyfNO7wyN70f9r5wu1oc+6cC66QFvsJ6+8Rif7oRu8PCt4PJd7ZFujij0
8BAP1/je71N4x/4O66yq8kie0qsAGoMdWfgN8k2O67vu1PkRNjfFyJg0vppd77b565JXrKqO6DTP
4a8u0HMb8DrvQT4/5bp+8Lfz5kEPOMZU4WYM25S+vffusba6sfv67AOP8cx+5z0P8Esu8Gs/9QXf
24wO9Pgh/vR0b+eh+vTDXukEJ6Bu5bWprvQ1b7Y56PcyH/W3DPdl3tyPnfW5Lup3v+7ZfUG5BPZM
fNwrvr3kaMTwLuvm/s8EPuiMz86OH/MXj+h7T9PSbupUjhh6//Una0GKj157DoqQjukYCfPdXfXh
3vDoXfCpn9Wrv/bkafkmf/XCjfkn2KJXeftert+p6fHeKeiSDvyRn+HPTfx6fO5WL/LLL9kjLvvO
n+1/LP24T/3YrvZzmsOHj6zqP9VhLvUE7/bgj+6xP/n3P+rWXfKAACA4SFhoeBgAkHjI2Oj42AgD
CSBpODCJmam5ybnI+QkK6hn6KQlTWTmZSsoa2Sq46hgL/nnpWPvKOduqi6s5Ovi7yVs43HgLeozY
mxmsvOzY7Ps8TV1tfe2MmxiNDVk8qJvcPc5Mbi7Ijf0te665jvn+Xig+304o725vGJ3urcpJT1NA
YPb6oTNn8FFCfQwbOiy0ENO2h4ziHRpIsVvEcQE6LvLoEV1IRhuX4TN00lxKdv42YQTwUt2zWcli
suJHyqJLVi9LvkroM1RQQkMzGj2qrddHpOD+WWJ6rui0jiIV/aJqlSTDlfegcq3oVOAjm9a+unoq
iCwpbkXXcVXLCKNUoZPmSlsLNa9eanYJKsrrNu5ejUexUgX5MbFWe2ZhMW2MMmyml3CpQSYmuPKn
dG1b/u4kJVcf0Kh4B5s+3UnpQa+eCWlGXQ7qYcWz+SHu2xrUZZO8c9P67XC3Y2McoeV8tPJ1vUa4
N41GWBq29OkQVf8FjPwi9Zu3mY4kum324nO7hb8y35SlWOBbew0bAB9bP6nfkrcKLVphO6nNt/sn
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
k3aokzqJJFKZOo14gNeClbDGcVvJiehklYeIiWPpKZc4JmapOk8pbXw4lW3plm8Jl3Epl3NJl3Vp
l3eJl3mpl3vJl33pl38JmIEpmINJmIVpmIeJmHbGlmdYIVujh465mAXGh5HpYrfjmJVJXvB4jHgx
mZdZGZYpaJB5k/AFmqCJmTpjmo+pkVnzmFy4iqxVmqP5jqx5hrRJm9BoWbH5mqS5mriZm/qSmhmW
mcHJm65pm5/JN5tJGXqjOcr5js2pmljjmcWJO9OZXbppnbBJPdBpGsDpnLMJj8eJmfmymlSYnOJ5
ndKJO4p5/p6+yYHqWZ7IuZuSSSOymZ5HYp/UmZ8PSF7EiWPr6Z44pZvoOZsBqp2JRaDDZT3+qaDq
OZ8NepvfaTsOmqC/iZr7KVvZSZ/bqaHayaEGKqCiCaJoZZkj+lGdaaLthKISmpgt6qIvCqMxKqMz
SqM1aqM3iqM5qqM7yqM96qM/CqRBKqRDSqRFaqRHiqRJqqRLyqRN6qRPCqVRKqVTSqVVaqUxmqKP
REdXyqVd6nYSVaH1wA5Z6qVlaqaMKR9jyqJnyqZt2hlKyJzlSZkIulULuqZuiqd5ei/GqZkAmoSN
mUpkqqeDSqhHlDH1mTNgyoJ8ip+F6qiPqqKHiqDruRI1PgGokIqpmcpCkrozfrqlnVqfmiqqowo6
iOqdoOqecRqnpMqqreqqrwqrsSqrs0qrtWqrt4qruaqru8qrORoIADs=
--bcaec544ed20d2093004b3517ebe--
