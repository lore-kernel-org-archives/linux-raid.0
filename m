From: Michal Soltys <soltys@ziu.info>
Subject: Re: Tools for Hardware Raid?
Date: Mon, 28 Dec 2009 18:44:22 +0100
Message-ID: <4B38EE76.3000707@ziu.info>
References: <1262014433.25079.212.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1262014433.25079.212.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rick Bragg wrote:
> Hi,
> 
> Since my latest disaster was caused be me not monitoring raid disks, I
> was wondering about tools for monitoring hardware based raid systems?
> 
> I have a Dell 1900 with a perc5 raid controller
> 
> # lspci
> 02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5
> 
> It is set up as RAID 10
> 
> I tried running smartctl on it, but that does not even work because the
> system sees the array as just one disk.
> 
> I'm wondering how I can monitor the disks, etc...
> 
> Any advice?
> 
> Thanks
> Rick
> 

Most recent version (5.39) of smartmontools allows monitoring disks behind 
perc controllers - for example: smartctl -a -d megaraid,1 /dev/sda

I'm not using any perc at the moment, so no idea how well that works in 
practice - probably worth checking out though.

