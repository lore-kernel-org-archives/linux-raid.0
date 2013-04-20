From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Sun, 21 Apr 2013 02:26:26 +0300
Message-ID: <51732422.1050109@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com> <51725458.7020109@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

They are connected through SATA2 ports (this does explain the read speed 
but not the pitiful write one) in AHCI.

Ok, I redid the test with '-d 6' seconds and 'noop' scheduler during the 
same file copy and these are the entire results:

root [~]# iostat -d 6 -k
Linux 2.6.32-358.2.1.el6.x86_64 (host)      04/21/2013 _x86_64_(8 CPU)

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             245.95       832.69       591.13  219499895 155823699
sdb             190.80       572.24       590.88  150844446 155758671
md1               1.15         2.15         2.43     567732 641156
md2             406.02      1368.44       587.74  360725304 154930520
md0               0.06         0.23         0.00      59992 171

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              34.17         0.00      4466.00          0 26796
sdb               9.67         0.00      4949.33          0 29696
md1               0.00         0.00         0.00 0          0
md2            1116.50         0.00      4466.00          0 26796
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              35.17         0.00      5475.33          0 32852
sdb               9.33         2.00      4522.67         12 27136
md1               0.00         0.00         0.00 0          0
md2            1369.67         8.00      5475.33         48 32852
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              40.33         0.00      3160.00          0 18960
sdb              19.50         0.00      7882.00          0 47292
md1               0.00         0.00         0.00 0          0
md2             790.50         2.67      3160.00         16 18960
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              77.67         4.00     15328.00         24 91968
sdb              50.33        16.00     10972.67         96 65836
md1               0.00         0.00         0.00 0          0
md2            3834.33         9.33     15328.00         56 91968
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              66.67        48.00     10604.00        288 63624
sdb              23.17         0.00      9660.00          0 57960
md1               0.00         0.00         0.00 0          0
md2            2653.50        51.33     10604.00        308 63624
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              37.83        24.67      5378.67        148 32272
sdb              13.17         3.33      6315.33         20 37892
md1               0.00         0.00         0.00 0          0
md2            1345.17        26.00      5378.67        156 32272
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             132.50         4.67     22714.00         28 136284
sdb              32.33        20.00     12328.00        120 73968
md1               0.00         0.00         0.00 0          0
md2            5713.67        31.33     22843.33        188 137060
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              58.17         6.00      8200.00         36 49200
sdb              23.00         8.00     11349.33         48 68096
md1               0.00         0.00         0.00 0          0
md2            1936.17        21.33      7729.33        128 46376
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda               6.17         0.00        24.67          0 148
sdb              10.00         0.00      5120.00          0 30720
md1               0.00         0.00         0.00 0          0
md2               6.17         0.00        24.67          0 148
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda               1.50         0.00         5.33 0         32
sdb              14.17         0.00      7170.67          0 43024
md1               0.00         0.00         0.00 0          0
md2               1.50         0.00         5.33 0         32
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda             256.00       346.67      1105.17       2080 6631
sdb             270.83       544.00      7029.17       3264 42175
md1              49.33       170.00        27.33       1020 164
md2             311.83       705.33      1076.67       4232 6460
md0               0.00         0.00         0.00 0          0

Device:            tps    kB_read/s    kB_wrtn/s    kB_read kB_wrtn
sda              51.17        46.67       219.08        280 1314
sdb              48.67       140.00       219.08        840 1314
md1              20.67        82.67         0.00 496          0
md2              58.00       104.00       218.00        624 1308
md0               0.00         0.00         0.00 0          0

Thank you for your time.

Kind regards!

