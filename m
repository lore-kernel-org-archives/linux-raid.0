From: Jens Axboe <axboe@kernel.dk>
Subject: Re: don't require a struct block_device to submit a bio
Date: Wed, 23 Aug 2017 12:50:12 -0600
Message-ID: <5e4171a6-1cbe-5753-e35d-6c9b89a9c9e5@kernel.dk>
References: <20170823171032.30529-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

On 08/23/2017 11:10 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series removes the need to have a struct block_device ready to
> submit a bio.   We basically don't use it anywhere in the block stack
> anyway - we always go for the gendisk or request_queue.  The only
> exception is partition remapping for which we'll now need an additional
> partition index.  This helps with cases where we submit I/O from a
> character device (nvme or lightnvm passthrough) or a different block
> device (upcoming nvme multipath support).

Added for 4.14, thanks.

-- 
Jens Axboe

