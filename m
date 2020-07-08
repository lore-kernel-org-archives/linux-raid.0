From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH 1/6] md: switch to ->check_events for media change
 notifications
Date: Wed, 8 Jul 2020 15:17:31 +0200
Message-ID: <09cd4827-52ae-0e7c-c3d3-e9a6cd27ff2b@cloud.ionos.com>
References: <20200708122546.214579-1-hch@lst.de>
 <20200708122546.214579-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200708122546.214579-2-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 7/8/20 2:25 PM, Christoph Hellwig wrote:
> -static int md_media_changed(struct gendisk *disk)
> -{
> -	struct mddev *mddev = disk->private_data;
> -
> -	return mddev->changed;
> -}

Maybe we can remove "changed" from struct mddev since no one reads it
after the change.

Thanks,
Guoqing
