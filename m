From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: raid6's using not the best bandwidth method && raid6 algo is
 significantly slower in x86_64.
Date: Tue, 18 Nov 2008 07:47:13 -0800
Message-ID: <4922E381.20501@zytor.com>
References: <200811172235.mAHMZAQt032187@terminus.zytor.com> <43d009740811180403v6308dbc0y8ba093524700bb72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43d009740811180403v6308dbc0y8ba093524700bb72@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Igor Podlesny wrote:
> 2008/11/18 H. Peter Anvin <hpa@zytor.com>:
>> Interesting... Perhaps you could send me your "bad" kernel vmlinux or raid456.ko file;
> 
> 	Mine raid456 isn't a module, it's built-in into kernel. Will be .o
> enough? Or would it be better to re-compile as module?
> 
>> preferrably compiled with CONFIG_DEBUG_INFO.
> 

Built-in is fine.  I need the vmlinux file, though, not bzImage.

	-hpa
