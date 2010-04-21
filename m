From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 12:42:04 -0400
Message-ID: <4BCF2ADC.1020600@tmr.com>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCF163C.6040604@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillip Susi wrote:
> On 4/21/2010 9:20 AM, Bill Davidsen wrote:
>   
>> I hear this said, but I don't have any data to back it up. Drive vendors
>> aren't stupid, so if the parking feature is likely to cause premature
>> failures under warranty, I would expect that the feature would not be
>> there, or that the drive would be made more robust. Maybe I have too
>> much faith in greed as a design goal, but I have to wonder if load
>> cycles are as destructive as seems to be the assumption.
>>     
>
> Indeed, I think you have too much faith in people doing sensible things.
>  Especially when their average customer isn't placing the drive in a
> high use environment and they know it, and suggest against doing so.
>
>   
>> I'd love to find some real data, anecdotal stories about older drives
>> are not overly helpful. Clearly there is a trade-off between energy
>> saving, response, and durability, I just don't have any data from a
>> large population of new (green) drives.
>>     
>
> I've not seen any anecdotal stories, but I have seen plenty of reports
> with real data showing a large number of head unloads from the SMART
> data after a relatively short period of use.  Personally mine has a few
> hundred so far and I have not even used it for real storage yet, only
> testing.  The specifications say it's good for 300,000 cycles, so do the
> math... getting 5 unloads per minute would lead to probable failure
> after 41 days.  Granted that is about worst case, but still something to
> watch out for.  In order to make it the entire 3 year warranty period,
> you need to stay under 11.4 unloads per hour.  If you have very little
> IO activity, or VERY MUCH, then this is entirely possible, but more
> moderate loads in the middle have been observed to cause hundreds of
> unloads per hour.
>
> Given that, and the fact that WD themselves have stated that you should
> not use these drives in a raid array, I'd either stay away, or watch out
> for this problem and try to take action to avoid and monitor it.
>   

Part of this is my feeling that no one really knows if the drive fails 
after N loads, because even if WD could set the unload time down, the 
cycle takes time to happen, so I would bet that they are taking an 
educated guess. The other part is that there are lots of clerical tasks 
which would hit the drive, under Windows, single drive, 3-5 times a 
minute. Data entry comes to mind, customer support, print servers, etc. 
Granted that these are probably 7x5 hours a week, but I'm think 2/min, 
7hr/day, 200day/yr... 168k/yr, and that's not the worst case.

Having run lots of drives (some TB of 73GB 15k rpm LVD320) MTTF is 
interesting, because the curve has spikes at the front from infant 
mortality, and at the end from old age, but it was damn quiet in the 
middle. I'd love to see the data on these, not because I'm going to run 
them but just to keep current, so when someone calls me and says they 
got a great deal on green drives, I'll know what to tell them.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

