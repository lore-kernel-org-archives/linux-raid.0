From: Brad Campbell <brad@wasp.net.au>
Subject: Raid-6 Rebuild question
Date: Sun, 13 Nov 2005 13:05:34 +0400
Message-ID: <437701DE.7060400@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

Here is an interesting question( well I think so in any case ). I just replaced a failed disk in my 
15 drive Raid-6.

Simply mdadm --add /dev/md0 /dev/sdl

Why, when there is no other activity on the array at all, is it writing to every disk during the 
recovery? I would have assumed it just read from the others and write to sdl.

This is an iostat -k 5 on that machine while rebuilding

avg-cpu:  %user   %nice    %sys %iowait   %idle
            0.00    0.00  100.00    0.00    0.00

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             121.08     14187.95       925.30      23552       1536
sdb             127.71     14187.95      1002.41      23552       1664
sdc             125.30     14187.95      1002.41      23552       1664
sdd             122.29     14187.95      1002.41      23552       1664
sde             125.30     14187.95      1002.41      23552       1664
sdf             127.71     14187.95      1002.41      23552       1664
sdg             125.90     14187.95       925.30      23552       1536
sdh             125.30     14187.95       925.30      23552       1536
sdi             134.34     14187.95       925.30      23552       1536
sdj             137.95     14187.95       925.30      23552       1536
sdk             140.36     14187.95      1850.60      23552       3072
sdl              79.52         0.00     14265.06          0      23680
sdm             133.13     14187.95       925.30      23552       1536
sdn             134.34     14187.95       925.30      23552       1536
sdo             133.73     14187.95       925.30      23552       1536
md0               0.00         0.00         0.00          0          0

storage1:/home/brad# cat /proc/mdstat
Personalities : [raid6]
md0 : active raid6 sdl[15] sdg[6] sda[0] sdo[14] sdn[13] sdm[12] sdk[10] sdj[9] sdi[8] sdh[7] sdf[5] 
sde[4] sdd[3] sdc[2] sdb[1]
       3186525056 blocks level 6, 128k chunk, algorithm 2 [15/14] [UUUUUUUUUUU_UUU]
       [>....................]  recovery =  1.8% (4518144/245117312) finish=838.3min speed=4782K/sec
unused devices: <none>

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
