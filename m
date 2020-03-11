From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] block: refactor duplicated macros
Date: Tue, 10 Mar 2020 22:42:17 -0400
Message-ID: <yq1k13rr4s6.fsf@oracle.com>
References: <20200311002254.121365-1-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20200311002254.121365-1-mcroce@redhat.com> (Matteo Croce's
        message of "Wed, 11 Mar 2020 01:22:54 +0100")
Sender: linux-mmc-owner@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ulf Hansson <ulf.hansson@linaro.org>, Anna Schumaker <anna.schumaker@netapp.com>, Dan Williams <dan.j.williams@intel.com>, Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids


Matteo,

> The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are
> defined several times in different flavours across the whole tree.
> Define them just once in a common header.
>
> While at it, replace replace "PAGE_SHIFT - 9" with
> "PAGE_SECTORS_SHIFT" too and rename SECTOR_MASK to PAGE_SECTORS_MASK.

Looks OK to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
