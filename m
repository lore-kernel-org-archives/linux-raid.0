From: "Kai-Min Sung" <k@kaisung.com>
Subject: cluster RAID
Date: Sun, 25 May 2003 00:18:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000801c3228d$c6816dd0$3200a8c0@nimiak>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
	I have a shared storage environment (2 disks accessible by 2
nodes through iSCSI) and am trying to assemble the same RAID-1 array on
both nodes. Whenever I try to assemble the RAID-1 array on the second
node, it always begins reconstructing the mirror. My guess for why it's
doing this is that after the first node assembles the array, it marks a
dirty flag in the RAID metadata blocks on disk. (It only resets the
dirty flag when it deactivates the array). When the second node tries to
assemble the same array, it reads the metadata blocks and sees that it
is dirty. Then it proceeds with reconstruction. My question is does
reconstruction happen, simply because the dirty flag is set? Why doesn't
it first check if the checksums on all the mirror disks match (i.e. the
array is consistent) and bypass reconstruction? Btw, I plan for both
nodes to be accessing different partitions in the array, so there
shouldn't be any synchronization problems. Also, I'm using mdadm-1.2.0
for my testing.

Regards,
Kai-Min Sung 

