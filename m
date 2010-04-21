From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 16:32:44 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1004211625580.6768@uplift.swm.pp.se>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCEFB99.9080806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 21 Apr 2010, Bill Davidsen wrote:

> I hear this said, but I don't have any data to back it up. Drive vendors 
> aren't stupid, so if the parking feature is likely to cause premature 
> failures under warranty, I would expect that the feature would not be there, 
> or that the drive would be made more robust. Maybe I have too much faith in 
> greed as a design goal, but I have to wonder if load cycles are as 
> destructive as seems to be the assumption.

What I think people are worried about is that a drive might have X 
load/unload cycles in the data sheet (300k or 600k seem to be normal 
figures) and reaching this in 1-2 years of "normal" (according to the 
user who is running it 24/7) might be worrying (and understandably so).

Otoh these drives seem to be designed for desktop 8 hour per day use, so 
running them as a 24/7 fileserver under linux is not what they were 
designed for. I have no idea what will happen when the load/unload cycles 
goes over the data sheet number, but my guess is that it was put there for 
a reason.

> I'd love to find some real data, anecdotal stories about older drives are not 
> overly helpful. Clearly there is a trade-off between energy saving, response, 
> and durability, I just don't have any data from a large population of new 
> (green) drives.

My personal experience from the WD20EADS drives is that around 40% of 
them failed within the first year of operation. This is not from a large 
population of drives though and wasn't due to load/unload cycles. I had no 
problem getting them replaced under warranty, but I'm running RAID6 
nowadays :P

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
