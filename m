From: Hannes Reinecke <hare@suse.de>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 11:50:34 +0200
Message-ID: <c2500336-5848-66c3-ecf0-1ade04decf75@suse.de>
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
 <653e60ee-f862-8828-3e4f-498c7cc34bdc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <653e60ee-f862-8828-3e4f-498c7cc34bdc@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

On 10/17/2016 11:00 AM, SF Markus Elfring wrote:
>>> Calling the function "seq_putc" will be more efficient than "seq_printf"
>>> in this case because of the following reasons.
>>>
>>> 1. How does the distribution look like for supported processor architectures
>>>    where the data transfer for bytes (as a function call parameter)
>>>    is faster than for (string) pointers?
>>>
>> How would I know?
> 
> How many processor architecture characteristics do you know already?
> 
x86, s390x, ppc/ppc64.

> * Is a string pointer often longer than a byte?
> 
Always.

(Which up to now I thought was basic programming knowledge...)

> * I imagine that it can become also interesting to check byte level data access
>   under constraints of machine word sizes and alignment.
> 
So, another test for you to do.

> 
>> I would assume that _you_ did some measurements here;
> 
> How much would you trust in any concrete numbers I could present
> for this use case?
> 
> Do you give more trust to a reference testing platform?
> 
At the moment _any_ test would do.
With every response from your side you just keep on asking further
questions. But so far you haven't delivered any answers nor measurements.

> 
>> I could easily claim that seq_printf() is more efficient than
>> seq_putc(), and won't apply your patch.
> 
> This is also possible in principle.
> 
No, this is what's going to happen if you don't show any measurements.

> 
>> So _you_ have to prove that your patch is more efficient.
> 
> How many results would we like to clarify from various hardware
> and software combinations?
> 
See above. At the moment _any_ test result from your side would do.

> 
>>> 2. Did anybody measure already how many the execution times can vary
>>>    for these functions?
>>>
>> Probably not.
> 
> Thanks for this information.
> 
> How important are the mentioned functions for you within the Linux
> programming interface so far?
> 
Not very. The interface is only used in a slow path, and the execution
time doesn't affect I/O performance in any way.

> 
>> Unless _you_ prove that _your_ patch is more efficient it won't get applied.
> 
> Which data would you accept as a "prove" in this case?
> 
Again: You want something from us. We don't have to prove anything, you
need to convince us. And it is really hard to convince anyone by asking
questions.

> 
>>>    Where do you get doubts about its efficiency for the data processing
>>>    of a single character?
>>>
>> Because it's being called at the end of a function calling seq_printf() already.
> 
> Interesting view …
> 
> 
>> So exchanging a single call is probably not helping anything,
>> as the compiler will optimize it anyway.
> 
> How common is the discussed software transformation between implementations
> for optimising compilers?
> 
> 
>> Case in point: with your patch the x86_64 compiler generates nearly
>> identical code for driver/md/raid1.c, but with one instruction _more_
>> after your patch has been applied.
> 
> Which software versions and command parameters did you try out
> for this information (from an unspecified run time environment)?
> 
> 
# gcc --version
gcc (SUSE Linux) 4.8.5
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is
NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

git tree from git.kernel.org/mkp/u/4.10/scsi-queue

_I_ did some measurements.
I'm still waiting from results from your side.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
