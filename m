From: "Matthew Simpson" <matthew@symatec-computer.com>
Subject: how to turn down cpu usage of raid ?
Date: Mon, 2 Feb 2004 17:18:19 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <021c01c3e9e2$d80b3640$0100a8c0@KARI>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Help!  I am having complaints from users about CPU spikes when writing to my
RAID 1 array.  Is there a way I can tune software RAID so that writing
updates doesn't interfere with other applications?  [can I nice the raid1d
process?]

Specifically I experience giant slowdowns in a hosted application whenever
someone unpacks a tar file or the like.  Load averages are 1.10 - 2.00
during writes, but 0.00 to 0.05 otherwise.

root@ns2:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 hdc1[1] hda1[0]
      78979200 blocks [2/2] [UU]

unused devices: <none>

root@ns2:~# cat /etc/raidtab
raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      4
        persistent-superblock   1
        device  /dev/hda1
        raid-disk       0
        device  /dev/hdc1
        raid-disk       1

This is a pentium IV 2.5GHz system with 1GB of RAM.
    IDE interface: PCI device 8086:24cb (Intel Corp.) (rev 1). -- 82820
Camino 2 chipset


