From: Max Eaves <max@maxeaves.co.uk>
Subject: Write performance of RAID 6 Volume
Date: Tue, 13 Apr 2010 17:05:44 +0100
Message-ID: <4BC49658.9080808@maxeaves.co.uk>
Reply-To: max@maxeaves.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

Thank you answering my last question in terms of the RAID6 volume 
scanning; I have another question.

I built a device with a large number of disks (see below). Each RAID set 
/dev/md1[0-2] has 15 drives attached to it....and the

My concern is that ~write~ I/O is really poor; I have tweaked a number 
of kernel parameters and my ~read~ I/O is rather good (a fact of 1:3) 
i.e. read speed seems to be three times quicker.

I have trolled through Google to see if there are any suggestions that I 
can look at, but I wanted some thoughts to see if I can improve things.

Some considerations:

All the RAIDing is done via mdadm (hence my question to this forum).  
There are no real proper hardware controllers.   I am will never expect 
anything other than mediocre / poor performance out of this system, but 
the parity between read and write speeds seem high.

System is Centos 5.4 with a 2.6.18-164.15.1.el5 kernel #1 SMP Wed Mar 17 
11:30:06 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

mdadm - v2.6.9 - 10th March 2009

4G RAM


Any obvious pointer gratefully received.


Best Wishes




Max

The Drives:

/dev/md10              18T  2.1T   16T  12% /media/proxies
/dev/md11              18T  5.5T   13T  31% /media/mediastorage1
/dev/md12              18T  3.2T   15T  18% /media/mediastorage2

md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdc1 ...
md:  adding sdc1 ...
md:  adding sdd1 ...
md:  adding sde1 ...
md:  adding sdf1 ...
md:  adding sdg1 ...
md:  adding sdh1 ...
md:  adding sdi1 ...
md:  adding sdj1 ...
md:  adding sdk1 ...
md:  adding sdl1 ...
md:  adding sdm1 ...
md:  adding sdn1 ...
md:  adding sdo1 ...
md:  adding sdp1 ...
md:  adding sdq1 ...
md: sdr1 has different UUID to sdc1
md: sds1 has different UUID to sdc1
md: sdt1 has different UUID to sdc1
md: sdu1 has different UUID to sdc1
md: sdv1 has different UUID to sdc1
md: sdw1 has different UUID to sdc1
md: sdx1 has different UUID to sdc1
md: sdy1 has different UUID to sdc1
md: sdz1 has different UUID to sdc1
md: sdaa1 has different UUID to sdc1
md: sdab1 has different UUID to sdc1
md: sdac1 has different UUID to sdc1
md: sdad1 has different UUID to sdc1
md: sdae1 has different UUID to sdc1
md: sdaf1 has different UUID to sdc1
md: sdag1 has different UUID to sdc1
md: sdah1 has different UUID to sdc1
md: sdai1 has different UUID to sdc1
md: sdaj1 has different UUID to sdc1
md: sdak1 has different UUID to sdc1
md: sdal1 has different UUID to sdc1
md: sdam1 has different UUID to sdc1
md: sdan1 has different UUID to sdc1
md: sdao1 has different UUID to sdc1
md: sdap1 has different UUID to sdc1
md: sdaq1 has different UUID to sdc1
md: sdar1 has different UUID to sdc1
md: sdas1 has different UUID to sdc1
md: sdat1 has different UUID to sdc1
md: sdau1 has different UUID to sdc1
md: created md10
md: bind<sdq1>
md: bind<sdp1>
md: bind<sdo1>
md: bind<sdn1>
md: bind<sdm1>
md: bind<sdl1>
md: bind<sdk1>
md: bind<sdj1>
md: bind<sdi1>
md: bind<sdh1>
md: bind<sdg1>
md: bind<sdf1>
md: bind<sde1>
md: bind<sdd1>
md: bind<sdc1>
md: running:<sdc1><sdd1><sde1><sdf1><sdg1><sdh1><sdi1><sdj1><sdk1><sdl1><sdm1><sdn1><sdo1><sdp1><sdq1>
raid5: automatically using best checksumming function: generic_sse
    generic_sse:  8852.000 MB/sec