On 20/04/2013 4:11 PM, Roberto Spadim wrote:
>
> Hum at beginning you have more iops than the end, how you connected 
> this devices, normally a ssd can handler more than 1000 iops and a hd 
> no more than 300iops, how did you configured the queue of ssd disks? 
> Could you change it to noop and test again?
>
> Em 20/04/2013 05:39, "Andrei Banu" <andrei.banu@redhost.ro 
> <mailto:andrei.banu@redhost.ro>> escreveu:
>
>     Hi,
>
>     I ran with '-d 3' iostat during a "heavy" (540MB) copy. It took a
>     bit over a minute and completed with less than 9MB/s. These are
>     some of the results (this does NOT include the first batch i.e.
>     the average from start up result):
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda             503.00      1542.67     28157.33 4628      84472
>     sdb              66.00        72.00     13162.67 216      39488
>     md1             373.00      1492.00         0.00 4476          0
>     md2            6951.67       126.67     27734.67 380      83204
>     md0               0.00         0.00         0.00 0          0
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda              56.67        20.00      1177.50 60       3532
>     sdb              47.33        12.00     10824.17 36      32472
>     md1               0.67         2.67         0.00 8          0
>     md2             322.00        25.33      1266.67 76       3800
>     md0               0.00         0.00         0.00 0          0
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda             122.00        16.00     45773.33 48     137320
>     sdb              96.67        14.67     19472.00 44      58416
>     md1               0.00         0.00         0.00 0          0
>     md2           11431.00        32.00     45684.00 96     137052
>     md0               0.00         0.00         0.00 0          0
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda               0.00         0.00         0.00 0          0
>     sdb              13.67         8.00      5973.33 24      17920
>     md1               0.00         0.00         0.00 0          0
>     md2               2.00         8.00         0.00 24          0
>     md0               0.00         0.00         0.00 0          0
>
>     This is the "normal" iostat took after 10 minutes (this DOES
>     include the first batch i.e. the average from start up result):
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda             281.83       973.99       641.55 212615675  140045467
>     sdb             215.51       665.94       641.55 145369465  140045467
>     md1               1.18         2.17         2.56 473492     558452
>     md2             470.71      1596.29       638.01 348460340  139272912
>     md0               0.08         0.27         0.00 59983        171
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda              41.67       237.33       133.67 712        401
>     sdb              39.33        90.67       133.67 272        401
>     md1               0.00         0.00         0.00 0          0
>     md2              83.00       328.00       133.33 984        400
>     md0               0.00         0.00         0.00 0          0
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda              29.33         2.67       110.00 8        330
>     sdb              29.33         2.67       110.00 8        330
>     md1               0.00         0.00         0.00 0          0
>     md2              28.67         5.33       109.33 16        328
>     md0               0.00         0.00         0.00 0          0
>
>     Device:            tps    kB_read/s    kB_wrtn/s kB_read    kB_wrtn
>     sda             175.67         1.33       747.50 4       2242
>     sdb             182.00        56.00       747.50 168       2242
>     md1               0.00         0.00         0.00 0          0
>     md2             191.33        57.33       746.67 172       2240
>     md0               0.00         0.00         0.00 0          0
>
>     Best regards!
>
>     On 20/04/2013 3:59 AM, Roberto Spadim wrote:
>>     run some kind of iostat -d 1 -k and check the write/read  iops
>>     and kb/s
>>
>>
>>     2013/4/19 Andrei Banu <andrei.banu@redhost.ro
>>     <mailto:andrei.banu@redhost.ro>>
>>
>>         Hello!
>>
>>         I come to you with a difficult problem. We have a server
>>         otherwise snappy fitted with mdraid-1 made of Samsung 840 PRO
>>         SSDs. If we copy a larger file to the server (from the same
>>         server, from net doesn't matter) the server load will
>>         increase from roughly 0.7 to over 100 (for several GB files).
>>         Apparently the reason is that the raid can't write well.
>>
>>         Few examples:
>>
>>         root [~]# dd if=testfile.tar.gz of=test20 oflag=sync bs=4M
>>         130+1 records in
>>         130+1 records out
>>         547682517 bytes (548 MB) copied, 7.99664 s, 68.5 MB/s
>>
>>         And 10-20 seconds later I try the very same test:
>>
>>         root [~]# dd if=testfile.tar.gz of=test21 oflag=sync bs=4M
>>         130+1 records in / 130+1 records out
>>         547682517 bytes (548 MB) copied, 52.1958 s, 10.5 MB/s
>>
>>         A different test with 'bs=1G'
>>         root [~]# w
>>          12:08:34 up 1 day, 13:09,  1 user,  load average: 0.37,
>>         0.60, 0.72
>>
>>         root [~]# dd if=testfile.tar.gz of=test oflag=sync bs=1G
>>         0+1 records in / 0+1 records out
>>         547682517 bytes (548 MB) copied, 75.3476 s, 7.3 MB/s
>>
>>         root [~]# w
>>          12:09:56 up 1 day, 13:11,  1 user,  load average: 39.29,
>>         12.67, 4.93
>>
>>         It needed 75 seconds to copy a half GB file and the server
>>         load increased 100 times.
>>
>>         And a final test:
>>
>>         root@ [~]# dd if=/dev/zero of=test24 bs=64k count=16k
>>         conv=fdatasync
>>         16384+0 records in / 16384+0 records out
>>         1073741824 bytes (1.1 GB) copied, 61.8796 s, 17.4 MB/s
>>
>>         This time the load spiked to only ~ 20.
>>
>>         A few other peculiarities:
>>
>>         root@ [~]# hdparm -t /dev/sda
>>         Timing buffered disk reads:  654 MB in  3.01 seconds = 217.55
>>         MB/sec
>>         root@ [~]# hdparm -t /dev/sdb
>>         Timing buffered disk reads:  272 MB in  3.01 seconds =  90.44
>>         MB/sec
>>
>>         The read speed is very different between the 2 devices (the
>>         margin is 140%) but look what happens when I run it with
>>         --direct:
>>
>>         root@ [~]# hdparm --direct -t /dev/sda
>>         Timing O_DIRECT disk reads:  788 MB in  3.00 seconds = 262.23
>>         MB/sec
>>         root@ [~]# hdparm --direct -t /dev/sdb
>>         Timing O_DIRECT disk reads:  554 MB in  3.00 seconds = 184.53
>>         MB/sec
>>
>>         So the hardware seems to sustain speeds of about 200MB/s  on
>>         both devices but it differs greatly.
>>         The measurement of sda increased 20% but sdb doubled. Maybe
>>         there's a problem with the page cache?
>>
>>         BACKGROUND INFORMATION
>>         Server type: general shared hosting server (3 weeks new)
>>         O/S: CentOS 6.4 / 64 bit (2.6.32-358.2.1.el6.x86_64)
>>         Hardware: SuperMicro 5017C-MTRF, E3-1270v2, 16GB RAM, 2 x
>>         Samsung 840 PRO 512GB
>>         Partitioning: ~ 100GB left for over-provisioning, ext 4:
>>
>>         I believe it is aligned:
>>
>>         root [~]# fdisk -lu
>>
>>         Disk /dev/sda: 512.1 GB, 512110190592 bytes
>>         255 heads, 63 sectors/track, 62260 cylinders, total
>>         1000215216 sectors
>>         Units = sectors of 1 * 512 = 512 bytes
>>         Sector size (logical/physical): 512 bytes / 512 bytes
>>         I/O size (minimum/optimal): 512 bytes / 512 bytes
>>         Disk identifier: 0x00026d59
>>
>>            Device Boot      Start         End      Blocks Id  System
>>         /dev/sda1            2048     4196351     2097152 fd  Linux
>>         raid autodetect
>>         Partition 1 does not end on cylinder boundary.
>>         /dev/sda2   *     4196352     4605951      204800 fd  Linux
>>         raid autodetect
>>         Partition 2 does not end on cylinder boundary.
>>         /dev/sda3         4605952   814106623   404750336 fd  Linux
>>         raid autodetect
>>
>>         Disk /dev/sdb: 512.1 GB, 512110190592 bytes
>>         255 heads, 63 sectors/track, 62260 cylinders, total
>>         1000215216 sectors
>>         Units = sectors of 1 * 512 = 512 bytes
>>         Sector size (logical/physical): 512 bytes / 512 bytes
>>         I/O size (minimum/optimal): 512 bytes / 512 bytes
>>         Disk identifier: 0x0003dede
>>
>>            Device Boot      Start         End      Blocks Id  System
>>         /dev/sdb1            2048     4196351     2097152 fd  Linux
>>         raid autodetect
>>         Partition 1 does not end on cylinder boundary.
>>         /dev/sdb2   *     4196352     4605951      204800 fd  Linux
>>         raid autodetect
>>         Partition 2 does not end on cylinder boundary.
>>         /dev/sdb3         4605952   814106623   404750336 fd  Linux
>>         raid autodetect
>>
>>         The matrix is NOT degraded:
>>
>>         root@ [~]# cat /proc/mdstat
>>         Personalities : [raid1]
>>         md0 : active raid1 sdb2[1] sda2[0]
>>               204736 blocks super 1.0 [2/2] [UU]
>>         md2 : active raid1 sdb3[1] sda3[0]
>>               404750144 blocks super 1.0 [2/2] [UU]
>>         md1 : active raid1 sdb1[1] sda1[0]
>>               2096064 blocks super 1.1 [2/2] [UU]
>>         unused devices: <none>
>>
>>         Write cache is on:
>>
>>         root@ [~]# hdparm -W /dev/sda
>>         write-caching =  1 (on)
>>         root@ [~]# hdparm -W /dev/sdb
>>         write-caching =  1 (on)
>>
>>         SMART seems to be OK:
>>         SMART overall-health self-assessment test result: PASSED (for
>>         both devices)
>>
>>         I have tried changing IO scheduler with NOOP and deadline but
>>         I couldn't see improvements.
>>
>>         I have tried running fstrim but it errors out:
>>
>>         root [~]# fstrim -v /
>>         fstrim: /: FITRIM ioctl failed: Operation not supported
>>
>>         So I have changed /etc/fstab to contain noatime and discard
>>         and rebooted the server but to no avail.
>>
>>         I no longer know what to do. And I need to come up with some
>>         sort of a solution (it's not reasonable nor acceptable to get
>>         at 3 digits loads from copying several GBs worth of file). If
>>         anyone can help me, please do!
>>
>>         Thanks in advance!
>>         Andy
>>         --
>>         To unsubscribe from this list: send the line "unsubscribe
>>         linux-raid" in
>>         the body of a message to majordomo@vger.kernel.org
>>         <mailto:majordomo@vger.kernel.org>
>>         More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>>     -- 
>>     Roberto Spadim
>

