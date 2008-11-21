From: "Igor Podlesny" <for.poige+linux@gmail.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is significantly slower in x86_64.
Date: Sat, 22 Nov 2008 02:33:57 +0700
Message-ID: <43d009740811211133p7321bc39q1a1eccd9c53d6ca0@mail.gmail.com>
References: <200811172235.mAHMZAQt032187@terminus.zytor.com>
	 <43d009740811180403v6308dbc0y8ba093524700bb72@mail.gmail.com>
	 <4922E381.20501@zytor.com>
	 <43d009740811211122m36809523mff9521ca8af95a1e@mail.gmail.com>
	 <49270CA5.2090508@zytor.com>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49270CA5.2090508@zytor.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2008/11/22 H. Peter Anvin <hpa@zytor.com>:
[...]
> It sort of makes sense that -Os would break this stuff.  For newer gccs,
> it would be better to use SSE2 intrinsics rather than inline assembly.
> The problem is that it breaks older gcc.
>
	Well, #ifdef could be helpful then, couldn't it? :-)

-- 
End of message. Next message?
