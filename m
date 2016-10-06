From: Joe Perches <coupons@perches.com>
Subject: Re: [PATCH 49/54] md/raid10: Replace printk() calls by the usage of
 higher level interfaces
Date: Thu, 06 Oct 2016 09:33:36 -0700
Message-ID: <1475771616.1914.9.camel@perches.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
         <f9f16d1c-c50d-d4be-a6ba-2cb7081eb9b5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f9f16d1c-c50d-d4be-a6ba-2cb7081eb9b5@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On Thu, 2016-10-06 at 11:49 +0200, SF Markus Elfring wrote:
[]
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5119846..0f2cb20 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -18,6 +18,8 @@
>   * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#define MY_LOG_PREFIX KBUILD_MODNAME ": "
> +#define pr_fmt(fmt) MY_LOG_PREFIX fmt

Please just use

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

like the more than thousand other uses in the kernel.
