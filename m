From: david@lang.hm
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 10:16:17 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706160947350.7557@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
 <4673E7DC.80508@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4673E7DC.80508@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 16 Jun 2007, David Greaves wrote:

> david@lang.hm wrote:
>>  On Sat, 16 Jun 2007, Neil Brown wrote:
>>
>>  I want to test several configurations, from a 45 disk raid6 to a 45 disk
>>  raid0. at 2-3 days per test (or longer, depending on the tests) this
>>  becomes a very slow process.
> Are you suggesting the code that is written to enhance data integrity is 
> optimised (or even touched) to support this kind of test scenario?
> Seriously? :)

actually, if it can be done without a huge impact to the maintainability 
of the code I think it would be a good idea for the simple reason that I 
think the increased experimentation would result in people finding out 
what raid level is really appropriate for their needs.

there is a _lot_ of confusion around about what the performance 
implications of different raid levels are (especially when you consider 
things like raid 10/50/60 where you have two layers combined) and anything 
that encourages experimentation would be a good thing.

>>  also, when a rebuild is slow enough (and has enough of a performance
>>  impact) it's not uncommon to want to operate in degraded mode just long
>>  enought oget to a maintinance window and then recreate the array and
>>  reload from backup.
>
> so would mdadm --remove the rebuilding disk help?

no. let me try again

drive fails monday morning

scenerio 1

replace the failed drive, start the rebuild. system will be slow (degraded 
mode + rebuild) for the next three days.

scenerio 2

leave it in degraded mode until monday night (accepting the speed penalty 
for degraded mode, but not the rebuild penalty)

monday night shutdown the system, put in the new drive, reinitialize the 
array, reload the system from backup.

system is back to full speed tuesday morning.

scenerio 2 isn't supported with md today, although it sounds as if the 
skip rebuild could do this except for raid 5

on my test system, the rebuild says it's running at 5M/s a DD to a file on 
the array says it's doing 45M/s (even while the rebuild is running), so it 
seems to me that there may be value in this approach.

David Lang

