From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Growing RAID5 SSD Array
Date: Wed, 26 Mar 2014 00:10:35 +1100
Message-ID: <5331804B.6010708@websitemanagers.com.au>
References: <53211C9D.8050607@websitemanagers.com.au> <53219D4C.2020207@hardwarefreak.com> <53268B87.4060203@websitemanagers.com.au> <53276C84.5040805@hardwarefreak.com> <5327A462.2060303@websitemanagers.com.au> <53282C6C.4090502@hardwarefreak.com> <5328D5EC.7090303@websitemanagers.com.au> <532A0200.3070000@hardwarefreak.com> <532A5868.8060209@websitemanagers.com.au> <532DE6FC.5010301@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532DE6FC.5010301@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'll respond to the other email later on, but in between, I've found 
something else that seems just plain wrong.

So, right now, I've shutdown most of the VM's (just one Linux VM left, 
which should be mostly idle since it is after 11pm local time). I'm 
trying to create a duplicate copy of one LV to another as a backup (in 
case I mess it up). So, I've shutdown DRBD, so we are operating 
independently (not that there is any change if DRBD is connected), I'm 
running on the storage server itself (so no iscsi or network issues).

So, two LV's:
   LV VG   Attr     LSize   Pool Origin Data%  Move Log Copy%  Convert
   backup_xptserver1_d1_20140325_224311 vg0  -wi-ao-- 453.00g
   xptserver1_d1                                              vg0 
-wi-ao-- 452.00g

running the command:
dd if=/dev/vg0/xptserver1_d1 
of=/dev/vg0/backup_xptserver1_d1_20140325_224311
from another shell I run:
while pidof dd > /dev/null;do kill -USR1 `pidof dd`;sleep 10;done

dd shows this output:
99059692032 bytes (99 GB) copied, 2515.43 s, 39.4 MB/s
99403235840 bytes (99 GB) copied, 2525.45 s, 39.4 MB/s
99817538048 bytes (100 GB) copied, 2535.47 s, 39.4 MB/s
100252660224 bytes (100 GB) copied, 2545.49 s, 39.4 MB/s

iostat -dmx 1 shows this output:

