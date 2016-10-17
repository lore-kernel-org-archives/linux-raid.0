From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 13:10:18 +0200
Message-ID: <a0f96e19-fa24-8507-2b77-344a342113aa@users.sourceforge.net>
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
 <c2500336-5848-66c3-ecf0-1ade04decf75@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c2500336-5848-66c3-ecf0-1ade04decf75@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

>> * Is a string pointer often longer than a byte?
>>
> Always.

I have got doubts for this specific information.


> (Which up to now I thought was basic programming knowledge...)

By the way:
Run time environments still exist where the size of a pointer can be also
just one byte, don't they?


>> How many results would we like to clarify from various hardware
>> and software combinations?
>>
> See above. At the moment _any_ test result from your side would do.

I imagine that another single result might not be representative.
How many lessons from test statistics will usually be also relevant here?


>> How important are the mentioned functions for you within the Linux
>> programming interface so far?
>>
> Not very. The interface is only used in a slow path, and the execution
> time doesn't affect I/O performance in any way.

Thanks for another interesting information.


>>> Case in point: with your patch the x86_64 compiler generates nearly
>>> identical code for driver/md/raid1.c, but with one instruction _more_
>>> after your patch has been applied.
>>
>> Which software versions and command parameters did you try out
>> for this information (from an unspecified run time environment)?
>>
> # gcc --version
> gcc (SUSE Linux) 4.8.5

Thanks for this detail.

* Did you choose any special optimisation settings for your quick check?

* Will any compilation results matter if "optimisation" would be
  switched off there?


> I'm still waiting from results from your side.

Would any other software developers or testers dare to add related information?

Regards,
Markus
