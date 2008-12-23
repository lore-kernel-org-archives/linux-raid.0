From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: WD GreenPower & Load_Cycle_Count
Date: Tue, 23 Dec 2008 16:49:04 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0812231642390.17215@uplift.swm.pp.se>
References: <20081223145334.GA17496@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081223145334.GA17496@sewage.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Dec 2008, Matt Garman wrote:

> Anyway, I haven't been able to find a conclusive answer to this on the 
> web.  Just wondering if anyone on the list has any more info.

I bought a couple of drives ~8 months ago. They started racking up 
Load_Cycle_Counts, so I used wdidle3.exe to shut it off (I think they were 
up to 8k load cycle counts in the first couple of days).

I then purchased two new drives 1-2 months ago. Didn't do anything to 
them, but they seem to have different factory settings:

$ sudo smartctl -a /dev/sdb | egrep 'Power_On|Load_Cycle'
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       1031
193 Load_Cycle_Count        0x0032   197   197   000    Old_age   Always       -       11184
$ sudo smartctl -a /dev/sdc | egrep 'Power_On|Load_Cycle'
   9 Power_On_Hours          0x0032   093   093   000    Old_age   Always       -       5329
193 Load_Cycle_Count        0x0032   188   188   000    Old_age   Always       -       38070

sdb is one of the newer drives, sdc is one of the older ones.

So wdidle3.exe seems to shut off the mechanism that causes 
Load_Cycle_Count to rise quickly, more agressively than the new factory 
defaults, but the new factory defaults at least mean the drive gets an 
estimated life time of 3 years before they reach 300k Load_Cycle_Counts, 
in my environment.

Both drives show same firmware and model numbers.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
