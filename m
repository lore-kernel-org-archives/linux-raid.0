From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Incorrect in-kernel bitmap on raid10
Date: Sat, 18 Apr 2009 20:15:25 +0200
Message-ID: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I created a 4.5T RAID10 with internal bitmap out of 3 1.5T disks on a
Debian 2.6.28-1-686-bigmem kernel:
# mdadm --create -l raid10 -n 6 -c 512 -b internal -a md /dev/md7 /dev/sdc1 missing /dev/sdd1 missing /dev/sde1 missing
and I get a strange inconsistency between the on-disk and the in-kernel
bitmap representation:
[202617.869531] md: bind<sdc1>
[202617.888998] md: bind<sdd1>
[202617.908895] md: bind<sde1>
[202617.917307] md: md7: raid array is not clean -- starting background reconstruction
[202619.527127] md: raid10 personality registered for level 10
[202619.544588] raid10: raid set md7 active with 3 out of 6 devices
[202619.563536] md7: bitmap file is out of date (0 < 1) -- forcing full recovery
[202619.584919] md7: bitmap file is out of date, doing full recovery
[202619.655867] md7: bitmap initialized from disk: read 1/1 pages, set 6131 bits
[202619.677268] created bitmap (3 pages) for device md7
[202619.714033] md7: detected capacity change from 0 to 4500896612352
[202619.732554]  md7: unknown partition table
[202781.236591] md: resync of RAID array md7
[202781.248610] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[202781.266343] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[202781.294735] md: using 128k window, over a total of 4395406848 blocks.
[202781.336808] md: md7: resync done.
[202781.347708] md7: invalid bitmap page request: 3 (> 2)
[202781.363228] md7: invalid bitmap page request: 3 (> 2)
[202781.378637] md7: invalid bitmap page request: 3 (> 2)
[202781.394286] md7: invalid bitmap page request: 3 (> 2)
[202781.409704] md7: invalid bitmap page request: 3 (> 2)
...lots more of them...
[202781.832046] md7: invalid bitmap page request: 129 (> 2)
[202781.832047] md7: invalid bitmap page request: 129 (> 2)
[202781.832048] md7: invalid bitmap page request: 129 (> 2)
[202781.832049] md7: invalid bitmap page request: 129 (> 2)
[202781.832050] md7: invalid bitmap page request: 129 (> 2)
...lots more of them...
[202781.832095] md7: invalid bitmap page request: 130 (> 2)
[202781.832096] md7: invalid bitmap page request: 130 (> 2)
[202781.832097] md7: invalid bitmap page request: 130 (> 2)
[202781.832097] md7: invalid bitmap page request: 130 (> 2)
[202781.832098] md7: invalid bitmap page request: 130 (> 2)
...lots more of them...

While mdadm -X on every component shows a reasonable bitmap with a 16M
chunk size and 268275 chunks, the kernel seems to assume there are only
6131 chunks and initializes 3 instead of 130 pages.

The same happens when adding the bitmap with -G -b internal to an
existing array.

I don't know if this problem belongs to the array size (i.e. some 32bit
boundary problem) or to raid10 in general.


regards
   Mario
-- 
<snupidity> bjmg: ja, logik ist mein fachgebiet. das liegt im gen
<uepsie> in welchem?
<snupidity> im zweiten X