sda - sdg are the RAID5 SSD drives, single partition, used by md only
dm-8 is the source for the dd copy
dm-17 is the destination of the dd copy,
dm-12 is the Linux VM which is currently running...

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg             957.00  6767.00  930.00  356.00     8.68    27.65 
57.85     0.65    0.50    0.16    1.39   0.37  48.00
sdd             956.00  6774.00  921.00  313.00     8.69    27.50 
60.06     0.26    0.21    0.08    0.60   0.17  20.80
sda             940.00  6781.00  927.00  326.00     8.65    27.57 
59.20     0.28    0.22    0.09    0.60   0.17  20.80
sdf             967.00  6768.00  927.00  320.00     8.70    27.50 
59.46     0.29    0.23    0.12    0.55   0.16  20.00
sde             943.00  6770.00  933.00  369.00     8.69    27.71 
57.26     0.74    0.57    0.16    1.60   0.44  57.20
sdc             983.00  6790.00  937.00  317.00     8.86    27.55 
59.46     1.58    1.27    0.71    2.90   0.49  61.60
sdb             966.00  6813.00  929.00  313.00     8.76    27.57 
59.92     1.20    0.97    0.34    2.84   0.49  61.20
md1               0.00     0.00 12037.00 42030.00    56.42 164.04     
8.35     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 12034.00 41989.00    56.41 164.02     
8.36   177.73    3.31    0.46    4.13   0.02  91.60
dm-8              0.00     0.00 5955.00    0.00    23.26 0.00     
8.00     4.43    0.74    0.74    0.00   0.01   6.40
dm-12             0.00     0.00  254.00    5.00    10.39     0.02 
82.38     0.28    1.08    1.01    4.80   0.59  15.20
dm-17             0.00     0.00 5813.00 41984.00    22.71 164.00     
8.00   174.87    3.65    0.15    4.13   0.02 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1378.00   156.00 1672.00    8.00    18.20     0.69 
23.03     0.15    0.09    0.08    2.00   0.08  12.80
sdd            1370.00   169.00 1667.00    9.00    18.15     0.75 
23.09     0.13    0.08    0.07    1.78   0.08  12.80
sda            1365.00   169.00 1655.00    9.00    18.09     0.75 
23.18     0.14    0.08    0.07    1.33   0.08  13.20
sdf            1377.00   156.00 1672.00    6.00    18.23     0.69 
23.09     0.14    0.09    0.08    2.00   0.08  12.80
sde            1374.00   159.00 1657.00    8.00    18.10     0.71 
23.13     0.16    0.10    0.09    2.00   0.10  16.40
sdc            1365.00   146.00 1666.00   10.00    18.12     0.75 
23.07     0.20    0.12    0.10    3.20   0.10  16.80
sdb            1375.00   137.00 1665.00   10.00    18.16     0.75 
23.13     0.23    0.14    0.11    4.00   0.12  19.60
md1               0.00     0.00 21218.00  820.00   126.86 3.20    
12.09     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 21221.00  820.00   126.88 3.20    
12.09    10.17    0.46    0.25    5.98   0.03  67.60
dm-8              0.00     0.00 9984.00    0.00    39.00 0.00     
8.00     4.47    0.45    0.45    0.00   0.00   2.80
dm-12             0.00     0.00 1166.00    0.00    48.54     0.00 
85.25     0.20    0.17    0.17    0.00   0.09  10.00
dm-17             0.00     0.00 10061.00  819.00    39.30 3.20     
8.00     4.38    0.51    0.06    5.99   0.06  63.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1472.00     0.00 1681.00    0.00    14.70     0.00 
17.90     0.14    0.08    0.08    0.00   0.08  13.60
sdd            1472.00     0.00 1668.00    0.00    14.64     0.00 
17.98     0.12    0.07    0.07    0.00   0.07  11.20
sda            1472.00     0.00 1673.00    0.00    14.66     0.00 
17.95     0.12    0.07    0.07    0.00   0.07  11.60
sdf            1472.00     0.00 1680.00    0.00    14.69     0.00 
17.91     0.13    0.08    0.08    0.00   0.07  12.40
sde            1472.00     0.00 1685.00    0.00    14.71     0.00 
17.88     0.12    0.07    0.07    0.00   0.07  11.60
sdc            1478.00     0.00 1687.00    0.00    14.72     0.00 
17.87     0.12    0.07    0.07    0.00   0.07  11.20
sdb            1487.00     0.00 1679.00    0.00    14.69     0.00 
17.92     0.14    0.08    0.08    0.00   0.08  13.20
md1               0.00     0.00 22182.00    0.00   103.29 0.00     
9.54     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 22244.00    0.00   103.66 0.00     
9.54     5.76    0.26    0.26    0.00   0.03  59.60
dm-8              0.00     0.00 10945.00    0.00    42.75 0.00     
8.00     5.74    0.50    0.50    0.00   0.00   4.00
dm-12             0.00     0.00  446.00    0.00    18.51     0.00 
84.99     0.07    0.15    0.15    0.00   0.07   3.20
dm-17             0.00     0.00 10836.00    0.00    42.33 0.00     
8.00     0.58    0.05    0.05    0.00   0.05  57.60

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1441.00    13.00 1684.00    4.00    17.76     0.06 
21.62     0.14    0.08    0.08    1.00   0.08  14.00
sdd            1421.00    32.00 1676.00    9.00    17.65     0.16 
21.64     0.15    0.09    0.08    1.33   0.09  14.40
sda            1426.00    28.00 1682.00    5.00    17.69     0.13 
21.63     0.13    0.08    0.08    1.60   0.07  12.40
sdf            1429.00    14.00 1671.00    6.00    17.66     0.08 
21.66     0.11    0.07    0.07    0.00   0.06  10.80
sde            1442.00    13.00 1686.00    7.00    17.77     0.08 
21.59     0.14    0.08    0.08    0.57   0.08  13.20
sdc            1405.00    28.00 1673.00    8.00    17.60     0.14 
21.61     0.16    0.10    0.09    1.50   0.09  14.40
sdb            1408.00    18.00 1672.00    6.00    17.64     0.09 
21.64     0.16    0.10    0.09    2.67   0.09  15.60
md1               0.00     0.00 21539.00   17.00   123.00 0.55    
11.74     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 21477.00   17.00   122.64 0.55    
11.74     4.61    0.21    0.21    1.18   0.03  68.40
dm-8              0.00     0.00 10176.00    0.00    39.75 0.00     
8.00     3.26    0.35    0.35    0.00   0.00   3.20
dm-12             0.00     0.00 1031.00   17.00    42.88     0.55 
84.87     0.14    0.13    0.12    1.18   0.08   8.80
dm-17             0.00     0.00 10262.00    0.00    40.09 0.00     
8.00     0.64    0.06    0.06    0.00   0.06  64.00


Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1472.00     0.00 1643.00    1.00    13.53     0.00 
16.85     0.17    0.10    0.10    4.00   0.09  15.60
sdd            1472.00     0.00 1653.00    2.00    13.57     0.00 
16.79     0.14    0.08    0.08    0.00   0.08  13.60
sda            1472.00     0.00 1654.00    1.00    13.57     0.00 
16.79     0.14    0.08    0.08    0.00   0.07  12.40
sdf            1472.00     0.00 1656.00    1.00    13.58     0.00 
16.78     0.11    0.07    0.07    4.00   0.07  11.20
sde            1472.00     0.00 1657.00    1.00    13.58     0.00 
16.77     0.12    0.07    0.07    4.00   0.07  11.20
sdc            1472.00     0.00 1662.00    1.00    13.60     0.00 
16.75     0.16    0.10    0.09   12.00   0.09  14.80
sdb            1472.00     0.00 1654.00    2.00    13.57     0.00 
16.79     0.17    0.10    0.09   10.00   0.10  16.80
md1               0.00     0.00 21882.00    1.00    94.99 0.00     
8.89     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 21882.00    1.00    94.99 0.00     
8.89     6.72    0.31    0.31    0.00   0.03  65.20
dm-8              0.00     0.00 10753.00    0.00    42.00 0.00     
8.00     6.02    0.56    0.56    0.00   0.00   4.40
dm-12             0.00     0.00  274.00    1.00    10.47     0.00 
78.02     0.10    0.38    0.38    0.00   0.13   3.60
dm-17             0.00     0.00 10849.00    0.00    42.38 0.00     
8.00     0.63    0.06    0.06    0.00   0.06  62.80

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1518.00     0.00 1669.00    0.00    12.45     0.00 
15.28     0.10    0.06    0.06    0.00   0.06   9.20
sdd            1523.00     0.00 1651.00    0.00    12.40     0.00 
15.38     0.13    0.08    0.08    0.00   0.07  12.00
sda            1518.00     0.00 1651.00    0.00    12.38     0.00 
15.36     0.15    0.09    0.09    0.00   0.09  14.40
sdf            1528.00     0.00 1669.00    0.00    12.49     0.00 
15.32     0.12    0.07    0.07    0.00   0.07  12.00
sde            1517.00     0.00 1655.00    0.00    12.39     0.00 
15.34     0.13    0.08    0.08    0.00   0.07  12.40
sdc            1534.00     0.00 1662.00    0.00    12.48     0.00 
15.38     0.13    0.08    0.08    0.00   0.08  13.20
sdb            1534.00     0.00 1651.00    0.00    12.44     0.00 
15.43     0.13    0.08    0.08    0.00   0.08  12.40
md1               0.00     0.00 22277.00    0.00    87.02 0.00     
8.00     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 22277.00    0.00    87.02 0.00     
8.00     6.06    0.27    0.27    0.00   0.03  68.40
dm-8              0.00     0.00 11137.00    0.00    43.50 0.00     
8.00     5.44    0.49    0.49    0.00   0.01   5.60
dm-12             0.00     0.00    1.00    0.00     0.00 0.00     
8.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-17             0.00     0.00 11121.00    0.00    43.44 0.00     
8.00     0.63    0.06    0.06    0.00   0.06  63.20

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg             976.00  6175.00  968.00  327.00     8.77    25.27 
53.84     0.60    0.47    0.13    1.47   0.35  45.20
sdd             973.00  6130.00  949.00  292.00     8.64    24.95 
55.43     0.26    0.21    0.10    0.58   0.17  20.80
sda             979.00  6176.00  952.00  292.00     8.68    25.13 
55.65     0.26    0.21    0.11    0.53   0.15  19.20
sdf             978.00  6191.00  958.00  294.00     8.73    25.20 
55.49     0.28    0.22    0.11    0.57   0.16  19.60
sde             976.00  6189.00  968.00  330.00     8.79    25.33 
53.82     0.67    0.51    0.14    1.61   0.41  52.80
sdc             972.00  6202.00  947.00  292.00     8.69    24.93 
55.58     1.43    1.15    0.54    3.10   0.46  56.40
sdb             974.00  6174.00  954.00  293.00     8.70    24.82 
55.05     1.19    0.95    0.29    3.10   0.46  57.20
md1               0.00     0.00 12427.00 38133.00    56.70 148.83     
8.33     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 12424.00 38092.00    56.69 148.80     
8.33   159.95    3.14    0.49    4.00   0.02  89.60
dm-8              0.00     0.00 6144.00    0.00    24.00 0.00     
8.00     5.21    0.85    0.85    0.00   0.01   6.80
dm-12             0.00     0.00  231.00    0.00     9.06     0.00 
80.31     0.15    0.64    0.64    0.00   0.36   8.40
dm-17             0.00     0.00 6030.00 38093.00    23.55 148.80     
8.00   157.57    3.48    0.13    4.00   0.02  99.20

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg             914.00  6081.00  921.00  324.00     8.36    24.89 
54.70     0.58    0.46    0.17    1.30   0.35  43.20
sdd             925.00  6079.00  914.00  286.00     8.38    24.75 
56.53     0.24    0.20    0.06    0.63   0.16  18.80
sda             940.00  6048.00  921.00  289.00     8.48    24.62 
56.03     0.31    0.26    0.16    0.58   0.20  23.60
sdf             907.00  6032.00  920.00  287.00     8.31    24.56 
55.77     0.28    0.23    0.11    0.60   0.17  20.00
sde             919.00  6074.00  930.00  324.00     8.41    24.88 
54.36     0.99    0.79    0.38    1.96   0.43  54.40
sdc             909.00  6077.00  926.00  289.00     8.36    25.05 
56.32     1.51    1.25    0.63    3.24   0.48  58.40
sdb             905.00  6083.00  914.00  287.00     8.29    25.06 
56.88     1.09    0.92    0.26    3.02   0.43  52.00
md1               0.00     0.00 11831.00 37443.00    54.55 146.14     
8.34     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 11834.00 37407.00    54.56 146.12     
8.35   179.72    3.71    0.64    4.68   0.02  89.60
dm-8              0.00     0.00 5760.00    0.00    22.50 0.00     
8.00     6.43    1.12    1.12    0.00   0.02  10.00
dm-12             0.00     0.00  228.00    0.00     9.23     0.00 
82.88     0.31    1.37    1.37    0.00   0.70  16.00
dm-17             0.00     0.00 5847.00 37406.00    22.84 146.12     
8.00   172.03    4.07    0.15    4.68   0.02  96.40

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdg            1439.00    44.00 1562.00   21.00    12.91     0.25 
17.02     0.20    0.13    0.12    0.95   0.11  18.00
sdd            1434.00    64.00 1571.00   15.00    12.87     0.30 
17.00     0.17    0.11    0.10    1.07   0.11  16.80
sda            1447.00    66.00 1568.00   23.00    12.89     0.34 
17.03     0.13    0.08    0.07    0.70   0.08  12.80
sdf            1464.00    66.00 1561.00   22.00    12.95     0.35 
17.20     0.11    0.07    0.06    0.73   0.07  10.80
sde            1454.00    78.00 1567.00   30.00    12.93     0.41 
17.10     0.18    0.11    0.09    0.93   0.11  16.80
sdc            1478.00    91.00 1575.00   32.00    13.05     0.47 
17.23     0.19    0.12    0.09    1.50   0.09  14.40
sdb            1464.00   102.00 1581.00   27.00    13.12     0.50 
17.35     0.20    0.12    0.08    2.67   0.11  17.60
md1               0.00     0.00 20847.00   45.00    90.04 1.66     
8.99     0.00    0.00    0.00    0.00   0.00   0.00
drbd2             0.00     0.00 20845.00   44.00    90.04 1.66     
8.99     6.39    0.31    0.30    2.00   0.03  71.60
dm-8              0.00     0.00 10369.00    0.00    40.50 0.00     
8.00     5.66    0.55    0.55    0.00   0.01   5.20
dm-12             0.00     0.00  231.00   44.00     9.51     1.66 
83.20     0.10    0.36    0.05    2.00   0.17   4.80
dm-17             0.00     0.00 10237.00    0.00    39.99 0.00     
8.00     0.68    0.07    0.07    0.00   0.07  67.60

