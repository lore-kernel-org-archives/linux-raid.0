From: "Max Waterman" <davidmaxwaterman@fastmail.co.uk>
Subject: testing entire filesystem
Date: Mon, 28 Jul 2008 13:26:37 +0300
Message-ID: <d5fe39840807280326n78774bf4w853cb2d12df19ba3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HI,

I've made a RAID1 over two sata drives using MD and one partition on
each device. I use etx3 on the resulting md device (/dev/md0).

I used a tool to size the partitions to avoid having to guess the
maximum sizes, but I wanted to make sure I could write to the entire
filesystem and so I used dd to make a big file :

sudo dd if=/dev/zero of=bigfile bs=1024K count=500M

This resulted in a somewhat predictable :

dd: writing `bigfile': No space left on device
472433+0 records in
472432+0 records out
495381721088 bytes (495 GB) copied, 8204.09 s, 60.4 MB/s

However, it also resulted in :

Jul 25 17:37:42 jeeves mdadm: Rebuild60 event detected on md device /dev/md0

and md is dutifully rebuilding it.

Clearly, this concerns me.

Could someone enlighten me as to what went wrong (if anything)?

Is there a better way to test the file system and partition/drive are
writable in their entirety?

Thanks,

Max.

Using ubuntu 8.04, btw.
