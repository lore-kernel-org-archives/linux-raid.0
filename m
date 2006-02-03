From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Raid 4 resize, raid0 limit question
Date: Fri, 3 Feb 2006 01:00:17 +0100
Message-ID: <04b801c62854$d2365da0$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I plan to resize (grow) one raid4 array.

1. stop the array.
2. resize the partition on all disks to fit the maximum size.

After this restart(assemble) the array is possiple?
I mean, how can the kernel find the superblock fits on the half of the new
partitions?
I need to recreate the array instead of using -G option?
Can i force raid to resync only the new area?

The raid0 in 2.6.16-rc1 supports 4x 3.6TB soure devices? :-)

Thanks,
Janos

