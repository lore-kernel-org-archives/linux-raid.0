From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Mon, 6 Feb 2017 13:41:18 -0800
Message-ID: <20170206214118.i4elvsodwrqy2pns@kernel.org>
References: <147969099621.5434.12384452255155063186.stgit@noble>
 <20170206085624.GA22409@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170206085624.GA22409@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: NeilBrown <neilb@suse.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 06, 2017 at 09:56:24AM +0100, Christoph Hellwig wrote:
> Did anything happen to this series?  Having it would be extremely
> useful for the block layer moving forward.

So I'd prefer allocating extra memory for the counter instead of playing tricky
games. I'll post some patches soon.

Thanks,
Shaohua
