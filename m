From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/23] md: rewrite md_setup_drive to avoid ioctls
Date: Thu, 16 Jul 2020 15:38:53 +0200
Message-ID: <20200716133853.GA18326@lst.de>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-10-hch@lst.de> <87365sxrqe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87365sxrqe.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 16, 2020 at 09:50:49AM +1000, NeilBrown wrote:
> I'd be more comfortable if you added something like
> 	if (WARN(bdev->bd_disk->fops != md_fops,
>                  "Opening block device %x resulted in non-md device\"))
>                 return;
> here.  However even without that
> 
> Reviewed-by: NeilBrown <neilb@suse.de>

Ok, I've added that.
