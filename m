From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: Tue, 12 Nov 2002 08:30:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DD12CA3.5090105@zytor.com>
References: <aqou9k$ou5$1@cesium.transmeta.com> <20021112162205.GB22407@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jakob Oestergaard wrote:
>>
>>a) write performance will be worse than RAID-5, but I believe it can
>>   be kept to within a factor of 1.5-2.0 on machines with suitable
>>   SIMD instruction sets (e.g. MMX or SSE-2);
> 
> Please note that raw CPU power is usually *not* a limiting (or even
> significantly contributing) factor, on modern systems.
> 
> Limitations are disk reads/writes/seeks, bus bandwidth, etc.
> 
> You will probably cause more bus activity with RAID-6, and that might
> degrade performance. But I don't think you need to worry about
> MMX/SSE/...  If you can do as well as the current RAID-5 code, then you
> will be in the clear until people have 1GB/sec disk transfer-rates on
> 500MHz PIII systems  ;)
> 

RAID-6 will, obviously, never do as well as RAID-5 -- you are doing more 
work (both computational and data-pushing.)  The RAID-6 syndrome 
computation is actually extrememly expensive if you can't do it in 
parallel.  Fortunately there is a way to do it in parallel using MMX or 
SSE-2, although it seems to exist by pure dumb luck -- certainly not by 
design.  I've tried to figure out how to generalize to using regular 
32-bit or 64-bit integer registers, but it doesn't seem to work there.

Again, my initial analysis seems to indicate performance within about a 
factor of 2.

>>b) read performance in normal and single failure degraded mode will be
>>   comparable to RAID-5;
> 
> Which again is like a RAID-0 with some extra seeks... Eg. not too bad
> with huge chunk sizes.
> 
> You might want to consider using huge chunk-sizes when reading, but
> making sure that writes can be made on "sub-chunks" - so that one could
> run a RAID-6 with a 128k chunk size, yet have writes performed on 4k
> chunks.  This is important for performance on both read and write, but
> it is an optimization the current RAID-5 code lacks.

That's an issue for the common framework, I'll leave that to Neil.  It's 
functionally equivalent between RAID-5 and -6.

>>c) read performance in dual failure degraded mode will be quite bad.
>>
>>I'm curious how much interest there would be in this, since I
>>certainly have enough projects without it, and I'm probably going to
>>need some of Neil's time to integrate it into the md driver and the
>>tools.
> 
> I've seen quite some people ask for it.  You might find a friend in "Roy
> Sigurd Karlsbach" - he for one has been asking (loudly) for it  ;)

:)  Enough people have responded that I think I have a project...

	-hpa


