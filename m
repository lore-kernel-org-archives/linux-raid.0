From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is
 significantly slower in x86_64.
Date: Sun, 16 Nov 2008 16:36:07 -0800
Message-ID: <4920BC77.9010709@zytor.com>
References: <43d009740811160818v49c530b1r9e01b79c1d9dcfdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740811160818v49c530b1r9e01b79c1d9dcfdd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Igor Podlesny wrote:
> 
> So, there're 2 strange things in those dmesgs. The first one might be
> unrelated to Linux RAID but affects it -- have you noticed that in
> x86_64, raid6 algorithm is ~ 50 % slower, than in x86_32? Is that due
> to not too optimized code for x86_64 mode? And the second -- why is
> raid6 using algorithm sse2x4 (3175 MB/s), whereas int64x2 gives
> slightly better (~ 15 %) throughput -- 3660 MB/s?
> 
> Has anyone on the list similar observations? Can gcc's version
> difference affect so much? I doubt that, but I can try build x86_32
> with gcc 4.3.1 (as x86_64 was).
> 

The SSE modes have nicer cache behaviours and are therefore preferred
even if they are slower.

It is very odd that your SSE2 modes are that much slower in 64-bit mode.
 It could just be an artifact of the may the test is done (cache
anomalies?), but I kind of suspect there is something more fishy going on.

The sse2 code in the x1 and x2 case is actually identical between x86-32
and -64 (the x4 case is only available for -64) so it is very strange
that you're seeing this kind of effect.

	-hpa
