From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 09:39:25 +0200
Message-ID: <83e720c6-9037-a3c1-6e83-27505805f37f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
 <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1e151094-e228-5307-ae2f-b376b31f5628@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

>>> Does it improve code? Does it improve anything?
>>
>> Yes. - I got such an impression.
>>
>> * Is it more efficient to call the function "seq_printf" for the desired data processing
>>   for a single character than to pass it to the function "" in a string?
>>
>> * Will the required data transfer shrink a bit for the affected functions because of
>>   such a change?
>>
> Which are questions _you_ should be able to answer.

I wonder that the answers are not obvious for you already.

Calling the function "seq_putc" will be more efficient than "seq_printf"
in this case because of the following reasons.

1. How does the distribution look like for supported processor architectures
   where the data transfer for bytes (as a function call parameter)
   is faster than for (string) pointers?

2. Did anybody measure already how many the execution times can vary
   for these functions?

3. seq_printf() provides more functionality as this kind of programming
   interface was designed for a bigger purpose.
   How much do you care for consequences when such general functions
   are called with input data they were not designed for mainly?

4. The seq_putc() implementation is so simple.
   http://lxr.free-electrons.com/source/fs/seq_file.c?v=4.8#L657

   Where do you get doubts about its efficiency for the data processing
   of a single character?


> It's your patch, after all.

Yes. - I published a special update suggestion once again.


> Once you do (and prove that the answer is 'yes' to the above two
> questions) the patch will be applied.

How do you think about to share a bit more from your software development
and testing experience?
Which call frequencies do you observe for the affected functions?

1. raid1_status
2. raid10_status
3. raid5_status

Regards,
Markus