raid5: using function: generic_sse (8852.000 MB/sec)
raid6: int64x1   1921 MB/s
raid6: int64x2   2355 MB/s
raid6: int64x4   2187 MB/s
raid6: int64x8   1812 MB/s
raid6: sse2x1    4082 MB/s
raid6: sse2x2    4582 MB/s
raid6: sse2x4    6808 MB/s
raid6: using algorithm sse2x4 (6808 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: device sdc1 operational as raid disk 0
raid5: device sdd1 operational as raid disk 1
raid5: device sde1 operational as raid disk 2
raid5: device sdf1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 4
raid5: device sdh1 operational as raid disk 5
raid5: device sdi1 operational as raid disk 6
raid5: device sdj1 operational as raid disk 7
raid5: device sdk1 operational as raid disk 8
raid5: device sdl1 operational as raid disk 9
raid5: device sdm1 operational as raid disk 10
raid5: device sdn1 operational as raid disk 11
raid5: device sdo1 operational as raid disk 12
raid5: device sdp1 operational as raid disk 13
raid5: device sdq1 operational as raid disk 14
raid5: allocated 15812kB for md10
raid5: raid level 6 set md10 active with 15 out of 15 devices, algorithm 2
RAID5 conf printout:
  --- rd:15 wd:15 fd:0
  disk 0, o:1, dev:sdc1
  disk 1, o:1, dev:sdd1
  disk 2, o:1, dev:sde1
  disk 3, o:1, dev:sdf1
  disk 4, o:1, dev:sdg1
  disk 5, o:1, dev:sdh1
  disk 6, o:1, dev:sdi1
  disk 7, o:1, dev:sdj1
  disk 8, o:1, dev:sdk1
  disk 9, o:1, dev:sdl1
  disk 10, o:1, dev:sdm1
  disk 11, o:1, dev:sdn1
  disk 12, o:1, dev:sdo1
  disk 13, o:1, dev:sdp1
  disk 14, o:1, dev:sdq1
md: considering sdr1 ...
md:  adding sdr1 ...
md:  adding sds1 ...
md:  adding sdt1 ...
md:  adding sdu1 ...
md:  adding sdv1 ...
md:  adding sdw1 ...
md:  adding sdx1 ...
md:  adding sdy1 ...
md:  adding sdz1 ...
md:  adding sdaa1 ...
md:  adding sdab1 ...
md:  adding sdac1 ...
md:  adding sdad1 ...
md:  adding sdae1 ...
md:  adding sdaf1 ...
md: sdag1 has different UUID to sdr1
md: sdah1 has different UUID to sdr1
md: sdai1 has different UUID to sdr1
md: sdaj1 has different UUID to sdr1
md: sdak1 has different UUID to sdr1
md: sdal1 has different UUID to sdr1
md: sdam1 has different UUID to sdr1
md: sdan1 has different UUID to sdr1
md: sdao1 has different UUID to sdr1
md: sdap1 has different UUID to sdr1
md: sdaq1 has different UUID to sdr1
md: sdar1 has different UUID to sdr1
md: sdas1 has different UUID to sdr1
md: sdat1 has different UUID to sdr1
md: sdau1 has different UUID to sdr1
md: created md11
md: bind<sdaf1>
md: bind<sdae1>
md: bind<sdad1>
md: bind<sdac1>
md: bind<sdab1>
md: bind<sdaa1>
md: bind<sdz1>
md: bind<sdy1>
md: bind<sdx1>
md: bind<sdw1>
md: bind<sdv1>
md: bind<sdu1>
md: bind<sdt1>
md: bind<sds1>
md: bind<sdr1>
md: running:<sdr1><sds1><sdt1><sdu1><sdv1><sdw1><sdx1><sdy1><sdz1><sdaa1><sdab1><sdac1><sdad1><sdae1><sdaf1>
raid5: device sdr1 operational as raid disk 0
raid5: device sds1 operational as raid disk 1
raid5: device sdt1 operational as raid disk 2
raid5: device sdu1 operational as raid disk 3
raid5: device sdv1 operational as raid disk 4
raid5: device sdw1 operational as raid disk 5
raid5: device sdx1 operational as raid disk 6
raid5: device sdy1 operational as raid disk 7
raid5: device sdz1 operational as raid disk 8
raid5: device sdaa1 operational as raid disk 9
raid5: device sdab1 operational as raid disk 10
raid5: device sdac1 operational as raid disk 11
raid5: device sdad1 operational as raid disk 12
raid5: device sdae1 operational as raid disk 13
raid5: device sdaf1 operational as raid disk 14
raid5: allocated 15812kB for md11
raid5: raid level 6 set md11 active with 15 out of 15 devices, algorithm 2
RAID5 conf printout:
  --- rd:15 wd:15 fd:0
  disk 0, o:1, dev:sdr1
  disk 1, o:1, dev:sds1
  disk 2, o:1, dev:sdt1
  disk 3, o:1, dev:sdu1
  disk 4, o:1, dev:sdv1
  disk 5, o:1, dev:sdw1
  disk 6, o:1, dev:sdx1
  disk 7, o:1, dev:sdy1
  disk 8, o:1, dev:sdz1
  disk 9, o:1, dev:sdaa1
  disk 10, o:1, dev:sdab1
  disk 11, o:1, dev:sdac1
  disk 12, o:1, dev:sdad1
  disk 13, o:1, dev:sdae1
  disk 14, o:1, dev:sdaf1
md: considering sdag1 ...
md:  adding sdag1 ...
md:  adding sdah1 ...
md:  adding sdai1 ...
md:  adding sdaj1 ...
md:  adding sdak1 ...
md:  adding sdal1 ...
md:  adding sdam1 ...
md:  adding sdan1 ...
md:  adding sdao1 ...
md:  adding sdap1 ...
md:  adding sdaq1 ...
md:  adding sdar1 ...
md:  adding sdas1 ...
md:  adding sdat1 ...
md:  adding sdau1 ...
md: created md12
md: bind<sdau1>
md: bind<sdat1>
md: bind<sdas1>
md: bind<sdar1>
md: bind<sdaq1>
md: bind<sdap1>
md: bind<sdao1>
md: bind<sdan1>
md: bind<sdam1>
md: bind<sdal1>
md: bind<sdak1>
md: bind<sdaj1>
md: bind<sdai1>
md: bind<sdah1>
md: bind<sdag1>
md: running:<sdag1><sdah1><sdai1><sdaj1><sdak1><sdal1><sdam1><sdan1><sdao1><sdap1><sdaq1><sdar1><sdas1><sdat1><sdau1>
raid5: device sdag1 operational as raid disk 0
raid5: device sdah1 operational as raid disk 1
raid5: device sdai1 operational as raid disk 2
raid5: device sdaj1 operational as raid disk 3
raid5: device sdak1 operational as raid disk 4
raid5: device sdal1 operational as raid disk 5
raid5: device sdam1 operational as raid disk 6
raid5: device sdan1 operational as raid disk 7
raid5: device sdao1 operational as raid disk 8
raid5: device sdap1 operational as raid disk 9
raid5: device sdaq1 operational as raid disk 10
raid5: device sdar1 operational as raid disk 11
raid5: device sdas1 operational as raid disk 12
raid5: device sdat1 operational as raid disk 13
raid5: device sdau1 operational as raid disk 14
raid5: allocated 15812kB for md12
raid5: raid level 6 set md12 active with 15 out of 15 devices, algorithm 2
RAID5 conf printout:
  --- rd:15 wd:15 fd:0
  disk 0, o:1, dev:sdag1
  disk 1, o:1, dev:sdah1
  disk 2, o:1, dev:sdai1
  disk 3, o:1, dev:sdaj1
  disk 4, o:1, dev:sdak1
  disk 5, o:1, dev:sdal1
  disk 6, o:1, dev:sdam1
  disk 7, o:1, dev:sdan1
  disk 8, o:1, dev:sdao1
  disk 9, o:1, dev:sdap1
  disk 10, o:1, dev:sdaq1
  disk 11, o:1, dev:sdar1
  disk 12, o:1, dev:sdas1
  disk 13, o:1, dev:sdat1
  disk 14, o:1, dev:sdau1
md: ... autorun DONE.
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
Filesystem "md10": Disabling barriers, trial barrier write failed
XFS mounting filesystem md10
Ending clean XFS mount for filesystem: md10
Filesystem "md11": Disabling barriers, trial barrier write failed
XFS mounting filesystem md11
Ending clean XFS mount for filesystem: md11
Filesystem "md12": Disabling barriers, trial barrier write failed
XFS mounting filesystem md12
Ending clean XFS mount for filesystem: md12

Sample of iostat from one of the RAID arrays.  This has been taken 
whilst the RAID is being written to.

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12            417.16         0.00         3.55         55    3736560

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12           1173.50         0.00        10.00          0         19

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12            845.50         0.00         7.19          0         14

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12           1086.50         0.00         9.25          0         18

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12           1117.00         0.00         9.50          0         19

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12            148.76         0.00         1.27          0          2

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12              8.00         0.00         0.06          0          0

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12            190.50         0.00         1.62          0          3

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
md12              0.00         0.00         0.00          0          0




lspci produces

<snip>
07:00.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller (rev 02)
07:02.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller (rev 02)
07:04.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller (rev 02)


mdadm.conf produces

cat /etc/mdadm.conf

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR root
ARRAY /dev/md0 level=raid1 num-devices=2 uuid=7d7b19e6:56cc90cc:3cb166bd:b8086f29
ARRAY /dev/md1 level=raid1 num-devices=2 uuid=3782d93d:a491ffd4:f32c1014:94a2b3f7
ARRAY /dev/md10	level=raid6 num-devices=15 uuid=5ca86e2a-3b86-4c0b-9a7a-59143bdcd0f1
ARRAY /dev/md11 level=raid6 num-devices=15 uuid=61188c90-4825-44c5-8fac-9bc82a5799fe
ARRAY /dev/md12 level=raid6 num-devices=15 uuid=fa939816-1d0f-4eaa-98dd-c131449c3921


cat /proc/mdstat reports

cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid1 sdb1[1] sda1[0]
       1044096 blocks [2/2] [UU]

md10 : active raid6 sdc1[0] sdd1[1] sde1[2] sdf1[3] sdg1[4] sdh1[5] sdi1[6] sdj1[7] sdk1[8] sdl1[9] sdm1[10] sdn1[11] sdo1[12] sdp1[13] sdq1[14]
       19046800448 blocks level 6, 64k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]

