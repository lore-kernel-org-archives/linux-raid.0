From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Interesting RAID checking observations
Date: Mon, 04 Sep 2006 13:16:05 -0400
Message-ID: <44FC5F55.6000008@tmr.com>
References: <20060828131552.5776.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060828131552.5776.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux@horizon.com wrote:

>>I don't think the processor is saturating.  I've seen reports of this
>>sort of thing before and until recently had no idea what was happening,
>>couldn't reproduce it, and couldn't think of any more useful data to
>>collect.
>>    
>>
>
>Well I can reproduce it easily enough.  It's a production server, but
>I can do low-risk experiments after hours.
>
>I'd like to note that the symptoms include not even being
>able to *type* at the console, which I thought was all in-kernel
>code, not subject to being swapped out.  But whatever.
>
Really? Or is it just that you can type but the characters don't get 
echoed. The type part is in the kernel, but the display involves X 
unless you run a direct console.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

