From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Stripe dirty bitmap
Date: Sun, 04 Jul 2010 21:24:50 -0400
Message-ID: <4C313462.8090403@tmr.com>
References: <4C3126C0.4050709@tmr.com> <20100705110203.01502ac1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100705110203.01502ac1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sun, 04 Jul 2010 20:26:40 -0400
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>> Sure would be nice to have md track whole never written stripes, so 
>> creating an array didn't have to be done over a three day weekend. When 
>> any part of a virgin stripe was written it could then be initialized 
>> properly, and when a virgin stripe was read zeros could be returned 
>> without disk i/o. It doesn't matter that the reads are done in parallel, 
>> with modern disk the bus is the bottleneck. With eSATA arrays the bus is 
>> slow to start with, passing TB through it should be avoided if possible.
>>
>>     
>
> Sure would.
>   

Have to have a copy on each drive, I think? Use a bit for a group of N 
stripes or one per stripe? Put N in the metadata?
I'd use stripe_cache_size, but that changes.
As disk gets cheap (1.5TB for $65 this weekend?) bus speed is being an 
issue, more so with software raid which does the io out of system memory.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

