From: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Fri, 23 Feb 2007 13:15:10 +0100
Message-ID: <45DEDACE.2000601@aitel.hist.no>
References: <20070220172544.15678.patches@notabene>	<1070220063516.16208@suse.de>	<20070221144806.e6eed85c.akpm@linux-foundation.org>	<17885.636.133245.572876@notabene.brown> <20070221185739.0d509c0d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932274AbXBWMSP@vger.kernel.org>
In-Reply-To: <20070221185739.0d509c0d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Andrew Morton wrote:
> On Thu, 22 Feb 2007 13:39:56 +1100 Neil Brown <neilb@suse.de> wrote:
>
>   
>> I must right code that Andrew can read.
>>     
>
> That's write.
>
> But more importantly, things that people can immediately see and understand
> help reduce the possibility of mistakes.  Now and in the future.
>
> If we did all loops like that, then it'd be the the best way to do it in new code,
> because people's eyes and brains are locked into that idiom and we just
> don't have to think about it when we see it.
I have done lots of loops like that and understood it immediately.
Nice, short, _clear_ and no - a loop that counts down instead of
up is not difficult at all. 
Testing "i--" instead of "i >= 0" is also something I consider trivial,
even though I don't code that much.  If this is among the worst you
see, then the kernel source must be in great shape ;-)

Helge Hafting
