From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Raid reconstructing and process hanging in D state
Date: Fri, 16 Oct 2009 08:44:50 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
References: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de>
 <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 16 Oct 2009, Justin Piszcz wrote:
> Hi,
>
> I have the same problem with mdadm/raid-1, if you do not limit the speed in 
> the speed_limit_min paramter, it will starve the I/O from all other processes 
> and result in the same problem you are having.
>
But in my case speed_limit_min was set to 1000 and speed_limit_max was 200000
(ie. the default) and this still caused all process to hang in D-state. Only
lowering speed_limit_max helped to make the system responsive again.

> But for me I'm not sure about the reconstruction-- this happens for me during 
> a raid verify/check.
>
This was also the case for me, during a raid verify/check.

Holger
