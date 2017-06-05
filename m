From: CoolCold <coolthecold@gmail.com>
Subject: internal write-intent bitmap is horribly slow with RAID10 over 20 drives
Date: Mon, 5 Jun 2017 17:06:11 +0700
Message-ID: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
Keep testing the new box and while having not the best sync speed,
it's not the worst thing I found.

Doing FIO testing, for RAID10 over 20 10k RPM drives, I have very bad
performance, like _45_ iops only.

Drives:
=== START OF INFORMATION SECTION ===
Vendor:               TOSHIBA
Product:              AL14SEB18EQ
Revision:             0101
User Capacity:        1,800,360,124,416 bytes [1.80 TB]
Logical block size:   512 bytes
Physical block size:  4096 bytes
Lowest aligned LBA:   0
Rotation Rate:        10500 rpm
Form Factor:          2.5 inches
Logical Unit id:      0x500003975840f759
Serial number:        X6K0A0D5FZRC
Device type:          disk
Transport protocol:   SAS
Local Time is:        Mon Jun  5 09:51:56 2017 UTC
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled


Output from fio with internal write-intent bitmap:
Jobs: 1 (f=1): [w(1)] [28.3% done] [0KB/183KB/0KB /s] [0/45/0 iops]
[eta 07m:11s]

array definition:
[root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
      17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
[UUUUUUUUUUUUUUUUUUUU]
      bitmap: 0/66 pages [0KB], 131072KB chunk

Setting journal to be
1) on SSD (separate drives), shows
Jobs: 1 (f=1): [w(1)] [5.0% done] [0KB/18783KB/0KB /s] [0/4695/0 iops]
[eta 09m:31s]
2) to 'none' (disabling) shows
Jobs: 1 (f=1): [w(1)] [14.0% done] [0KB/18504KB/0KB /s] [0/4626/0
iops] [eta 08m:36s]

All bitmap manipulations was on running array,

Sample output from iostat with internal bitmap (array of interest is md1):
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdz               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdy               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdc               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00   47.00     0.00   542.00
23.06     0.67   14.34    0.00   14.34  14.28  67.10
sdh               0.00     0.00    0.00   50.00     0.00   734.00
29.36     0.68   13.66    0.00   13.66  13.60  68.00
sdi               0.00     0.00    0.00   46.00     0.00   478.00
20.78     0.67   14.63    0.00   14.63  14.54  66.90
sdf               0.00     0.00    0.00   47.00     0.00   542.00
23.06     0.67   14.28    0.00   14.28  14.21  66.80
sdl               0.00     0.00    0.00   45.00     0.00   414.00
18.40     0.66   14.78    0.00   14.78  14.69  66.10
sdn               0.00     0.00    0.00   44.00     0.00   350.00
15.91     0.66   14.95    0.00   14.95  14.95  65.80
sdj               0.00     0.00    0.00   46.00     0.00   478.00
20.78     0.65   14.22    0.00   14.22  14.13  65.00
sdk               0.00     0.00    0.00   46.00     0.00   418.00
18.17     0.65   14.35    0.00   14.35  13.98  64.30
sdm               0.00     0.00    0.00   44.00     0.00   350.00
15.91     0.62   14.18    0.00   14.18  14.14  62.20
sdp               0.00     0.00    0.00   43.00     0.00   286.00
13.30     0.62   14.56    0.00   14.56  14.51  62.40
sdg               0.00     0.00    0.00   50.00     0.00   734.00
29.36     0.68   13.58    0.00   13.58  13.52  67.60
sdv               0.00     0.00    0.00   43.00     0.00   346.00
16.09     0.67   15.19    0.00   15.19  15.49  66.60
sdr               0.00     0.00    0.00   44.00     0.00   410.00
18.64     0.66   14.59    0.00   14.59  14.86  65.40
sds               0.00     0.00    0.00   43.00     0.00   286.00
13.30     0.65   15.07    0.00   15.07  15.02  64.60
sdt               0.00     0.00    0.00   42.00     0.00   282.00
13.43     0.65   15.17    0.00   15.17  15.48  65.00
sdo               0.00     0.00    0.00   43.00     0.00   286.00
13.30     0.64   14.93    0.00   14.93  14.88  64.00
sdq               0.00     0.00    0.00   45.00     0.00   414.00
18.40     0.66   14.67    0.00   14.67  14.62  65.80
sdw               0.00     0.00    0.00   43.00     0.00   346.00
16.09     0.66   14.93    0.00   14.93  15.21  65.40
sdu               0.00     0.00    0.00   44.00     0.00   350.00
15.91     0.64   14.55    0.00   14.55  14.50  63.80
sdx               0.00     0.00    0.00   44.00     0.00   350.00
15.91     0.64   14.55    0.00   14.55  14.48  63.70
md127             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md126             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md125             0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md1               0.00     0.00    0.00   41.00     0.00  2624.00
128.00     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00    0.00    0.00   0.00   0.00


The same picture on 3.10.0-327.el7.x86_64 and 4.11 kernel.

Any advises would be very helpful.

-- 
Best regards,
[COOLCOLD-RIPN]
