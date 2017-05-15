From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 08/17] uuid: hoist uuid_is_null() helper from libnvdimm
Date: Mon, 15 May 2017 10:48:21 -0700
Message-ID: <CAPcyv4hzosqta=KcAHs08MAMrzgEt0CbAHTZMZ9d+jh3ymeWFA@mail.gmail.com>
References: <20170515154308.26739-1-hch@lst.de> <20170515154308.26739-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170515154308.26739-9-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 15, 2017 at 8:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hoist the libnvdimm helper as an inline helper to linux/uuid.h
> using an auxiliary const variable uuid_null in lib/uuid.c.
>
> [hch: also add the guid variant.  Both do the same but I'd like
> to keep casts to a minimum]
>
> The common helper uses the new abstract type uuid_t * instead of
> u8 *.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> [hch: added guid_is_null]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
