From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 1/6] md: Make md resync and reshape threads freezable
Date: Mon, 25 Sep 2017 10:38:04 +0800
Message-ID: <20170925023804.GD6434@ming.t460p>
References: <20170922221405.22091-1-bart.vanassche@wdc.com>
 <20170922221405.22091-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170922221405.22091-2-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On Fri, Sep 22, 2017 at 03:14:00PM -0700, Bart Van Assche wrote:
> Some people use the md driver on laptops and use the suspend and
> resume functionality. Since it is essential that submitting of
> new I/O requests stops before device quiescing starts, make the
> md resync and reshape threads freezable.
> 

Why is this patch part of this patchset? I don't think
MD is special enough wrt. the SCSI quiesce issue.


-- 
Ming
