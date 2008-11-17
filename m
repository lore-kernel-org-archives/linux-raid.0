From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: raid6's using not the best bandwidth method && raid6 algo is
 significantly slower in x86_64.
Date: Mon, 17 Nov 2008 14:35:28 -0800
Message-ID: <200811172235.mAHMZAQt032187@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: 
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Interesting... Perhaps you could send me your "bad" kernel vmlinux or raid456.ko file; preferrably compiled with CONFIG_DEBUG_INFO.

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Igor Podlesny <for.poige+linux@gmail.com>
Sent: Monday, November 17, 2008 12:56
To: H. Peter Anvin <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org; neilb@suse.de
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is significantly slower in x86_64.

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
> anomalies?), but I kind of suspect there is something more fishy going on