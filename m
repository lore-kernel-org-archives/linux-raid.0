From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Mon, 04 Sep 2006 14:18:26 -0400
Message-ID: <44FC6DF2.7010206@tmr.com>
References: <44E250CD.5040308@aol.com> <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net> <44E2EE20.9010004@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44E2EE20.9010004@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: gordon@drogon.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alternatives would be to have two such backup devices, and configure 
them, as andy liebman wrote:

>
> I may not have been clear what I was asking. I wanted to know if you 
> can make DISK IMAGES -- for example, with a program like Norton Ghost 
> or Acronis True Image (better) -- of EACH of the two OS drives from a 
> mirrored pair. Then restore Image A to one new disk, Image B to 
> another disk. And then have a new working mirrored pair.

May I say belatedly (I've been flat out since July 1) that if I were 
making a significant number of these clones, I'd write a script so that 
I could clone one drive, drop it in another machine, and let the script 
run on the other machine to finish the job. I have no idea how many of 
these you are doing, but automation is nice to avoid finger checks.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

