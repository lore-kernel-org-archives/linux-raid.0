From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 / 6 Growth
Date: Thu, 17 Dec 2009 12:53:09 -0500
Message-ID: <4B2A7005.7030409@tmr.com>
References: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: "'Majed B.'" <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:
>> Have you made sure that the value of
>> /proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200
>>     
>
> High enough?  Wouldn't a higher speed limit mean more stress on the systems?
> Its value is 1000.
>
>   
>> MB/s) along with /proc/sys/dev/raid/speed_limit_max?
>>     
>
> It's 200,000
>
>   
What are you actually seeing for rebuild speed? Pushing the min up 
shouldn't matter with the max set high, but if you're not getting 
something like 200MB rebuild there's an issue of some kind. What's the 
stripe cache size?
>> I interrupted an array resyncing a couple of times without issues.
>> Only one time I interrupted an array during growth process and I had
>> an old version of mdadm (2.6.3) which didn't support resuming that. I
>> think Neil told me that 2.6.9 is the minimum requirement to resume.
>>     
>
> It's 2.6.7.2.  Debian does not admit new software into its distro until they
> are rock hard stable, unless it is a bug fix release.  I guess I'll have to
> wait a few more days.
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

