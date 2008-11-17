From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is significantly slower in x86_64.
Date: Tue, 18 Nov 2008 03:56:17 +0700
Message-ID: <43d009740811171256p3732f179j8f5abccba27c73cf@mail.gmail.com>
References: <43d009740811160818v49c530b1r9e01b79c1d9dcfdd@mail.gmail.com>
	 <4920BC77.9010709@zytor.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4920BC77.9010709@zytor.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

2008/11/17 H. Peter Anvin <hpa@zytor.com>:
> Igor Podlesny wrote:
>>
[...]
>> Has anyone on the list similar observations? Can gcc's version
>> difference affect so much? I doubt that, but I can try build x86_32
>> with gcc 4.3.1 (as x86_64 was).
>>
>
> The SSE modes have nicer cache behaviours and are therefore preferred
> even if they are slower.
>
That was my guess that they're preferable (but I wasn't aware of exact
reason, thanks!). :-)
>
> It is very odd that your SSE2 modes are that much slower in 64-bit mode.
>  It could just be an artifact of the may the test is done (cache
> anomalies?), but I kind of suspect there is something more fishy going on.

I've built gcc-4.2.4 and recompiled the kernel with it. .config's diff:
	
    -CONFIG_LOCALVERSION="-64_1khz"
    +CONFIG_LOCALVERSION="-64_1khz-gcc42"
     CONFIG_LOCALVERSION_AUTO=y
     CONFIG_SWAP=y
     CONFIG_SYSVIPC=y
    @@ -287,7 +287,7 @@
     # CONFIG_RELOCATABLE is not set
     CONFIG_PHYSICAL_ALIGN=0x200000
     CONFIG_HOTPLUG_CPU=y
    -CONFIG_COMPAT_VDSO=y
    +# CONFIG_COMPAT_VDSO is not set

And dmesg now says:
	
    [    2.606258] raid6: int64x1   2210 MB/s
    [    2.623255] raid6: int64x2   3246 MB/s
    [    2.640257] raid6: int64x4   3289 MB/s
    [    2.657262] raid6: int64x8   3019 MB/s
    [    2.674262] raid6: sse2x1    4253 MB/s
    [    2.691258] raid6: sse2x2    5621 MB/s
    [    2.708261] raid6: sse2x4    5718 MB/s
    [    2.708299] raid6: using algorithm sse2x4 (5718 MB/s)

So, I deem that's not VDSO's effect but gcc's version instead.

-- 
End of message. Next message?
