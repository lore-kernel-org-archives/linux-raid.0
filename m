From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mismatch_cnt != 0
Date: Sat, 23 Feb 2008 16:19:53 +0300
Message-ID: <47C01D79.4010708@msgid.tls.msk.ru>
References: <alpine.DEB.1.00.0802230434100.3809@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0802230434100.3809@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Should I be worried?
> 
> Fri Feb 22 20:00:05 EST 2008: Executing RAID health check for /dev/md3...
> Fri Feb 22 21:00:06 EST 2008: cat /sys/block/md3/md/mismatch_cnt
> Fri Feb 22 21:00:06 EST 2008: 936
> Fri Feb 22 21:00:09 EST 2008: Executing repair on /dev/md3
> Fri Feb 22 22:00:10 EST 2008: cat /sys/block/md3/md/mismatch_cnt
> Fri Feb 22 22:00:10 EST 2008: 936

Your /dev/md3 is a swap, right?
If it's swap, it's quite common to see mismatches here.  I don't know
why, and I don't think it's correct (there should be a bug somewhere).
If it's not swap, there should be no mismatches, UNLESS you initially
built your array with --assume-clean.
In any case it's good to understand where those mismatches comes from
in the first place.

As of the difference (or, rather, lack thereof) of the mismatched
blocks after check and repair - that's exactly what expected.  Check
found 936 mismatches, and repair corrected exactly the same amount
of them.  I.e., if you run check again after repair, you should see
0 mismatches.

/mjt
