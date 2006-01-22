From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: Save to use spindown?
Date: Sun, 22 Jan 2006 03:10:46 +0100
Message-ID: <43D2E9A6.8000703@xs4all.nl>
References: <Pine.LNX.4.44.0601211616510.24057-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601211616510.24057-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
> you seem to be assuming that the drives have a lifespan measured in 
> hours-spinning.  that's not at all clear.  for instance, drives
> are typically rated 40-50K start-stop cycles, which is ~40/day
> over a 3-year service life.
>
> you clearly do not want to auto-spindown unless you are sure that 
> they'll spun-down for a fairly long time.  even ignoring delay in 
> spinup...
>   
Hm, 40-50k start-stop cycles?  That's far more than I would have 
thought.  I always figured that my hard drives would live longer if I 
kept them spinning instead of spinning them down even once a day.  Most 
of my drives at the moment are below 10 start-stop cycles, even though 
the array is only used very lightly for a few hours every day.

It sounds to me it might not be a bad idea for me to spin the drives 
down in my case.

>> that good. Too many things running on your server will keep them going -
>> eg. ext3 likes to peek at the drives every 5 seconds (and it's probable
>> that other journaling FS's to some extent or other).
>>     
>
> I don't believe ext3 will generate journal forces unless you do something
> that generates data or journal IO.  for instance, atime updates are often
> overlooked here.  I generally turn atime stuff off anyway.
>   
But accessing the drive will spin it up anyway, so why would it be 
prudent to turn atime off (apart from the fact that it is often not 
needed anyway)?

--John

