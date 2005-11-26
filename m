From: "JaniD++" <djani22@dynamicweb.hu>
Subject: RAID0 performance question
Date: Sat, 26 Nov 2005 15:04:37 +0100
Message-ID: <015c01c5f292$57e0e270$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au> <20051122220531.GU26862@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I have searching the bottleneck of my system, and found something what i
cant cleanly understand.

I have use NBD with 4 disk nodes. (raidtab is the bottom of mail)

The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
Mbit/s. - i think this is my network bottleneck.

But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
~450-490 Mbit/s, and i dont know why....

Somebody have an idea? :-)

(the nb31,30,29,28 only possible mirrors)

Thanks
Janos

raiddev         /dev/md1
raid-level      1
nr-raid-disks   2
chunk-size      32
persistent-superblock 1
device          /dev/nb0
raid-disk       0
device          /dev/nb31
raid-disk       1
failed-disk     /dev/nb31

raiddev         /dev/md2
raid-level      1
nr-raid-disks   2
chunk-size      32
persistent-superblock 1
device          /dev/nb1
raid-disk       0
device          /dev/hb30
raid-disk       1
failed-disk     /dev/nb30

raiddev         /dev/md3
raid-level      1
nr-raid-disks   2
chunk-size      32
persistent-superblock 1
device          /dev/nb2
raid-disk       0
device          /dev/nb29
raid-disk       1
failed-disk     /dev/nb29

raiddev         /dev/md4
raid-level      1
nr-raid-disks   2
chunk-size      32
persistent-superblock 1
device          /dev/nb3
raid-disk       0
device          /dev/nb28
raid-disk       1
failed-disk     /dev/nb28

raiddev         /dev/md31
raid-level      0
nr-raid-disks   4
chunk-size      32
persistent-superblock 1
device          /dev/md1
raid-disk       0
device          /dev/md2
raid-disk       1
device          /dev/md3
raid-disk       2
device          /dev/md4
raid-disk       3


