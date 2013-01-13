From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Slow RAID 5 performance all of a sudden
Date: Sun, 13 Jan 2013 14:40:37 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301131440050.12098@uplift.swm.pp.se>
References: <50F27901.4070404@s-tainment.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F27901.4070404@s-tainment.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Divan Santana <divan@s-tainment.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Jan 2013, Divan Santana wrote:

> Anyone have any ideas what I can do to troubleshoot this further or what 
> may be causing this?

"iostat -x 5" is what I typically use to get more insight into what's 
going on.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
