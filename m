From: Alexander Dorokhine <adorokhine@datagardens.com>
Subject: md not flushing some pages
Date: Tue, 15 Mar 2011 10:25:13 -0600
Message-ID: <4D7F92E9.3060405@datagardens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

We are experiencing a strange issue related to md failing to completely 
flush its array:

md13 : active raid1 sdd[1](W) dm-0[0]
       3145600 blocks [2/2] [UU]
       bitmap: 1/384 pages [4KB], 4KB chunk, file: 
/var/syntropy/bitmaps/md13bm

As you can see, md13 has both endpoints connected. However, one page 
(4KB) refuses to flush (not even overnight).
This is md 2.6.3 on kernel 2.6.32.31. We have never seen this problem on 
kernel 2.6.24, which is what we were using before.

md seems to think it's done:
[  985.010761] md: bind<sdd>
[  985.021776] RAID1 conf printout:
[  985.021782]  --- wd:1 rd:2
[  985.021833]  disk 0, wo:0, o:1, dev:dm-0
[  985.021837]  disk 1, wo:1, o:1, dev:sdd
[  985.023589] md: recovery of RAID array md13
[  985.023609] md: minimum _guaranteed_  speed: 100000 KB/sec/disk.
[  985.023629] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[  985.023759] md: using 128k window, over a total of 3145600 blocks.
[ 1039.515574] md: md13: recovery done.
[ 1039.598256] RAID1 conf printout:
[ 1039.598263]  --- wd:2 rd:2
[ 1039.598270]  disk 0, wo:0, o:1, dev:dm-0
[ 1039.598273]  disk 1, wo:0, o:1, dev:sdd

We did find this bugreport with a similar issue: 
https://bugzilla.redhat.com/show_bug.cgi?id=680791
However, it mentions that the first broken kernel is 2.6.35.11, but we 
are using the much-older 2.6.32.31.

We have been able to reproduce this issue twice in a row now. Does 
anyone know why this page is sticking around?

Thanks for the advice.

Alexander Dorokhine.
