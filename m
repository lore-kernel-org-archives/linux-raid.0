From: Colonel Hell <amritanshu@gmail.com>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 01:35:17 -0700
Message-ID: <4ecc821305091001356c9ceb1c@mail.gmail.com>
References: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Reply-To: amritanshu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Dan:
>the md driver that allows it to take advantage of raid acceleration
>hardware.  I/O processors like the Intel IOP333
>(http://www.intel.com/design/iio/docs/iop333.htm) contain an xor
>engine for raid5 and raid6 calculations, but currently the md driver
>does not fully utilize these resources.
does that mean offloading RAID to the IOP board or simply using the
XOR engine in the  IOP ?
if you have some benchmarks which shows that under certain workload md
is not IOlimited(due to excessive XOR computation)  and then concluded
that offloading XOR is a gud idea , then it must be :) ...

I was going thru IOP manual myself and saw that they have a raid6
accelaretor too :)

Let me know.
-Johri.
