From: David Brown <david.brown@hesbynett.no>
Subject: Re: high throughput storage server?
Date: Thu, 24 Feb 2011 21:43:16 +0100
Message-ID: <ik6ft4$n8f$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>	<20110215044434.GA9186@septictank.raw-sewage.fake>	<ijdhtg$on7$1@dough.gmane.org> <AANLkTi=DFXqt5VAJHdVkzigM1UfdNKwrTX589aCcBm4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=DFXqt5VAJHdVkzigM1UfdNKwrTX589aCcBm4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/02/11 21:28, Matt Garman wrote:
> Wow, I can't believe the number of responses I've received to this
> question.  I've been trying to digest it all.  I'm going to throw some
> follow-up comments as time allows, starting here...
>
> On Tue, Feb 15, 2011 at 3:43 AM, David Brown<david@westcontrol.com>  wrote:
>> If you are not too bothered about write performance, I'd put a fair amount
>> of the budget into ram rather than just disk performance.  When you've got
>> the ram space to make sure small reads are mostly cached, the main
>> bottleneck will be sequential reads - and big hard disks handle sequential
>> reads as fast as expensive SSDs.
>
> I could be wrong, but I'm not so sure RAM would be beneficial for our
> case.  Are workload is virtually all reads, however, these are huge
> reads.  The analysis programs basically do a full read of data files
> that are generally pretty big: roughly 100 MB to 5 GB in the worst
> case.  Average file size is maybe 500 MB (rough estimate).  And there
> are hundreds of these falls, all of which need "immediate" access.  So
> to cache these in RAM, seems like it would take an awful lot of RAM.

RAM for cache makes a difference if the same file is read more than 
once.  That applies equally to big files - but only if more than one 
machine is reading the same file.  If they are all reading different 
files, then - as you say - there won't be much to gain as each file is 
only used once.

Still, when you have so much data going from the disks and out to the 
clients, it is good to have plenty of ram for buffering, even if it is 
only used once.

