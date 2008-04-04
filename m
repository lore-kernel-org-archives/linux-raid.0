From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Fri, 04 Apr 2008 12:11:42 -0700
Message-ID: <47F67D6E.9040802@tigertech.com>
References: <47F020C6.1060809@tigertech.com>	<47F0281F.1070404@harddata.com>	<47F11F12.7010309@tigertech.com>	<18417.16752.269484.583258@tree.ty.sabi.co.uk>	<47F3D173.8060502@tigertech.com> <18421.17821.6915.929392@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18421.17821.6915.929392@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

> But have you checked whether the two ports use shared circuitry
> and in effect the two ports are on the same channel?

I've not been able to find such information at the level of detail which 
would explain whether I should expect this to fail, unfortunately (and I 
have searched).


> Because my
> impression and that of another poster is that your drives are
> sharing the same transfer logic, as if two IDE drives on the
> same ribbon.
 > ...
> For example this guy noticed the exact same problem you are
> seeing with a slightly different (one drive going offline)
> cause:

If that's the same thing, though, it doesn't seem to be a literal "the 
hardware can't handle this" issue, because the poster mentioned that the 
same test worked when running Windows instead of Linux on the same box.

It does sound like perhaps the kernel version I was using just doesn't 
quite handle this situation, and that newer versions of the kernel have 
a rewritten version of the applicable code that could conceivably make a 
difference. If (when) a disk hardware failure happens on one of these 
machines again, I'll report if anything different happens with newer 
kernels.

Thanks again!

-- 
Robert L Mathews

  "In the beginning, the universe was created. This has made a lot of
   people very angry and has been widely regarded as a bad move."
                                                    -- Douglas Adams
