From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 17:00:47 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1004221658040.6768@uplift.swm.pp.se>
References: <626601cae203$dae35030$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <626601cae203$dae35030$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Apr 2010, Janos Haar wrote:

> My question is, there is any way, to force the array to keep the members in 
> even if have some reading errors?

What version of the kernel are you running? If it's running anywhere 
recent kernel it shouldn't kick drives upon read error but instead 
recreate from parity. You should probably send "repair" to the md device 
(echo repair > /sys/block/mdX/md/sync_action) and see if that fixes the 
bad blocks. I believe this came in 2.6.15 or something like that (google 
if you're in that neighbourhood, if you're in 2.6.26 or alike then you 
should be fine).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
