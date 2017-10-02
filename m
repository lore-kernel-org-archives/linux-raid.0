From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Mon, 2 Oct 2017 15:26:38 +0200
Message-ID: <20171002132638.GA7129@lst.de>
References: <20170925202924.16603-1-bart.vanassche@wdc.com> <20170925202924.16603-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925202924.16603-2-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

Independent of whether this should be required to make scsi quience
safe or not making the dm thread freeze aware is the right thing
to do, and this patch looks correct to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
