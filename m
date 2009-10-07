From: Asdo <asdo@shiftmail.org>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Wed, 07 Oct 2009 20:33:23 +0200
Message-ID: <4ACCDEF3.5000804@shiftmail.org>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
 <19141.32211.742547.19481@notabene.brown>
 <1254875779.16798.10.camel@dwillia2-linux.ch.intel.com>
 <Pine.LNX.4.64.0910071141010.29237@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.64.0910071141010.29237@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:
> On Tue, 6 Oct 2009, Dan Williams wrote:
>
>> ....
>> By downleveling the parallelism to raid_run_ops the pathological
>> stripe_head bouncing is eliminated.  This version still exhibits an
>> average 11% throughput....
>>
>> So we don't need a revert, this fixes up the unpredictability of the
>> original implementation.  It surprised me that the overhead of passing
>> raid_run_ops to the async thread pool amounted to an 11% performance
>> regression.  In any event I think this is a better baseline for future
>> multicore experimentation than the current implementation.
>>
> Just to add some more information, I did try this patch with
> 2.6.32-rc3-git1 and with the testing I am doing I get appr. 125%
> performance regression. 
Hi Holger

 From the above sentence it seems you get worse performance now than 
with the original multicore implementation, while from the numbers below 
it seems you get better performances now.

Which is correct?

(BTW a performance regression higher than 100% is impossible :-) )

> The tests I am doing is have several (appr. 60
> process) sending via FTP or SFTP about 100000 small files (average size
> below 4096 bytes) to localhost in a loop for 30 minutes. Here the
> real numbers:
>
>  with multicore support enabled (with your patch)    3276.77 files per 
> second
>  with multicore support enabled (without your patch) 1014.47 files per 
> second
>  without multicore support                           7549.24 files per 
> second
>
> Holger

Also, could you tell us some details about your machine and the RAID?
Like the model of CPU (Nehalems and AMDs have much faster memory access 
than earlier intels) and if it's a single-cpu or a dual cpu mainboard...
Amount of RAM
also: stripe_cache_size current setting for your RAID
Raid level, number of disks, chunk size, filesystem...

Thank you!

