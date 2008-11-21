From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is
 significantly slower in x86_64.
Date: Fri, 21 Nov 2008 11:31:49 -0800
Message-ID: <49270CA5.2090508@zytor.com>
References: <200811172235.mAHMZAQt032187@terminus.zytor.com>	 <43d009740811180403v6308dbc0y8ba093524700bb72@mail.gmail.com>	 <4922E381.20501@zytor.com> <43d009740811211122m36809523mff9521ca8af95a1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740811211122m36809523mff9521ca8af95a1e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Igor Podlesny wrote:
> 2008/11/18 H. Peter Anvin <hpa@zytor.com>:
>> Igor Podlesny wrote:
>>> 2008/11/18 H. Peter Anvin <hpa@zytor.com>:
>>>> Interesting... Perhaps you could send me your "bad" kernel vmlinux or
>>>> raid456.ko file;
> 
> 	I've narrowed it a bit: the problem arises only when "-Os" is being used.
>> Built-in is fine.  I need the vmlinux file, though, not bzImage.
>>
> 	Ok, it's compiling right now. vmlinux is pretty huge, so I guess it'd
> be better to upload it to an ftp.
> 

It probably is.  My side can handle large emails, but yours might not
(and, obviously, don't send it to the list.)

It sort of makes sense that -Os would break this stuff.  For newer gccs,
it would be better to use SSE2 intrinsics rather than inline assembly.
The problem is that it breaks older gcc.

	-hpa
