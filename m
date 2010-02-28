From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 41/66] drivers/md/linear.h: Checkpatch cleanup
Date: Sun, 28 Feb 2010 16:41:01 +1100
Message-ID: <20100228164101.67f464c1@notabene.brown>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	<1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1267289508-31031-42-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, Sandeep K Sinha <sandeepksinha@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 27 Feb 2010 17:51:22 +0100
Andrea Gelmini <andrea.gelmini@gelma.net> wrote:

> drivers/md/linear.h:12: ERROR: open brace '{' following struct go on the same line

Thanks, but no thanks.
This just doesn't need cleaning up.

NeilBrown

> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  drivers/md/linear.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/linear.h b/drivers/md/linear.h
> index 0ce29b6..3860fd8 100644
> --- a/drivers/md/linear.h
> +++ b/drivers/md/linear.h
> @@ -8,8 +8,7 @@ struct dev_info {
>  
>  typedef struct dev_info dev_info_t;
>  
> -struct linear_private_data
> -{
> +struct linear_private_data {
>  	sector_t		array_sectors;
>  	dev_info_t		disks[0];
>  	struct rcu_head		rcu;

