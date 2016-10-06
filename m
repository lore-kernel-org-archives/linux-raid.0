From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 49/54] md/raid10: Replace printk() calls by the usage of
 higher level interfaces
Date: Thu, 06 Oct 2016 10:39:06 -0700
Message-ID: <1475775546.1914.15.camel@perches.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
         <f9f16d1c-c50d-d4be-a6ba-2cb7081eb9b5@users.sourceforge.net>
         <1475771616.1914.9.camel@perches.com>
         <321cc4aa-679a-a2fe-be0b-96285b19e489@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <321cc4aa-679a-a2fe-be0b-96285b19e489@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On Thu, 2016-10-06 at 19:20 +0200, SF Markus Elfring wrote:
> How should a multiline log message be achieved as it was constructed
> in the function "raid10_error" (for example)?
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/md/raid10.c?id=c802e87fbe2d4dd58982d01b3c39bc5a781223aa#n1589

As two individual calls to pr_alert