Another 15 seconds of 0.00 wMB/s on dm-17

In fact, the peak value is 180.00 and the minimum is 0.00, with a total 
of 44 seconds of 0.00 and 16seconds over 100.00 and 16 seconds between 0 
and 100.

Here is a look at top -b -d 0.5 -n 60|grep ^\%Cpu
%Cpu0  :  2.1 us, 29.2 sy,  0.0 ni,  4.2 id, 64.6 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  1.9 us, 11.5 sy,  0.0 ni, 78.8 id,  7.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us, 12.0 sy,  0.0 ni, 88.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  7.8 sy,  0.0 ni, 90.2 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us, 24.4 sy,  0.0 ni,  6.7 id, 66.7 wa,  0.0 hi,  2.2 si,  
0.0 st
%Cpu1  :  0.0 us, 13.5 sy,  0.0 ni, 75.0 id, 11.5 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  6.0 sy,  0.0 ni, 94.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  2.1 sy,  0.0 ni, 97.9 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  0.0 us, 25.5 sy,  0.0 ni, 14.9 id, 57.4 wa,  0.0 hi,  2.1 si,  
0.0 st
%Cpu1  :  2.0 us,  8.2 sy,  0.0 ni, 75.5 id, 14.3 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  4.1 sy,  0.0 ni, 93.9 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  9.8 sy,  0.0 ni, 90.2 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  2.2 us, 32.6 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  4.3 si,  
0.0 st
%Cpu1  :  2.0 us,  3.9 sy,  0.0 ni, 92.2 id,  2.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  7.7 sy,  0.0 ni, 92.3 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  4.0 us, 42.0 sy,  0.0 ni,  0.0 id, 54.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  0.0 us,  2.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  1.9 sy,  0.0 ni, 98.1 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  2.2 us, 39.1 sy,  0.0 ni,  0.0 id, 58.7 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu1  :  2.0 us,  0.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  0.0 us,  2.0 sy,  0.0 ni, 98.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu0  :  2.2 us, 34.8 sy,  0.0 ni,  4.3 id, 56.5 wa,  0.0 hi,  2.2 si,  
0.0 st
%Cpu1  :  0.0 us,  3.8 sy,  0.0 ni, 94.2 id,  1.9 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu2  :  0.0 us,  3.9 sy,  0.0 ni, 96.1 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
%Cpu3  :  1.9 us,  1.9 sy,  0.0 ni, 96.2 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st


