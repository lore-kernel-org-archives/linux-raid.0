From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Resync Every Sunday
Date: Sun, 01 Jul 2012 12:20:43 +0100
Message-ID: <4FF0328B.5080103@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Everyone,

We have a few servers that use md raid with mdadm. Each server has 4 
arrays (md0,md1,md2,md3). md0,1,2 are small and md3 is very large. Every 
Sunday at 4:22am, the servers will start to resync. Here is some text 
from /var/log/messages for one of the servers:

Jul  1 04:22:01 server1 kernel: md: syncing RAID array md0
Jul  1 04:22:01 server1 kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jul  1 04:22:01 server1 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jul  1 04:22:01 server1 kernel: md: using 128k window, over a total of 
104320 blocks.
Jul  1 04:22:01 server1 kernel: md: delaying resync of md2 until md0 has 
finished resync (they share one or more physical units)
Jul  1 04:22:01 server1 kernel: md: delaying resync of md3 until md0 has 
finished resync (they share one or more physical units)
Jul  1 04:22:05 server1 kernel: md: md0: sync done.
Jul  1 04:22:05 server1 kernel: md: delaying resync of md3 until md2 has 
finished resync (they share one or more physical units)
Jul  1 04:22:05 server1 kernel: md: delaying resync of md2 until md3 has 
finished resync (they share one or more physical units)
Jul  1 04:22:05 server1 kernel: md: syncing RAID array md3
Jul  1 04:22:05 server1 kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jul  1 04:22:05 server1 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jul  1 04:22:05 server1 kernel: md: using 128k window, over a total of 
1888295936 blocks.

/proc/mdstat shows a progress bar for the array that is currently 
"re-syncing" (in the above case, md3). However, the disks in the servers 
seem fine, and it always seems to happen in the early hours of Sunday 
morning at 4:22am.

The issue gets further complicated as not all arrays are re-synced and I 
can seem to find a pattern as to what's selected. All I know is that at 
4:22, mdadm will "come alive" and attempt to do re-syncing of some (or 
all) of the arrays. On each of the servers, 3 of the arrays are small 
and one is large; this leads to the phenomenon that when we wake up on 
Sunday morning, a "random" selection of the servers will still be 
syncing (as mdadm has decided to "pick" the large md3 array to resync).

Here is output from /var/log/messages on a server that has only decided 
to re-sync 2 small arrays (md0 and md2):

Jul  1 04:22:01 server3 kernel: md: syncing RAID array md0
Jul  1 04:22:01 server3 kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jul  1 04:22:01 server3 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jul  1 04:22:01 server3 kernel: md: using 128k window, over a total of 
104320 blocks.
Jul  1 04:22:01 server3 kernel: md: delaying resync of md2 until md0 has 
finished resync (they share one or more physical units)
Jul  1 04:22:02 server3 kernel: md: md0: sync done.
Jul  1 04:22:02 server3 kernel: md: syncing RAID array md2
Jul  1 04:22:02 server3 kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jul  1 04:22:02 server3 kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jul  1 04:22:02 server3 kernel: md: using 128k window, over a total of 
1052160 blocks.
Jul  1 04:22:15 server3 kernel: md: md2: sync done

What's going on? Am I missing something here? Is data on the arrays at 
risk? We're using CentOS 5 with mdadm v2.6.9. Kernel version is 
2.6.18-274.18.1.el5

Any help is appreciated.

Thanks
