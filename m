From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Raid5 Read Perf drop in 2.6.27
Date: Wed, 9 Sep 2009 15:54:48 -0700
Message-ID: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linuxraid.study@gmail.com
List-Id: linux-raid.ids

Hello:

I'm benchmarking RAID5 Read performance with 4 disks and notice perf
drop when using kernel 2.6.27.
The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.21 (and same
setup), the perf is 180MB/s/



Some of the tests I have done:
1. I ran  experiments using iozone also but notice that READ perf with
RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
Write perf is similar but Read is an issue.

2. On 2.6.27, I played around with chunk size and blocksize parameters
and got ~5% improvement but not much. I used following cmds:

#mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=4
/dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=32
#mke2fs -b 4096 -E stride=8 /dev/md0

#time dd if=/dev/md0 of=/dev/null bs=94208 count=1024


Is this perf drop a known issue? Can someone please recommend some
performance tuning tips?

Thanks a lot for your time and help!
