From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 1/1] md: fix hot add for non-persistent superblock arrays
Date: Tue, 24 May 2005 15:01:08 +1000
Message-ID: <17042.46356.7754.626869@cse.unsw.edu.au>
References: <20050513144946.4066.patches@notabene>
	<E1DWS99-00014N-En@notabene.cse.unsw.edu.au>
	<428D32D0.1030104@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Thursday May 19
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 19, paul.clements@steeleye.com wrote:
> Neil,
> 
> hot add is not working for non-persistent superblock arrays (md is 
> trying, and failing, to read a superblock from the new disk)...
> 
> attached patch fixes it...

Yep, that looks good, thanks.

NeilBrown

> 
> Thanks,
> Paul
> 
> Signed-Off-By: Paul Clements <paul.clements@steeleye.com>
> 
>  md.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletion(-)
> diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.12-rc1-mm2-PRISTINE/drivers/md/md.c linux-2.6.12-rc1-mm2/drivers/md/md.c
> --- linux-2.6.12-rc1-mm2-PRISTINE/drivers/md/md.c	Fri Mar 25 14:33:36 2005
> +++ linux-2.6.12-rc1-mm2/drivers/md/md.c	Thu May 19 16:29:44 2005
> @@ -2218,7 +2218,8 @@ static int add_new_disk(mddev_t * mddev,
>  			       mdname(mddev));
>  			return -EINVAL;
>  		}
> -		rdev = md_import_device(dev, mddev->major_version,
> +		rdev = md_import_device(dev, mddev->persistent ?
> +					mddev->major_version : -1,
>  					mddev->minor_version);
>  		if (IS_ERR(rdev)) {
>  			printk(KERN_WARNING 
