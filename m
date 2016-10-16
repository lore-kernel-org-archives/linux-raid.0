From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Sun, 16 Oct 2016 19:18:06 +0200
Message-ID: <e64792b7-5806-dccd-39ea-92f44131d3a5@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
 <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
 <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <59d71170-c48d-a084-c748-b6ab74a2bee4@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

> Yes. - I got such an impression.

Correction:

* Is it more efficient to call the function "seq_putc" for the desired data processing
  for a single character than to pass it to the function "seq_printf" in a string?

* Will the required data transfer shrink a bit for the affected functions because of
  such a change?
  How do you think about to reduce the transmission for such tiny strings
  containing delimiters?

Regards,
Markus
