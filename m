From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: Compare apples to apples (or sectors to
 sectors)
Date: Tue, 16 Feb 2016 14:06:19 -0800
Message-ID: <20160216220619.GA5907@kernel.org>
References: <1455659064-15940-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455659064-15940-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 16, 2016 at 04:44:24PM -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> 'max_discard_sectors' is in sectors, while 'stripe' is in bytes.
> 
> This fixes the problem where DISCARD would get disabled on some larger
> RAID5 configurations (6 or more drives in my testing), while it worked
> as expected with smaller configurations.
> 
> Fixes: 620125f2bf8 ("MD: raid5 trim support")
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Applied, thanks!
