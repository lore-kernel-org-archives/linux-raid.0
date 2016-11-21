From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Mon, 21 Nov 2016 15:43:11 -0800
Message-ID: <20161121234311.6qhwa2g3oa4uhcbi@kernel.org>
References: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147969099621.5434.12384452255155063186.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 21, 2016 at 12:19:43PM +1100, Neil Brown wrote:
> There are 2 problems with using bi_phys_segments as a counter
> 1/ we only use 16bits, which limits bios to 256M
> 2/ it is poor form to reuse a field like this.  It interferes
>    with other changes to bios.
> 
> We need to clean up a few things before we can change the use the
> counter which is now available inside a bio.
> 
> I have only tested this lightly.  More review and testing would be
> appreciated.

So without the accounting, we:
- don't do bio completion trace
- call md_write_start/md_write_end excessively, which involves atomic operation.

Not big problems. But we are actually reusing __bi_remaining, I'm wondering why
we not explicitly reuse it. Eg, adds bio_dec_remaining_return() and uses it
like raid5_dec_bi_active_stripes.

Thanks,
Shaohua
