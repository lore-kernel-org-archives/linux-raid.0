From: Mirko Benz <mirko.benz@web.de>
Subject: Re: NVRAM support
Date: Mon, 20 Feb 2006 10:57:02 +0100
Message-ID: <43F9926E.6040104@web.de>
References: <43EC5655.1060504@web.de>	<20060210124204.GC28676@harddisk-recovery.com>	<43ECB4A4.6010005@tmr.com>	<Pine.LNX.4.64.0602101700540.30925@twinlark.arctic.org>	<20060213092204.GB3209@harddisk-recovery.nl>	<43F2E526.9010409@web.de> <17395.45710.99321.522482@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17395.45710.99321.522482@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

We have applications were large data sets (e.g. 100 MB) are sequentially 
written.
Software RAID could do a full stripe update (without reading/using 
existing data).
Does this happen in parallel? If yes, isn't that data vulnerable when a 
crash occurs?

Thanks,
Mirko

Neil Brown schrieb:
> On Wednesday February 15, mirko.benz@web.de wrote:
>   
>> Hi,
>>
>> My intention was not to use a NVRAM device for swap.
>>
>> Enterprise storage systems use NVRAM for better data protection/faster 
>> recovery in case of a crash.
>> Modern CPUs can do RAID calculation very fast. But Linux RAID is 
>> vulnerable when a crash during a write operation occurs.
>> E.g. Data and parity write requests are issued in parallel but only one 
>> finishes. This will
>> lead to inconsistent data. It will be undetected and can not be 
>> repaired. Right?
>>     
>
> Wrong.  Well, maybe 5% right.
>
> If the array is degraded, that the inconsistency cannot be detected.
> If the array is fully functioning, then any inconsistency will be
> corrected by a 'resync'.
>
>   
>> How can journaling be implemented within linux-raid?
>>     
>
> With a fair bit of work. :-)
>
>   
>> I have seen a paper that tries this in cooperation with a file system:
>> ?Journal-guided Resynchronization for Software RAID?
>> www.cs.wisc.edu/adsl/Publications
>>     
>
> This is using the ext3 journal to make the 'resync' (mentioned above)
> faster.  Write-intent bitmaps can achieve similar speedups with
> different costs.
>
>   
>> But I would rather see a solution within md so that other file systems 
>> or LVM can be used on top of md.
>>     
>
> Currently there is no solution to the "crash while writing and
> degraded on restart means possible silent data corruption" problem.
> However is it, in reality, a very small problem (unless you regularly
> run with a degraded array - don't do that).
>
> The only practical fix at the filesystem level is, as you suggest,
> journalling to NVRAM.  There is work underway to restructure md/raid5
> to be able to off-load the xor and raid6 calculations to dedicated
> hardware.  This restructure would also make it a lot easier to journal
> raid5 updates thus closing this hole (and also improving write
> latency).
>
> NeilBrown
>
>   

