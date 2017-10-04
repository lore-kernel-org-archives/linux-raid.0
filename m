From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v5 2/8] md: Neither resync nor reshape while the system
 is frozen
Date: Wed, 4 Oct 2017 19:30:22 +0800
Message-ID: <20171004113021.GC17729@ming.t460p>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
 <20171002225218.18548-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171002225218.18548-3-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On Mon, Oct 02, 2017 at 03:52:12PM -0700, Bart Van Assche wrote:
> Some people use the md driver on laptops and use the suspend and
> resume functionality. Since it is essential that submitting of
> new I/O requests stops before a hibernation image is created,
> interrupt the md resync and reshape actions if the system is
> being frozen. Note: the resync and reshape will restart after
> the system is resumed and a message similar to the following
> will appear in the system log:
> 
> md: md0: data-check interrupted.
> 
> Additionally, only allow resync or reshape activity to be
> started after system freezing is over.

Last time, I asked which issue is fixed by this patch, but
never get answered, so again, what is issue fixed by
this patch?

Given the following patches for making SCSI quiesce safe
is required in either PM suspend/resume or other path
of transport_spi revalidate. So once theses patches are
in, I don't see any I/O hang in suspend/resume given
the SCSI quiesce issue is very specific one, and not
see this issue on other kind of device.

Thanks,
Ming
