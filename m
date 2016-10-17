From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: MD-RAID: Use seq_putc() in three status functions?
Date: Mon, 17 Oct 2016 13:32:00 +0200
Message-ID: <1476703920.2520.105.camel@petrovitsch.priv.at>
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
         <a0f96e19-fa24-8507-2b77-344a342113aa@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <a0f96e19-fa24-8507-2b77-344a342113aa@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, kbuild-all@01.org, ltp@lists.linux.it
List-Id: linux-raid.ids

On Mon, 2016-10-17 at 13:10 +0200, SF Markus Elfring wrote:
[...]
> > (Which up to now I thought was basic programming knowledge...)
> 
> By the way:
> Run time environments still exist where the size of a pointer can
> be also just one byte, don't they?

In the context of the Linux kernel: No.

[ Side note: there might be some DSP out there with a running Linux
kernel which cannot really address a "byte" (meaning 8bits) but only in
register sized quantities (and also aligned for that). But no one cares
here really deeply as that is a so fundamental difference that the C-
compiler must cope with that anyways in the first place. ]

[...]
> > See above. At the moment _any_ test result from your side would do.
> 
> I imagine that another single result might not be representative.

Publish not only results but also everything (complete!) so that anyone
can *easily* follow it to check and reproduce the results - especially
if you want people with knowledge of other architectures to comment
(otherwise they probably won't bother).

Kind regards,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
