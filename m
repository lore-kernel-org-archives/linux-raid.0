From: Matthias Urlichs <matthias@urlichs.de>
Subject: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 19:22:21 +0000 (UTC)
Message-ID: <h8ophd$n8p$6@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a somewhat strange error today.

One of my servers has a RAID1 array. Two partitions at the end of the 
disk; the RAID superblocks are at the end of the partition.

After a hard reboot today, one of the disks managed to not have its 
partition table scanned correctly, most probably because the disk was 
hung and the ("intelligent") controller got confused about it. After the 
initial scan, however, it came up correctly.

This error caused mdadm to "successfully" build a RAID1 from /dev/sda3
and /dev/sdb (instead of /dev/sdb3). Needless to say, the resulting 
volume was somewhat unuseable. To say the least.

My server's mdadm.conf has a 'DEVICE=partitions' line. I suppose that 
replacing these with a pattern that explicitly only matches partitions, 
not disks, would make the problem go away, and that the lesson from 
today's disaster recovery effort is to always explicitly list the allowed 
partition names, instead of being lazy and using 'DEVICE=partitions'.

-- 

