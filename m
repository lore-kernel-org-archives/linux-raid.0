From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Triple parity and beyond
Date: Mon, 18 Nov 2013 14:12:07 -0800
Message-ID: <528A90B7.5010905@zytor.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: david.brown@hesbynett.no, creamyfish@gmail.com
List-Id: linux-raid.ids

On 11/18/2013 02:08 PM, Andrea Mazzoleni wrote:
> Hi,
> 
> I want to report that I recently implemented a support for
> arbitrary number of parities that could be useful also for Linux
> RAID and Btrfs, both currently limited to double parity.
> 
> In short, to generate the parity I use a Cauchy matrix specifically
> built to be compatible with the existing Linux parity computation,
> and extensible to an arbitrary number of parities. This without
> limitations on the number of data disks.
> 
> The Cauchy matrix for six parities is:
> 
> 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01...
> 01 02 04 08 10 20 40 80 1d 3a 74 e8 cd 87 13 26 4c 98 2d 5a b4 75...
> 01 f5 d2 c4 9a 71 f1 7f fc 87 c1 c6 19 2f 40 55 3d ba 53 04 9c 61...
> 01 bb a6 d7 c7 07 ce 82 4a 2f a5 9b b6 60 f1 ad e7 f4 06 d2 df 2e...
> 01 97 7f 9c 7c 18 bd a2 58 1a da 74 70 a3 e5 47 29 07 f5 80 23 e9...
> 01 2b 3f cf 73 2c d6 ed cb 74 15 78 8a c1 17 c9 89 68 21 ab 76 3b...
> 
> You can easily recognize the first row as RAID5 based on a simple
> XOR, and the second row as RAID6 based on multiplications by powers
> of 2. The other rows are for additional parity levels and they
> require multiplications by arbitrary values that can be implemented
> using the PSHUFB instruction.
> 

Hello,

This looks very interesting indeed.  Could you perhaps describe how the
Cauchy matrix is derived, and under what conditions it would become
singular?

	-hpa