md11 : active raid6 sdr1[0] sds1[1] sdt1[2] sdu1[3] sdv1[4] sdw1[5] sdx1[6] sdy1[7] sdz1[8] sdaa1[9] sdab1[10] sdac1[11] sdad1[12] sdae1[13] sdaf1[14]
       19046766336 blocks level 6, 256k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]

md12 : active raid6 sdag1[0] sdah1[1] sdai1[2] sdaj1[3] sdak1[4] sdal1[5] sdam1[6] sdan1[7] sdao1[8] sdap1[9] sdaq1[10] sdar1[11] sdas1[12] sdat1[13] sdau1[14]
       19046766336 blocks level 6, 256k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]

md1 : active raid1 sdb2[1] sda2[0]
       77103872 blocks [2/2] [UU]


sysctl.conf reports:

# Kernel sysctl configuration file for Red Hat Linux

#
# For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
# sysctl.conf(5) for more details.

# Controls IP packet forwarding
net.ipv4.ip_forward = 0

# Controls source route verification
net.ipv4.conf.default.rp_filter = 1

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename
# Useful for debugging multi-threaded applications
kernel.core_uses_pid = 1

# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1

# Controls the maximum size of a message, in bytes
kernel.msgmnb = 65536

# Controls the default maxmimum size of a mesage queue
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296

