From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Sun, 21 Apr 2013 18:48:52 +0200
Message-ID: <CAGA4a+F83BBevCwtKDZ5APz6Npa27rZfvGxyFoQktT_EPu1iTg@mail.gmail.com>
References: <5171CBF9.9020701@redhost.ro>
	<CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com>
	<51725458.7020109@redhost.ro>
	<CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com>
	<51732422.1050109@redhost.ro>
	<5173536C.2040108@hardwarefreak.com>
	<CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just did a blockwise test aswell with fio >

Single SSD :
# ./scst-trunk/scripts/blockdev-perftest -d -f -i 1 -j -m 10 -M 20 -s
30 -f /dev/sdb
blocksize        W   W(avg,   W(std,        W        R   R(avg,
R(std,        R
  (bytes)      (s)    MB/s)    MB/s)   (IOPS)      (s)    MB/s)
MB/s)   (IOPS)
  1048576    6.548  156.384    0.000  156.384    2.383  429.710
0.000  429.710
   524288    6.311  162.256    0.000  324.513    2.521  406.188
0.000  812.376
   262144    6.183  165.615    0.000  662.462    3.003  340.992
0.000 1363.969
   131072    6.096  167.979    0.000 1343.832    3.140  326.115
0.000 2608.917
    65536    5.973  171.438    0.000 2743.010    3.807  268.978
0.000 4303.651
    32768    5.748  178.149    0.000 5700.765    4.609  222.174
0.000 7109.568
    16384    5.693  179.870    0.000 11511.681    5.203  196.810
0.000 12595.810
     8192    6.188  165.482    0.000 21181.642    7.339  139.529
0.000 17859.654
     4096   10.190  100.491    0.000 25725.613   13.816   74.117
0.000 18973.943
     2048   25.018   40.931    0.000 20956.431   26.136   39.180
0.000 20059.994
     1024   39.693   25.798    0.000 26417.152   50.580   20.245
0.000 20731.040

RAID1 with two Intel330 SSDs:
# ./scst-trunk/scripts/blockdev-perftest -d -f -i 1 -j -m 10 -M 20 -s
30 -f /dev/md0
blocksize        W   W(avg,   W(std,        W        R   R(avg,
R(std,        R
  (bytes)      (s)    MB/s)    MB/s)   (IOPS)      (s)    MB/s)
MB/s)   (IOPS)
  1048576    7.053  145.186    0.000  145.186    2.384  429.530
0.000  429.530
   524288    6.906  148.277    0.000  296.554    2.518  406.672
0.000  813.344
   262144    6.763  151.412    0.000  605.648    2.871  356.670
0.000 1426.681
   131072    6.558  156.145    0.000 1249.161    3.166  323.437
0.000 2587.492
    65536    6.578  155.670    0.000 2490.727    3.835  267.014
0.000 4272.229
    32768    6.311  162.256    0.000 5192.204    4.379  233.843
0.000 7482.987
    16384    6.406  159.850    0.000 10230.409    5.953  172.014
0.000 11008.903
     8192    7.776  131.687    0.000 16855.967    8.621  118.780
0.000 15203.805
     4096   11.137   91.946    0.000 23538.116   14.138   72.429
0.000 18541.802
     2048   38.440   26.639    0.000 13639.126   22.512   45.487
0.000 23289.268
     1024   60.933   16.805    0.000 17208.672   43.247   23.678
0.000 24246.214

it sorta confirms that the performance goes down but I would kinda
expect that in a way aswell as the write confirm has to come from both
disks.

/Tommy

2013/4/21 Tommy Apel <tommyapeldk@gmail.com>:
> Hello, FYI I'm getting ~68MB/s on two intel330 in RAID1 aswell on
> vanilla 3.8.8 and 3.9.0-rc3 when writing random data and ~236MB/s
> writing from /dev/zero
>
> mdadm -C /dev/md0 -l 1 -n 2 --assume-clean --force --run /dev/sdb /dev/sdc
> openssl enc -aes-128-ctr -pass pass:"$(dd if=/dev/urandom bs=128
> count=1 2>/dev/null | base64)" -nosalt < /dev/zero | pv -pterb >
> /run/fill ~1.06GB/s
> dd if=/run/fill of=/dev/null bs=1M count=1024 iflag=fullblock ~5.7GB/s
> dd if=/run/fill of=/dev/md0 bs=1M count=1024 oflag=direct ~68MB/s
> dd if=/dev/zero of=/dev/md0 bs=1M count=1024 oflag=direct ~236MB/s
>
> iostat claiming 100% util on both drives when doing so, running both
> deadline and noop scheduler,
> doing the same with 4 threads and offset by 1.1GB on the disk and
> taske set to 4 cores makes no difference, still ~68MB/s with random
> data
> # for x in `seq 0 4`; do taskset -c $x dd if=/run/fill of=/dev/md0
> bs=1M count=1024 seek=$(($x * 1024)) oflag=direct & done
>
> /Tommy
>
> 2013/4/21 Stan Hoeppner <stan@hardwarefreak.com>:
>> On 4/20/2013 6:26 PM, Andrei Banu wrote:
>>
>>> They are connected through SATA2 ports (this does explain the read speed
>>> but not the pitiful write one) in AHCI.
>>
>> These SSDs are capable of 500MB/s, and cost ~$1000 USD.  Spend ~$200 USD
>> on a decent HBA.  The 6G SAS/SATA LSI 9211-4i seems perfectly suited to
>> your RAID1 SSD application.  It is a 4 port enterprise JBOD HBA that
>> also supports ASIC level RAID 1, 1E, 10.
>>
>> Also, the difference in throughput your show between RAID maintenance,
>> direct device access, and filesystem access suggests you have something
>> running between the block and filesystem layers, for instance LUKS.
>> Though LUKS alone shouldn't hammer your CPU and IO throughput so
>> dramatically.  However, if the SSDs do compression or encryption
>> automatically, and I believe the 840s do, the LUKS encrypted blocks may
>> cause the SSD firmware to take considerably more time to process the blocks.
>>
>> --
>> Stan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
