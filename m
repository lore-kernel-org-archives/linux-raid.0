From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] md: enable io polling
Date: Thu, 30 Jan 2020 22:36:53 -0800
Message-ID: <20200131063653.GD6267@infradead.org>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-3-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200126044138.5066-3-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

> +	rdev_for_each(rdev, mddev) {
> +		if (rdev->raid_disk >= 0 && !test_bit(Faulty, &rdev->flags)) {
> +			rv = blk_poll(bdev_get_queue(rdev->bdev), cookie, false);

This adds a > 80 char line.  But if you just use a continue to skip
the not allicable ones you even clean up the code while avoiding that.