net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
  ## increase Linux autotuning TCP buffer limits
  ## min, default, and max number of bytes to use
  ## set max to at least 4MB, or higher if you use very high BDP paths
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
  ## don't cache ssthresh from previous connection
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1
  ## recommended to increase this for 1000 BT or higher
net.core.netdev_max_backlog = 8000
  ## for 10 GigE, use this, uncomment below
#net.core.netdev_max_backlog = 30000
  ## Turn off timestamps if you're on a gigabit or very busy network
  ## Having it off is one less thing the IP stack needs to work on
net.ipv4.tcp_timestamps = 0
  ## disable tcp selective acknowledgements.
net.ipv4.tcp_sack = 0
  ##enable window scaling
net.ipv4.tcp_window_scaling = 1

vm.swappiness = 25


Finally from a boot script in /etc/rc.d/rc.local

echo -n 25000>  /proc/sys/dev/raid/speed_limit_min
echo -n 400000>  /proc/sys/dev/raid/speed_limit_max

blockdev --setra 16384 /dev/sd[a-z]
blockdev --setra 16384 /dev/sda[a-u]
blockdev --setra 16384 /dev/md1[0-2]
blockdev --setra 16384 /dev/md[0-1]

for driveletter in a b c d e f g h i j k l m n o p q r s t u v w x y z
	do
	echo -n 1024>  /sys/block/sd$driveletter/queue/nr_requests
	echo -n 1024>  /sys/block/sda$driveletter/queue/nr_requests
	done


