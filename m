From: "E. Gryaznova" <grev@namesys.com>
Subject: linear raid device problem: I/O error on reading block
Date: Fri, 16 Jan 2004 23:07:24 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4008447C.35574AA3@namesys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I have the following problem with raid device (linear).

I can successfully create the linear device /dev/md0 this way

# mkraid  --configfile ./rd.conf --really-force /dev/md0
disk 0: /dev/hda11, 4972086kB, raid superblock at 4971968kB
disk 1: /dev/hdc11, 3020188kB, raid superblock at 3020096kB

when the configfile is:
raiddev /dev/md0
        raid-level      linear
        nr-raid-disks   2
        persistent-superblock 1
        chunk-size              8
        device          /dev/hda11
        raid-disk       0
        device          /dev/hdc11
        raid-disk       1

Then I try to do the two dd commands:

# dd if=/dev/md0 of=/dev/null bs=512 count=1 skip=9944158
1+0 records in
1+0 records out

# dd if=/dev/md0 of=/dev/null bs=512 count=1 skip=9944159
dd: reading `/dev/md0': Input/output error
0+0 records in
0+0 records out

Why does the second dd command fail? The size of /dev/md0 is about
7.9Gb, so why does dd fail on reading block with offset about ~5Gb?
In kernel logs I see the following:

Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944152, count=24
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944152
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944154, count=22
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944154
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944156, count=20
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944156
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944158, count=18
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944158
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944160, count=16
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944160
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944162, count=14
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944162
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944164, count=12
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944164
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944166, count=10
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944166
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944168, count=8
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944168
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944170, count=6
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944170
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944172, count=4
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944172
Jan 16 21:59:39 flint kernel: hda;: bad access: block=9944174, count=2
Jan 16 21:59:39 flint kernel: end_request: I/O error, dev 03:0b (hda),
sector 9944174

I use kernel 2.4.24 and raidtools-1.00.3.
I checked /dev/hda11 and /dev/hdc11 by badblocks, and no bad blocks were
found on these devices.

Thank you very much for helping me.
Lena

