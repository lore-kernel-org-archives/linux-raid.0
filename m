From: Brad Campbell <brad@wasp.net.au>
Subject: RAID-6 check slow..
Date: Tue, 22 Aug 2006 11:26:47 +0400
Message-ID: <44EAB1B7.7010208@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I have a box with 15 SATA drives in it, they are all on the PCI bus and it's a relatively slow machine.

I can extract about 100MB/s combined read speed from these drives with dd.

When reading /dev/md0 with dd I get about 80MB/s, but when I ask it to check the array on a 
completely idle system with echo check > /sys/block/md/md0/sync_action I get a combined read speed 
across all drives of 31.9MB/s

I'm not that fussed I guess, given the system does have extended idle periods, it would be nice to 
have a sync or check complete as quickly as the hardware allows. Experience has shown that a rebuild 
of a single disk failure takes 10-12 hours but the check seems to take forever

brad@storage1:~$ cat /proc/mdstat
Personalities : [raid6]
md0 : active raid6 sda[0] sdo[14] sdn[13] sdm[12] sdl[11] sdk[10] sdj[9] sdi[8] sdh[7] sdg[6] sdf[5] 
sde[4] sdd[3] sdc[2] sdb[1]
       3186525056 blocks level 6, 128k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]
       [>....................]  resync =  0.1% (458496/245117312) finish=1881.9min speed=2164K/sec

unused devices: <none>

I have included some iostat output running on a 5 second interval and allowed 30 seconds to stabilise.

Linux storage1 2.6.17.9 #2 Sun Aug 20 17:16:24 GST 2006 i686 GNU/Linux

<----- snip ----->

1st a dd from all drives.

storage1:/home/brad# cat t
#!/bin/sh
for i in /dev/sd[abcdefghijklmno] ; do
echo $i
dd if=$i of=/dev/null &
done;


avg-cpu:  %user   %nice    %sys %iowait   %idle
            8.80    0.00   58.40   32.80    0.00

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda              13.00     13312.00         0.00      66560          0
sdb              12.80     13107.20         0.00      65536          0
sdc              12.80     13107.20         0.00      65536          0
sdd              12.80     13107.20         0.00      65536          0
sde              12.80     13107.20         0.00      65536          0
sdf              12.80     13107.20         0.00      65536          0
sdg              12.80     13107.20         0.00      65536          0
sdh              13.00     13312.00         0.00      66560          0
sdi              12.80     13107.20         0.00      65536          0
sdj              13.00     13312.00         0.00      66560          0
sdk              13.00     13312.00         0.00      66560          0
sdl              12.80     13107.20         0.00      65536          0
sdm              17.20     17612.80         0.00      88064          0
sdn              17.20     17612.80         0.00      88064          0
sdo              17.20     17612.80         0.00      88064          0
md0               0.00         0.00         0.00          0          0


<---- snip ----->

echo check > /sys/block/md/md0/sync_action

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.80    0.00    6.59    0.00   92.61

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda               5.99      4343.31         0.00      21760          0
sdb               5.99      4343.31         0.00      21760          0
sdc               5.99      4343.31         0.00      21760          0
sdd               5.99      4343.31         0.00      21760          0
sde               5.99      4343.31         0.00      21760          0
sdf               5.99      4343.31         0.00      21760          0
sdg               5.99      4343.31         0.00      21760          0
sdh               5.99      4343.31         0.00      21760          0
sdi               5.99      4343.31         0.00      21760          0
sdj               5.99      4343.31         0.00      21760          0
sdk               5.99      4343.31         0.00      21760          0
sdl               5.99      4343.31         0.00      21760          0
sdm               5.99      4343.31         0.00      21760          0
sdn               5.99      4343.31         0.00      21760          0
sdo               5.99      4343.31         0.00      21760          0
md0               0.00         0.00         0.00          0          0

storage1:/home/brad# grep 0 /proc/sys/dev/raid/*
/proc/sys/dev/raid/speed_limit_max:400000
/proc/sys/dev/raid/speed_limit_min:1000

<----- snip ----->

dd if=/dev/md0 of=/dev/null

avg-cpu:  %user   %nice    %sys %iowait   %idle
            9.00    0.00   72.60   18.40    0.00

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sda              25.80     11008.00         0.00      55040          0
sdb              25.60     10924.80         0.00      54624          0
sdc              26.00     10956.80         0.00      54784          0
sdd              25.80     10956.80         0.00      54784          0
sde              25.20     11059.20         0.00      55296          0
sdf              26.00     11008.00         0.00      55040          0
sdg              26.20     11008.00         0.00      55040          0
sdh              26.40     11008.00         0.00      55040          0
sdi              26.00     11008.00         0.00      55040          0
sdj              26.40     11008.00         0.00      55040          0
sdk              26.80     10988.80         0.00      54944          0
sdl              25.80     10945.60         0.00      54728          0
sdm              26.20     10956.80         0.00      54784          0
sdn              25.40     10905.60         0.00      54528          0
sdo              24.80     10905.60         0.00      54528          0
md0           20467.20    163737.60         0.00     818688          0

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
