From: Kasper Sandberg <kontakt@sandberg-consult.dk>
Subject: raid6 low performance 8x3tb drives in singledegraded mode(=7x3tb)
Date: Wed, 12 Sep 2012 02:03:31 +0200
Message-ID: <504FD153.9090602@sandberg-consult.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have setup an array of 7x3tb WD30EZRX drives, though its meant for 8x,
so it runs in singledegraded mode.

the issue is that i get very poor performance, generally roughly 25MB/s
writes only. individually the disks are fine.

iowait and idle is high:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.29    0.00    5.85   22.14    0.00   69.72
 
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
avgrq-sz avgqu-sz   await  svctm  %util
sdb            1370.00   732.00  109.00   30.00 11824.00  5864.00  
127.25     1.50   10.71   2.45  34.00
sdf            1392.00   839.00   88.00   33.00 11840.00  6976.00  
155.50     3.42   28.26   4.43  53.60
sdd            1422.00   863.00   64.00   29.00 13448.00  6384.00  
213.25     2.28   34.54   4.56  42.40
sdg            1388.00   446.00   92.00   18.00 11840.00  3248.00  
137.16     0.63    5.71   1.60  17.60
sdc            1395.00   857.00   85.00   40.00 11840.00  6944.00  
150.27     1.07    8.58   1.86  23.20
sda            1370.00   985.00  111.00   41.00 11888.00  7744.00  
129.16     5.30   35.79   5.21  79.20
sde            1417.00   669.00   70.00   21.00 13528.00  5040.00  
204.04     1.94   32.79   4.53  41.20
sdh               0.00     0.00    0.00    0.00     0.00     0.00    
0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00   86.00     0.00 17656.00  
205.30     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00    
0.00  4174.84    0.00   0.00 100.00

http://paste.kde.org/547370/ - the same as above, but on pastebin since
might be annoying to read in mail client depending on font used.

(sdh is not part of array)

mdadm detail:
/dev/md0:
        Version : 1.2
  Creation Time : Sat Sep  8 23:01:11 2012
     Raid Level : raid6
     Array Size : 17581590528 (16767.11 GiB 18003.55 GB)
  Used Dev Size : 2930265088 (2794.52 GiB 3000.59 GB)
   Raid Devices : 8
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Wed Sep 12 01:55:49 2012
          State : active, degraded
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : mainserver:0  (local to host mainserver)
           UUID : d48566eb:ca2fce69:907602f4:84120ee4
         Events : 26413

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       8       8       96        6      active sync   /dev/sdg
       7       0        0        7      removed


It should be noted that I tested the chunksizes extensively, from 4k to
2048k, and the default seemed to offer best performance allround, very
close to the best performers for all workloads, and much much better
than the worst.

I conducted tests with dd directly on md0, and xfs on md0, and with
dm-crypt on top md md0, both dd and xfs on the dm-0 device. resulting in
marginal performance difference, so i must assume the issue is in the
raid layer.

kernel is:
Linux mainserver 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
x86_64 GNU/Linux

could this be due to being in singledegraded mode? after im done copying
files to this array i will be adding the last disk.

Any input is welcomed.

Oh, and im not subscribed to the list, so please CC me.

-- 
Kasper Sandberg
Sandberg Enterprises
+45 51944242
http://www.sandbergenterprises.dk

