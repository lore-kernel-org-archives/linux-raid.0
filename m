From: Christopher Smith <csmith@nighthawkrad.net>
Subject: RAID5 rebuild question
Date: Sun, 03 Jul 2005 16:20:09 +1000
Message-ID: <42C78399.5030501@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

While waiting for a rather large RAID5 array to build, I noticed the 
following output from iostat -k 1:

Linux 2.6.11-1.1369_FC4smp (justinstalled.syd.nighthawkrad.net) 
04/07/05

avg-cpu:  %user   %nice    %sys %iowait   %idle
            1.10    0.00    5.24    2.45   91.21

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               7.79        58.17        46.26      82741      65802
sda              86.70      8221.20       391.64   11693016     557032
sdb              81.11      8221.16        15.06   11692952      21416
sdc              80.85      8221.18        14.16   11692980      20136
sdd              80.93      8221.20        15.06   11693016      21416
sde              81.01      8221.20        15.37   11693016      21864
sdf              80.79      8221.20        14.16   11693016      20136
sdg              80.91      8221.20        14.52   11693016      20648
sdh              79.67      8221.16         6.91   11692952       9832
sdi              78.95      8221.20         0.03   11693016         40
sdj              79.04      8221.20         0.03   11693016         40
sdk              79.48      8221.20         0.03   11693016         40
sdl              93.28         0.33      8269.91        472   11762288
md0               1.60         0.00       102.28          0     145472

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.49    0.00    7.35    0.00   92.16

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               0.00         0.00         0.00          0          0
sda             100.99      9417.82         0.00       9512          0
sdb             101.98      9417.82         0.00       9512          0
sdc             100.00      9417.82         0.00       9512          0
sdd              98.02      9417.82         0.00       9512          0
sde              96.04      9417.82         0.00       9512          0
sdf              96.04      9417.82         0.00       9512          0
sdg              96.04      9417.82         0.00       9512          0
sdh              96.04      9417.82         0.00       9512          0
sdi              99.01      9417.82         0.00       9512          0
sdj             100.00      9417.82         0.00       9512          0
sdk              99.01      9417.82         0.00       9512          0
sdl             109.90         0.00      9504.95          0       9600
md0               0.00         0.00         0.00          0          0

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.00    0.00    5.53    0.00   94.47

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               0.00         0.00         0.00          0          0
sda             102.02      9765.66         0.00       9668          0
sdb             108.08      9765.66         0.00       9668          0
sdc             108.08      9765.66         0.00       9668          0
sdd             108.08      9765.66         0.00       9668          0
sde             103.03      9765.66         0.00       9668          0
sdf             103.03      9765.66         0.00       9668          0
sdg             103.03      9765.66         0.00       9668          0
sdh             102.02      9765.66         0.00       9668          0
sdi             105.05      9765.66         0.00       9668          0
sdj             105.05      9765.66         0.00       9668          0
sdk             103.03      9765.66         0.00       9668          0
sdl             120.20         0.00      9696.97          0       9600
md0               0.00         0.00         0.00          0          0

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.00    0.00    6.00    0.00   94.00

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               0.00         0.00         0.00          0          0
sda             109.90      9500.99         0.00       9596          0
sdb             103.96      9500.99         0.00       9596          0
sdc             107.92      9500.99         0.00       9596          0
sdd             106.93      9500.99         0.00       9596          0
sde             104.95      9500.99         0.00       9596          0
sdf             102.97      9500.99         0.00       9596          0
sdg             104.95      9500.99         0.00       9596          0
sdh             102.97      9500.99         0.00       9596          0
sdi             101.98      9500.99         0.00       9596          0
sdj             101.98      9500.99         0.00       9596          0
sdk             101.98      9500.99         0.00       9596          0
sdl             154.46         0.00      9536.63          0       9632
md0               0.00         0.00         0.00          0          0

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.00    0.00    5.50    0.00   94.50

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               0.00         0.00         0.00          0          0
sda             100.99      9401.98         0.00       9496          0
sdb             100.00      9401.98         0.00       9496          0
sdc              98.02      9401.98         0.00       9496          0
sdd             100.00      9401.98         0.00       9496          0
sde              97.03      9401.98         0.00       9496          0
sdf              94.06      9401.98         0.00       9496          0
sdg              95.05      9401.98         0.00       9496          0
sdh              96.04      9401.98         0.00       9496          0
sdi              96.04      9401.98         0.00       9496          0
sdj              95.05      9401.98         0.00       9496          0
sdk              97.03      9401.98         0.00       9496          0
sdl             127.72         0.00      9600.00          0       9696
md0               0.00         0.00         0.00          0          0

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.00    0.00    5.97    0.00   94.03

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hda               2.00         0.00        32.00          0         32
sda              90.00      9676.00         0.00       9676          0
sdb              91.00      9676.00         0.00       9676          0
sdc              90.00      9676.00         0.00       9676          0
sdd              90.00      9676.00         0.00       9676          0
sde              90.00      9676.00         0.00       9676          0
sdf              89.00      9676.00         0.00       9676          0
sdg              89.00      9676.00         0.00       9676          0
sdh              89.00      9676.00         0.00       9676          0
sdi              89.00      9676.00         0.00       9676          0
sdj              89.00      9676.00         0.00       9676          0
sdk              89.00      9676.00         0.00       9676          0
sdl             124.00         0.00      9600.00          0       9600
md0               0.00         0.00         0.00          0          0


Devices sd[a-l] make up /dev/md0:
[root@justinstalled ~]# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sdl[12] sdk[10] sdj[9] sdi[8] sdh[7] sdg[6] sdf[5] 
sde[4] sdd[3] sdc[2] sdb[1] sda[0]
       1719198976 blocks level 5, 128k chunk, algorithm 2 [12/11] 
[UUUUUUUUUUU_]
       [>....................]  recovery =  2.4% (3837952/156290816) 
finish=256.7min speed=9895K/sec
unused devices: <none>
[root@justinstalled ~]#


Why are all the writes concentrated on a single drive ?  Shouldn't the 
reads and writes be being distributed evenly amongst all the drives ? 
Or is this just something unique to the rebuild phase ?

CS
