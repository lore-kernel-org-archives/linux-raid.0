From: Phil Turmel <philip@turmel.org>
Subject: Re: Suboptimal raid6 linear read speed
Date: Tue, 15 Jan 2013 07:49:10 -0500
Message-ID: <50F55046.7050605@turmel.org>
References: <20130115123301.GA11948@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130115123301.GA11948@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/15/2013 07:33 AM, Peter Rabbitson wrote:
> Hello,
> 
> Apologies in advance if this question has been answered before - I 
> perused the archives to no avail.
> 
> I am experiencing slow linear read from a bare raid6 device, while the 
> underlying drives are capable of saturating their capabilities. I can't
> seem to find an explanation for this.
> 
> Regular parallel read from members:
> ===========
> Imladris:~# echo 3 > /proc/sys/vm/drop_caches; sleep 3; for d in /dev/sd[abcd] ; do dd if=$d of=/dev/null bs=1M count=2048 & done
> [1] 13953
> [2] 13954
> [3] 13955
> [4] 13956
> Imladris:~# 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 17.331 s, 124 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 17.5719 s, 122 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 18.47 s, 116 MB/s
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB) copied, 18.6834 s, 115 MB/s
> ===========
> 
> Same sort of read from array itself:
> ===========
> Imladris:~# echo 3 > /proc/sys/vm/drop_caches; sleep 3; dd if=/dev/md6 of=/dev/null bs=1M count=8192
> 8192+0 records in
> 8192+0 records out
> 8589934592 bytes (8.6 GB) copied, 34.9699 s, 246 MB/s
> ===========
> 
> I was expecting to see numbers in the neighborhood of 450 MB/s

You are neglecting each drive's need to skip over parity blocks.  If the
array's chunk size is small, the drives won't have to seek, just wait
for the platter spin.  Larger chunks might need a seek.  Either way, you
won't get better than (single drive rate) * (n-2) where "n" is the
number of drives in your array. (Large sequential reads.)

Phil
