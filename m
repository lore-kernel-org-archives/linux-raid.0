From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] block: refactor duplicated macros
Date: Wed, 11 Mar 2020 06:58:39 -0600
Message-ID: <7e03d359-f199-29d8-a75f-20c4b7ff3031@kernel.dk>
References: <20200311002254.121365-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200311002254.121365-1-mcroce@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>, Dan Williams <dan.j.williams@intel.com>, Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

On 3/10/20 6:22 PM, Matteo Croce wrote:
> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> several times in different flavours across the whole tree.
> Define them just once in a common header.
> 
> While at it, replace replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT" too
> and rename SECTOR_MASK to PAGE_SECTORS_MASK.

Applied, thanks.

-- 
Jens Axboe
