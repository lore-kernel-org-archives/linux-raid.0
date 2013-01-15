From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 23:33:01 +1100
Message-ID: <20130115123301.GA11948@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Apologies in advance if this question has been answered before - I 
perused the archives to no avail.

I am experiencing slow linear read from a bare raid6 device, while the 
underlying drives are capable of saturating their capabilities. I can't
seem to find an explanation for this.

Regular parallel read from members:
===========
Imladris:~# echo 3 > /proc/sys/vm/drop_caches; sleep 3; for d in /dev/sd[abcd] ; do dd if=$d of=/dev/null bs=1M count=2048 & done
[1] 13953
[2] 13954
[3] 13955
[4] 13956
Imladris:~# 2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 17.331 s, 124 MB/s
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 17.5719 s, 122 MB/s
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 18.47 s, 116 MB/s
2048+0 records in
2048+0 records out
2147483648 bytes (2.1 GB) copied, 18.6834 s, 115 MB/s
===========

Same sort of read from array itself:
===========
Imladris:~# echo 3 > /proc/sys/vm/drop_caches; sleep 3; dd if=/dev/md6 of=/dev/null bs=1M count=8192
8192+0 records in
8192+0 records out
8589934592 bytes (8.6 GB) copied, 34.9699 s, 246 MB/s
===========

I was expecting to see numbers in the neighborhood of 450 MB/s

My kernel: linux-image-3.2.0-4-rt-amd64 3.2.32-1 Linux 3.2 for 64-bit PCs, PREEMPT_RT

My raid6 parameters: http://paste.debian.net/224887/

My partition alignment: http://paste.debian.net/224888/
(reationale: 4k * 255 * 63, keeps both 4k sector drives aligned and older
partition utilities happy)

My disk parameters: http://paste.debian.net/224890/

Readaheads: http://paste.debian.net/224892/

Any ideas/suggestions welcome.

Cheers
