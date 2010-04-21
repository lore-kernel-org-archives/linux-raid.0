From: Berkey B Walker <berk@panix.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 17:58:23 -0400
Message-ID: <4BCF74FF.9080909@panix.com>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com> <alpine.DEB.1.10.1004211625580.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1004211625580.6768@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Bill Davidsen <davidsen@tmr.com>, Phillip Susi <psusi@cfl.rr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Mikael Abrahamsson wrote:
> On Wed, 21 Apr 2010, Bill Davidsen wrote:
>
>> I hear this said, but I don't have any data to back it up. Drive 
>> vendors aren't stupid, so if the parking feature is likely to cause 
>> premature failures under warranty, I would expect that the feature 
>> would not be there, or that the drive would be made more robust. 
>> Maybe I have too much faith in greed as a design goal, but I have to 
>> wonder if load cycles are as destructive as seems to be the assumption.
>
> What I think people are worried about is that a drive might have X 
> load/unload cycles in the data sheet (300k or 600k seem to be normal 
> figures) and reaching this in 1-2 years of "normal" (according to the 
> user who is running it 24/7) might be worrying (and understandably so).
>
> Otoh these drives seem to be designed for desktop 8 hour per day use, 
> so running them as a 24/7 fileserver under linux is not what they were 
> designed for. I have no idea what will happen when the load/unload 
> cycles goes over the data sheet number, but my guess is that it was 
> put there for a reason.
>
>> I'd love to find some real data, anecdotal stories about older drives 
>> are not overly helpful. Clearly there is a trade-off between energy 
>> saving, response, and durability, I just don't have any data from a 
>> large population of new (green) drives.
>
> My personal experience from the WD20EADS drives is that around 40% of 
> them failed within the first year of operation. This is not from a 
> large population of drives though and wasn't due to load/unload 
> cycles. I had no problem getting them replaced under warranty, but I'm 
> running RAID6 nowadays :P
>
Sorry, you sound like a factory droid.  *I* see no reason for early 
failure besides cheap mat'ls in construction.  Were these assertations 
of short life to be true, I would campaign against the drive maker.  (I 
think that they are just normalizing failure rate against warranty 
claims)  Buy good stuff.  I *wish* I could define the term by mfg. It 
seems Seagate, & WD don't hack it.  The Japanese drives did, but since 
the $ dropped -

One thing seemingly missed is the relationship between storage density 
and drive temp.variations..  Hard drive mfgs are going to be in deep 
doodoo when the SSD folks get price/perf in the lead lane.  This year, I 
predict.  And maybe another 2 for long term reliability to be in the lead..

I believe that many [most?] RAID users are looking for results (long 
term archival) that are not intended in the design.We are about 2 
generations away from that being a reality - I think..  For other users, 
I would suggest a mirror machine. with both machines being scrubbed 
daily, and media being dissimilar in mfg and mfg date.

I can't wait until Neil gets to (has to) play/work with the coming tech. 
Neat things are coming.

b-

