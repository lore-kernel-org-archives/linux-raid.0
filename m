From: Christoph Hellwig <hch@lst.de>
Subject: don't require a struct block_device to submit a bio
Date: Wed, 23 Aug 2017 19:10:26 +0200
Message-ID: <20170823171032.30529-1-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

Hi Jens,

this series removes the need to have a struct block_device ready to
submit a bio.   We basically don't use it anywhere in the block stack
anyway - we always go for the gendisk or request_queue.  The only
exception is partition remapping for which we'll now need an additional
partition index.  This helps with cases where we submit I/O from a
character device (nvme or lightnvm passthrough) or a different block
device (upcoming nvme multipath support).