hdparm has produced the following for me:

/dev/sda:
  Timing buffered disk reads:  218 MB in  3.00 seconds =  72.61 MB/sec

/dev/sdaa:
  Timing buffered disk reads:  218 MB in  3.01 seconds =  72.45 MB/sec

/dev/sdb:
  Timing buffered disk reads:  218 MB in  3.01 seconds =  72.48 MB/sec

/dev/sdab:
  Timing buffered disk reads:  198 MB in  3.00 seconds =  66.00 MB/sec

/dev/sdc:
  Timing buffered disk reads:  200 MB in  3.00 seconds =  66.65 MB/sec

/dev/sdac:
  Timing buffered disk reads:  212 MB in  3.01 seconds =  70.35 MB/sec

/dev/sdd:
  Timing buffered disk reads:  198 MB in  3.02 seconds =  65.66 MB/sec

/dev/sdad:
  Timing buffered disk reads:  204 MB in  3.01 seconds =  67.74 MB/sec

/dev/sde:
  Timing buffered disk reads:  216 MB in  3.00 seconds =  71.93 MB/sec

/dev/sdae:
  Timing buffered disk reads:  200 MB in  3.02 seconds =  66.31 MB/sec

/dev/sdf:
  Timing buffered disk reads:  200 MB in  3.02 seconds =  66.24 MB/sec

/dev/sdaf:
  Timing buffered disk reads:  238 MB in  3.00 seconds =  79.23 MB/sec

/dev/sdg:
  Timing buffered disk reads:  198 MB in  3.00 seconds =  66.00 MB/sec

/dev/sdag:
  Timing buffered disk reads:  150 MB in  3.01 seconds =  49.82 MB/sec

