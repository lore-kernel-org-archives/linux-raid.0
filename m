From: Tim Small <tim@buttersideup.com>
Subject: read errors with md RAID5 array
Date: Mon, 15 Aug 2016 14:12:23 +0100
Message-ID: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm seeing some strange read errors whilst reading from an md RAID5
array (3x 2TB SATA Drives, Intel AHCI controller).

One of the underlying devices is reporting some "pending sectors" via
SMART, so I triggered a check (via sync_action the pseudo file), but
when this didn't decrease the unreadable sector count, I just did:

dd if=/dev/md2 of=/dev/null conv=noerror

This results in:

[ 1466.586612] buffer_io_error: 85 callbacks suppressed
[ 1466.586617] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1466.824085] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1466.986397] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.143073] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.305265] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.465493] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.623860] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.774287] Buffer I/O error on dev md2, logical block 7057384, async
page read
[ 1467.934768] Buffer I/O error on dev md2, logical block 7057385, async
page read
[ 1468.097099] Buffer I/O error on dev md2, logical block 7057385, async
page read
[ 1569.197498] buffer_io_error: 198 callbacks suppressed
[ 1569.197503] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1569.443257] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1569.597697] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1569.760507] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1569.924565] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1570.087074] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1570.241459] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1570.407910] Buffer I/O error on dev md2, logical block 8124804, async
page read
[ 1570.570488] Buffer I/O error on dev md2, logical block 8124805, async
page read
[ 1570.732574] Buffer I/O error on dev md2, logical block 8124805, async
page read


I'm not getting any accompanying reports of underlying SATA read errors,
nor apparently any attempt to correct unreadable sectors.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md2 : active raid5 sda2[0] sdd2[3] sdc2[1]
      3885793280 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
[UUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>

I thought perhaps that the array was aware of a RAID5 hole, and failing
reads, but this would seem to disagree on that?

# cat /sys/block/md2/md/mismatch_cnt
0

... unless that's not the way to detect such errors?


# uname -a
Linux magic 4.4.0-34-generic #53-Ubuntu SMP Wed Jul 27 16:06:39 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

This is the current Ubuntu LTS kernel.  Were there any known md, or
block layer problems with the 4.4 kernel?  Should I try with the latest
mainline kernel, or am I missing something else entirely?

Tim.
