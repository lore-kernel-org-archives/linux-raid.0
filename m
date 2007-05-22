From: Thomas Jager <lists@jager.no>
Subject: Raid-5 long write wait while reading
Date: Tue, 22 May 2007 20:03:23 +0200
Message-ID: <4653306B.4090500@jager.no>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list.

I run a file server on MD raid-5.
If a client reads one big file and at the same time another client tries 
to write a file, the thread writing just sits in uninterruptible sleep 
until the reader has finished. Only very small amount of writes get 
trough while the reader is still working.
I'm having some trouble pinpointing the problem.
It's not consistent either sometimes it works as expected both the 
reader and writer gets some transactions. On huge reads I've seen the 
writer blocked for 30-40 minutes without any significant writes 
happening (Maybe a few megabytes, of several gigs waiting). It happens 
with NFS, SMB and FTP, and local with dd. And seems to be connected to 
raid-5. This does not happen on block devices without raid-5. I'm also 
wondering if it can have anything to do with loop-aes? I use loop-aes on 
top of the md, but then again i have not observed this problem on 
loop-devices with disk backend. I do know that loop-aes degrades 
performance but i didn't think it would do something like this?

I've seen this problem in 2.6.16-2.6.21

All disks in the array is connected to a controller with a SiI 3114 chip.

vmstat while one reader (on gigabit network) is running and one writer 
(on gigabit network) is trying it's thing.
# vmstat -n 5
procs -----------memory---------- ---swap-- -----io---- -system-- 
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy 
id wa
 1  2    152  52664  19952 1137532    0    0     9     6   12    9  7  5 
81  6
 0  3    152  52640  19896 1138232    0    0 13934     0 1427 1683  1 
12  0 87
 1  3    152  52572  19908 1138540    0    0 13956     0 1418 1610  1 
13  0 86
 0  3    152  51668  19820 1139152    0    0 13876     0 1421 1618  2 
12  0 86
 0  3    152  52176  19812 1138708    0    0 13980     0 1434 1622  1 
13  0 86
 0  3    152  52744  20068 1144536    0    0 14833   855 1763 2292  2 
14  1 83
 0  2    152  52600  20356 1138536    0    0 18538    22 2061 2126  1 
17  1 81
 1  2    152  52624  20748 1137716    0    0 19246     0 1969 2297  1 
17  0 81
 1  2    152  52720  21140 1136976    0    0 20960     0 2119 2425  4 
20  1 74
 0  3    152  52876  21792 1136028    0    0 18807    12 1972 2241  1 
17  0 82
...
 1  3    152  52608  22380 1136296    0    0    12     6   13    9  7  5 
81  6
 0  2    152  52548  22044 1136296    0    0 16982     0 1739 1993  2 
15  0 83
 0  3    152  52736  21824 1136440    0    0 18679     0 1838 2215  1 
17  1 81
 1  3    152  51228  22016 1137536    0    0 15984    14 1615 1974  2 
14  1 84
 0  3    152  51176  22028 1137964    0    0 16910     8 1717 2016  1 
15  0 83
 3  2    152  51912  21812 1137352    0    0 18071     1 1792 2106  2 
16  1 82
 1  2    152  52940  21804 1136376    0    0 15441     1 1586 1916  1 
14  0 85
 0  3    152  51912  21808 1137368    0    0 16938     0 1653 1967  1 
15  1 83
 1  3    152  52608  21836 1136108    0    0 17174    13 1683 1920  2 
15  0 83
 0  3    152  52752  21712 1136092    0    0 16534     0 1640 1890  1 
15  1 83
 1  2    152  52248  21496 1137328    0    0 16520     2 1640 1757  2 
15  0 83

the array:
md0 : active raid5 sdh[0] sdi[7] sdn[6] sdk[5] sdl[4] sdj[3] sdm[2] sdg[1]
      3418705472 blocks level 5, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]


iostat snapshot while a writer i blocked:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.50    0.00   11.44   86.57    0.00    1.49

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hdd               0.00         0.00         0.00          0          0
sda               0.00         0.00         0.00          0          0
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg              28.43      1694.12         0.00       1728          0
sdh              88.24      1847.06         0.00       1884          0
sdi              28.43      1752.94         0.00       1788          0
sdj              27.45      1694.12         0.00       1728          0
sdk              28.43      1756.86         0.00       1792          0
sdl              38.24      1717.65         0.00       1752          0
sdm              52.94      1694.12         0.00       1728          0
sdn              45.10      1733.33         0.00       1768          0
md0            3462.75     13850.98         0.00      14128          0
dm-0              0.00         0.00         0.00          0          0
dm-1              0.00         0.00         0.00          0

