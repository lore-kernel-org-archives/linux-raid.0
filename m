From: David Brown <david.brown@hesbynett.no>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 12:52:32 +0100
Message-ID: <52A9A380.50805@hesbynett.no>
References: <52A98FAF.4000205@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A98FAF.4000205@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/12/13 11:27, Pieter De Wit wrote:
> Hi List,
> 
> Given the recent work done with techs like CUDA etc. - has the idea been
> floated to use the video card for RAID parity calculations vs the CPU ?
> Bitcoin and plenty others have shown the true speed of these cards. This
> might be a cheaper version of a RAID card.
> 
> Cheers,
> 
> Pieter

I am almost certain that you /could/ use a graphics card to do parity
calculations faster than a cpu core.  However, even the newly proposed
multi-parity calculations are not a big challenge for a modern cpu.  A
bigger issue is getting optimal threading so that multiple cores (or at
least threads) can be used at the same time, and this work is well under
way already.  Once that work is completed, my guess is that I/O, cache
or memory bandwidth will be the bottleneck for big raid arrays rather
than cpu power - and using graphics cards will not help there.

David


