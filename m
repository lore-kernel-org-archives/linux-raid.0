From: Song Pan <pansong@ookyy.com>
Subject: Howto recover 2 SoftRaid 5 device fail
Date: Fri, 28 Nov 2003 20:22:19 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FC7AE7B.7000001@ookyy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Help:

I got power fail on my server(I was stupid enough to unplug the wrong
cable). After reboot, my SoftRAID 5, /dev/md4 device is no longer
working. It got 6 device in total and two of them /dev/sda2 and
/dev/sdb2 is out of sync.

The kernel message shows following:

kernel: md: superblock update time inconsistency -- using the most
recent one
Nov 28 18:33:59 kernel: md: freshest: hda7

The raidtab configure is following:

riaddev /dev/md4
raid-level 5
nr-raid-disks 6
chunk-size 64k
persistent-superblock 1
nr-spare-disks 0
/dev/hda7
/dev/hdc7
/dev/hde2
/dev/hdg2
/dev/sda2
/dev/sdb2

I read the Softraid howto, and it seems I can use "mkraid --force" to
get my data back. Is this ok with my situation?

thanks



