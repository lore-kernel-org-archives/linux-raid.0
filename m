From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Is the LSI SAS9211-8i still the go to HBA?
Date: Mon, 2 Oct 2017 15:41:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1710021533340.31961@uplift.swm.pp.se>
References: <1d014bd9-7946-ba3e-f5fb-f64a92ccc769@eyal.emu.id.au> <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edaf46e4-8f70-1471-3353-d67deeb4d03a@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2 Oct 2017, Eyal Lebedinsky wrote:

> I will not use SSDs with the card, so handling 8 HDDs should not be a 
> stretch for either one?

I know people who use 9211-8i with 36 drives via SAS expanders. With HDDs, 
this isn't typically a problem, it's mostly a bandwidth problem than IOPS 
problem.

If I were to deploy an 8 drive machine, 9211-8i or cards with similar LSI 
2008 chips, would be my first choice (since it's cheap and is widely 
used).

There has been some firmware trouble with it. I believe P20 had trouble. 
P19 seems to work fine.

https://www.centos.org/forums/viewtopic.php?t=50032

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
