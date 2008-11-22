From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is
 significantly slower in x86_64.
Date: Fri, 21 Nov 2008 21:42:29 -0800
Message-ID: <49279BC5.8080106@zytor.com>
References: <200811172235.mAHMZAQt032187@terminus.zytor.com>	 <43d009740811180403v6308dbc0y8ba093524700bb72@mail.gmail.com>	 <4922E381.20501@zytor.com>	 <43d009740811211122m36809523mff9521ca8af95a1e@mail.gmail.com>	 <49270CA5.2090508@zytor.com>	 <43d009740811211133p7321bc39q1a1eccd9c53d6ca0@mail.gmail.com>	 <492716CE.8040900@zytor.com> <43d009740811212140l3ac2298ch512aca0e3631d269@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740811212140l3ac2298ch512aca0e3631d269@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Igor Podlesny wrote:
> 2008/11/22 H. Peter Anvin <hpa@zytor.com>:
> [...]
>> I just tested a version using gcc intrinsics with gcc 4.3, and it is
>> almost 20% faster than the inline assembly version.  That, plus the fact
>> that the code is actually readable, makes me really want to figure out
>> how best to deploy this.
> 
> 	Please let us know when commiting the patch -- 20 % is valuable. ;-)
> 

Looks like I was a bit too optimistic.  The 20% was because of the 
missed prefetchnta, which means polluting the cache.

	-hpa