/dev/sdh:
  Timing buffered disk reads:  244 MB in  3.00 seconds =  81.27 MB/sec

/dev/sdah:
  Timing buffered disk reads:  154 MB in  3.01 seconds =  51.23 MB/sec

/dev/sdi:
  Timing buffered disk reads:  206 MB in  3.02 seconds =  68.32 MB/sec

/dev/sdai:
  Timing buffered disk reads:  156 MB in  3.01 seconds =  51.90 MB/sec

/dev/sdj:
  Timing buffered disk reads:  196 MB in  3.01 seconds =  65.09 MB/sec

/dev/sdaj:
  Timing buffered disk reads:  158 MB in  3.02 seconds =  52.26 MB/sec

/dev/sdk:
  Timing buffered disk reads:  236 MB in  3.02 seconds =  78.15 MB/sec

/dev/sdak:
  Timing buffered disk reads:  162 MB in  3.02 seconds =  53.67 MB/sec

/dev/sdl:
  Timing buffered disk reads:  216 MB in  3.01 seconds =  71.68 MB/sec

/dev/sdal:
  Timing buffered disk reads:  220 MB in  3.01 seconds =  73.14 MB/sec

/dev/sdm:
  Timing buffered disk reads:  202 MB in  3.01 seconds =  67.20 MB/sec

/dev/sdam:
  Timing buffered disk reads:  180 MB in  3.02 seconds =  59.60 MB/sec

/dev/sdn:
  Timing buffered disk reads:  230 MB in  3.00 seconds =  76.67 MB/sec

/dev/sdan:
  Timing buffered disk reads:  182 MB in  3.01 seconds =  60.44 MB/sec

/dev/sdo:
  Timing buffered disk reads:  218 MB in  3.01 seconds =  72.39 MB/sec

/dev/sdao:
  Timing buffered disk reads:  176 MB in  3.01 seconds =  58.45 MB/sec

/dev/sdp:
  Timing buffered disk reads:  202 MB in  3.00 seconds =  67.25 MB/sec

/dev/sdap:
  Timing buffered disk reads:  182 MB in  3.03 seconds =  60.13 MB/sec

/dev/sdq:
  Timing buffered disk reads:  230 MB in  3.01 seconds =  76.43 MB/sec

/dev/sdaq:
  Timing buffered disk reads:  178 MB in  3.01 seconds =  59.23 MB/sec

/dev/sdr:
  Timing buffered disk reads:  200 MB in  3.03 seconds =  65.98 MB/sec

/dev/sdar:
  Timing buffered disk reads:  182 MB in  3.01 seconds =  60.41 MB/sec

/dev/sds:
  Timing buffered disk reads:  238 MB in  3.02 seconds =  78.81 MB/sec

/dev/sdas:
  Timing buffered disk reads:  146 MB in  3.00 seconds =  48.63 MB/sec

/dev/sdt:
  Timing buffered disk reads:  198 MB in  3.03 seconds =  65.40 MB/sec

/dev/sdat:
  Timing buffered disk reads:  228 MB in  3.02 seconds =  75.44 MB/sec

/dev/sdu:
  Timing buffered disk reads:  200 MB in  3.02 seconds =  66.20 MB/sec

/dev/sdau:
  Timing buffered disk reads:  184 MB in  3.02 seconds =  60.96 MB/sec

/dev/sdv:
  Timing buffered disk reads:  210 MB in  3.02 seconds =  69.59 MB/sec


/dev/sdw:
  Timing buffered disk reads:  184 MB in  3.02 seconds =  60.90 MB/sec


/dev/sdx:
  Timing buffered disk reads:  218 MB in  3.02 seconds =  72.15 MB/sec


/dev/sdy:
  Timing buffered disk reads:  232 MB in  3.00 seconds =  77.22 MB/sec


/dev/sdz:
  Timing buffered disk reads:  200 MB in  3.02 seconds =  66.24 MB/sec