One more, some time later:
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.51    0.00   12.06   85.43    0.00    0.00

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
hdd               0.00         0.00         0.00          0          0
sda              14.14        64.65         0.00         64          0
sdb               0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdg              26.26      1551.52         0.00       1536          0
sdh              63.64      1672.73         0.00       1656          0
sdi              30.30      1551.52         0.00       1536          0
sdj              30.30      1555.56         0.00       1540          0
sdk              24.24      1551.52         0.00       1536          0
sdl              28.28      1551.52         0.00       1536          0
sdm              35.35      1559.60         0.00       1544          0
sdn              32.32      1551.52         0.00       1536          0
md0            3136.36     12545.45         0.00      12420          0
dm-0              0.00         0.00         0.00          0          0
dm-1              0.00         0.00         0.00          0          0


The hardware should be pretty standard: (lspci)
00:00.0 "Host bridge" "Intel Corporation" "82865G/PE/P DRAM 
Controller/Host-Hub Interface" -r02 "Unknown vendor 1919" "Unknown 
device 1002"
00:01.0 "PCI bridge" "Intel Corporation" "82865G/PE/P PCI to AGP 
Controller" -r02 "" ""
00:03.0 "PCI bridge" "Intel Corporation" "82865G/PE/P PCI to CSA Bridge" 
-r02 "" ""
00:1d.0 "USB Controller" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) 
USB UHCI Controller #1" -r02 "Unknown vendor 1919" "Unknown device 1002"
00:1d.1 "USB Controller" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) 
USB UHCI Controller #2" -r02 "Unknown vendor 1919" "Unknown device 1002"
00:1d.2 "USB Controller" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) 
USB UHCI Controller #3" -r02 "Unknown vendor 1919" "Unknown device 1002"
00:1d.3 "USB Controller" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) 
USB UHCI Controller #4" -r02 "Unknown vendor 1919" "Unknown device 1002"
00:1d.7 "USB Controller" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) 
USB2 EHCI Controller" -r02 -p20 "Unknown vendor 1919" "Unknown device 1002"
00:1e.0 "PCI bridge" "Intel Corporation" "82801 PCI Bridge" -rc2 "" ""
00:1f.0 "ISA bridge" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge" -r02 "" ""
00:1f.1 "IDE interface" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) IDE 
Controller" -r02 -p8a "Unknown vendor 1919" "Unknown device 1002"
00:1f.2 "IDE interface" "Intel Corporation" "82801EB (ICH5) SATA 
Controller" -r02 -p8f "Intel Corporation" "82801EB (ICH5) SATA Controller"
00:1f.3 "SMBus" "Intel Corporation" "82801EB/ER (ICH5/ICH5R) SMBus 
Controller" -r02 "Unknown vendor 1919" "Unknown device 1002"
01:00.0 "VGA compatible controller" "nVidia Corporation" "NV5M64 [RIVA 
TNT2 Model 64/Model 64 Pro]" -r15 "LeadTek Research Inc." "Unknown 
device 2137"
02:01.0 "Ethernet controller" "Intel Corporation" "82547EI Gigabit 
Ethernet Controller (LOM)" "Unknown vendor 1919" "Unknown device 1002"
03:03.0 "Mass storage controller" "Silicon Image, Inc." "SiI 3114 
[SATALink/SATARaid] Serial ATA Controller" -r02 "Silicon Image, Inc." 
"SiI 3114 SATALink Controller"
03:04.0 "FireWire (IEEE 1394)" "VIA Technologies, Inc." "IEEE 1394 Host 
Controller" -r80 -p10 "Unknown vendor 1919" "Unknown device 1002"
03:05.0 "RAID bus controller" "Integrated Technology Express, Inc." 
"IT/ITE8212 Dual channel ATA RAID controller (PCI version seems to be 
IT8212, embedded seems to be ITE8212)" -r11 "Integrated Technology 
Express, Inc." "IT/ITE8212 Dual channel ATA RAID controller"
03:09.0 "RAID bus controller" "Silicon Image, Inc." "SiI 3114 
[SATALink/SATARaid] Serial ATA Controller" -r02 "Silicon Image, Inc." 
"Unknown device 7114"
03:0d.0 "RAID bus controller" "Silicon Image, Inc." "SiI 3114 
[SATALink/SATARaid] Serial ATA Controller" -r02 "Silicon Image, Inc." 
"SiI 3114 SATARaid Controller"

Thanks for reading.
