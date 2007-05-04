From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid1 replaced with raid10?
Date: Fri, 04 May 2007 11:07:59 -0400
Message-ID: <463B4C4F.9030504@tmr.com>
References: <45FF1BDF.6060304@rabbit.us> <463B2D15.7020305@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463B2D15.7020305@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hi,
>
> I asked this question back in march but received no answers, so here it
> goes again. Is it safe to replace raid1 with raid10 where the amount of
> disks is equal to the amount of far/near/offset copies? I understand it
> has the downside of not being a bit-by-bit mirror of a plain filesystem.
> Are there any other caveats?
>   
Clearly you have reduced capacity, since there's a mirror AND a CRC, 
otherwise I don't see any drawbacks. The performance should be much better.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

