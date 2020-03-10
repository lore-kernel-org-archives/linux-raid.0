From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH v2] block: refactor duplicated macros
Date: Wed, 11 Mar 2020 00:10:04 +0100
Message-ID: <d473061b-688f-f4a6-c0e8-61c22b8a2b10@cloud.ionos.com>
References: <20200310223516.102758-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200310223516.102758-1-mcroce@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>, Dan Williams <dan.j.williams@intel.com>, Song Liu <song@kernel.org>
List-Id: linux-raid.ids



On 3/10/20 11:35 PM, Matteo Croce wrote:
> +++ b/drivers/md/raid1.c
> @@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
>   	int vcnt;
>   
>   	/* Fix variable parts of all bios */
> -	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
> +	vcnt = (r1_bio->sectors + PAGE_SECTORS - 1) >> (PAGE_SHIFT - 9);

Maybe replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT" too.

Thanks,
Guoqing
