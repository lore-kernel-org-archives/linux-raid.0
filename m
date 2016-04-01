From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when
 adding md as bcache caching dev
Date: Fri, 1 Apr 2016 18:14:53 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1604011812170.5949@mail.ewheeler.net>
References: <56F4058B.1030309@roesner-online.de> <alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net> <alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net> <56F54712.6090202@roesner-online.de> <alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
 <CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com> <56F6BCD8.70504@roesner-online.de> <20160328181059.GA83819@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20160328181059.GA83819@kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>
Cc: Shaohua Li <shli@kernel.org>, Ming Lei <ming.lei@canonical.com>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>, jmoyer@redhat.com, axboe@fb.com
List-Id: linux-raid.ids

On Mon, 28 Mar 2016, Shaohua Li wrote:
> On Sat, Mar 26, 2016 at 05:46:16PM +0100, Sebastian Roesner wrote:
> > Hello Ming, Eric,
> > 
> > Am 26.03.2016 um 16:40 schrieb Ming Lei:
> > I was able to reproduce it on a non-productive system, but only after
> > copying the bcache superblocks/partition starts from the original system,
> > with new created ones it worked fine.

Hey Sebastian,

Have you had a chance to test the patch below from Shaohua Li?

--
Eric Wheeler


> > 
> > Full trace and check_bio output can be found here:
> > 
> > http://pastebin.com/ngvGGHBZ
> 
> 320 bvecs exceeds what bio-clone_set can handle. Could you please try below patch?
> 
> commit 92761dad7ff6e1bf25de247e0064dd398e797599
> Author: Shaohua Li <shli@fb.com>
> Date:   Mon Mar 28 10:54:35 2016 -0700
> 
>     block: don't make BLK_DEF_MAX_SECTORS too big
>     
>     bio_alloc_bioset() allocates bvecs from bvec_slabs which can only allocate
>     maximum 256 bvec (eg, 1M for 4k pages). We can't bump BLK_DEF_MAX_SECTORS to
>     exceed this value otherwise bio_alloc_bioset will fail.
>     
>     This fixes commit 30e2bc08b2bb7c069. We probably should make the bvec_slabs
>     hold bigger bvecs if bigger bio size is required.
>     
>     Signed-off-by: Shaohua Li <shli@fb.com>
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7e5d7e0..da64325 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1153,7 +1153,11 @@ extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
>  enum blk_default_limits {
>  	BLK_MAX_SEGMENTS	= 128,
>  	BLK_SAFE_MAX_SECTORS	= 255,
> -	BLK_DEF_MAX_SECTORS	= 2560,
> +	/*
> +	 * if you change this, please also change bvec_alloc and BIO_MAX_PAGES.
> +	 * Otherwise bio_alloc_bioset will break.
> +	 */
> +	BLK_DEF_MAX_SECTORS	= BIO_MAX_SECTORS,
>  	BLK_MAX_SEGMENT_SIZE	= 65536,
>  	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
>  };
> 

	
