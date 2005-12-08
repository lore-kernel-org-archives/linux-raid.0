From: "JaniD++" <djani22@dynamicweb.hu>
Subject: performance question about cache/buffers  (not exactly raid)
Date: Thu, 8 Dec 2005 01:09:46 +0100
Message-ID: <047101c5fb8b$b4dc2780$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I use 4 disk nodes (2TB RAID5 in each) with nbd.

The question is how can i configure the system, to use more cache (or
buffers) ?
All the nodes have 2GB ram, but never use more than 1.1GB.

[root@st-0001 root]# free
             total       used       free     shared    buffers     cached
Mem:       2072972     913048    1159924          0     838964      24568
-/+ buffers/cache:      49516    2023456
Swap:            0          0          0
[root@st-0001 root]# cat /proc/meminfo
MemTotal:      2072972 kB
MemFree:       1159052 kB
Buffers:        839772 kB
Cached:          25052 kB
SwapCached:          0 kB
Active:          10000 kB
Inactive:       857180 kB
HighTotal:     1179584 kB
HighFree:      1150596 kB
LowTotal:       893388 kB
LowFree:          8456 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:             848 kB
Writeback:           0 kB
Mapped:           4884 kB
Slab:            27320 kB
CommitLimit:   1036484 kB
Committed_AS:     9460 kB
PageTables:        248 kB
VmallocTotal:   114680 kB
VmallocUsed:       452 kB
VmallocChunk:   113484 kB
[root@st-0001 root]#

The readahead and the performance is very important for me.
I have allready try to tune the vm, but the used cache/buffer is still
unchanged.

If somebody have an idea, please let me know! :-)

Thanks,
Janos

