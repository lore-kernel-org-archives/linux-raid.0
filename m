From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH v3 08/14] block: introduce bio_copy_data_partial
Date: Fri, 24 Mar 2017 10:41:29 -0600
Message-ID: <f41b054c-2307-a14a-bff4-3646f876c137@fb.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
 <20170316161235.27110-9-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-9-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On 03/16/2017 10:12 AM, Ming Lei wrote:
> Turns out we can use bio_copy_data in raid1's write behind,
> and we can make alloc_behind_pages() more clean/efficient,
> but we need to partial version of bio_copy_data().
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Reviewed-by: Jens Axboe <axboe@fb.com>

Shaohua, feel free to pull this through the md tree, that will be much
easier.

-- 
Jens Axboe

