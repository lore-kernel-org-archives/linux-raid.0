From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 11:00:42 +0200
Message-ID: <653e60ee-f862-8828-3e4f-498c7cc34bdc@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
 <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
 <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
 <2cc42b2f-1f1a-e95c-91fa-54e1dd3b6d49@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2cc42b2f-1f1a-e95c-91fa-54e1dd3b6d49@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

>> Calling the function "seq_putc" will be more efficient than "seq_printf"
>> in this case because of the following reasons.
>>
>> 1. How does the distribution look like for supported processor architectures
>>    where the data transfer for bytes (as a function call parameter)
>>    is faster than for (string) pointers?
>>
> How would I know?

How many processor architecture characteristics do you know already?

* Is a string pointer often longer than a byte?

* I imagine that it can become also interesting to check byte level data access
  under constraints of machine word sizes and alignment.


> I would assume that _you_ did some measurements here;

How much would you trust in any concrete numbers I could present
for this use case?

Do you give more trust to a reference testing platform?


> I could easily claim that seq_printf() is more efficient than
> seq_putc(), and won't apply your patch.

This is also possible in principle.


> So _you_ have to prove that your patch is more efficient.

How many results would we like to clarify from various hardware
and software combinations?


>> 2. Did anybody measure already how many the execution times can vary
>>    for these functions?
>>
> Probably not.

Thanks for this information.

How important are the mentioned functions for you within the Linux
programming interface so far?


> Unless _you_ prove that _your_ patch is more efficient it won't get applied.

Which data would you accept as a "prove" in this case?


>>    Where do you get doubts about its efficiency for the data processing
>>    of a single character?
>>
> Because it's being called at the end of a function calling seq_printf() already.

Interesting view …


> So exchanging a single call is probably not helping anything,
> as the compiler will optimize it anyway.

How common is the discussed software transformation between implementations
for optimising compilers?


> Case in point: with your patch the x86_64 compiler generates nearly
> identical code for driver/md/raid1.c, but with one instruction _more_
> after your patch has been applied.

Which software versions and command parameters did you try out
for this information (from an unspecified run time environment)?


> So it's not immediately obvious that your patch is an improvement.

I agree that there are system properties and constraints which can be
considered further.

Regards,
Markus