Currently, there are no LVM snapshots at all, the raid array is in sync, 
operating normally:
md1 : active raid5 sdd1[7] sdb1[11] sdc1[10] sdf1[9] sdg1[5] sde1[8] sda1[6]
       2813087616 blocks super 1.2 level 5, 64k chunk, algorithm 2 [7/7] 
[UUUUUUU]

mdadm --detail /dev/md1
/dev/md1:
         Version : 1.2
   Creation Time : Wed Aug 22 00:47:03 2012
      Raid Level : raid5
      Array Size : 2813087616 (2682.77 GiB 2880.60 GB)
   Used Dev Size : 468847936 (447.13 GiB 480.10 GB)
    Raid Devices : 7
   Total Devices : 7
     Persistence : Superblock is persistent

     Update Time : Tue Mar 25 23:55:42 2014
           State : active
  Active Devices : 7
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : san1:1  (local to host san1)
            UUID : 707957c0:b7195438:06da5bc4:485d301c
          Events : 1713337

     Number   Major   Minor   RaidDevice State
        7       8       49        0      active sync   /dev/sdd1
        6       8        1        1      active sync   /dev/sda1
        8       8       65        2      active sync   /dev/sde1
        5       8       97        3      active sync   /dev/sdg1
        9       8       81        4      active sync   /dev/sdf1
       10       8       33        5      active sync   /dev/sdc1
       11       8       17        6      active sync   /dev/sdb1


Also, the DRBD is disconnected:
  2: cs:WFConnection ro:Primary/Unknown ds:UpToDate/DUnknown C r-----
     ns:79767379 nr:0 dw:137515806 dr:388623024 al:37206 bm:6688 lo:0 
pe:0 ua:0 ap:0 ep:1 wo:f oos:58639192

So, I know dd isn't the ideal performance testing tool or metric, but 
I'd really like to know why I can't get more than 40MB/s. There is no 
networking, no iscsi, just a fairly simple raid5, drbd, and lvm.

So, am I crazy? What totally retarded thing have I done here?


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
