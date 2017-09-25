From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 07:04:25 +0800
Message-ID: <20170925230421.GD18137@ming.t460p>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
 <20170925202924.16603-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925202924.16603-2-bart.vanassche@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On Mon, Sep 25, 2017 at 01:29:18PM -0700, Bart Van Assche wrote:
> Some people use the md driver on laptops and use the suspend and
> resume functionality. Since it is essential that submitting of
> new I/O requests stops before device quiescing starts, make the
> md resync and reshape threads freezable.

As I explained, if SCSI quiesce is safe, this patch shouldn't
be needed.

The issue isn't MD specific, and in theory can be triggered
on all devices. And you can see the I/O hang report on BTRFS(RAID)
without MD involved:

	https://marc.info/?l=linux-block&m=150634883816965&w=2

So please remove this patch from the patchset.

--
Ming
