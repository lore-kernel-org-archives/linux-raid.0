From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [BUG] NULL pointer in raid1_make_request passed to bio_trim when adding md as bcache caching dev
Date: Mon, 28 Mar 2016 14:38:53 -0400
Message-ID: <x49mvpi5txe.fsf@segfault.boston.devel.redhat.com>
References: <56F4058B.1030309@roesner-online.de>
	<alpine.LRH.2.11.1603250126110.13440@mail.ewheeler.net>
	<alpine.LRH.2.11.1603250416030.13440@mail.ewheeler.net>
	<56F54712.6090202@roesner-online.de>
	<alpine.LRH.2.11.1603251954220.13440@mail.ewheeler.net>
	<CACVXFVO7ARehcQHvBuRoVHZhc0BgA5kKxaPQTqMT7Y=4Ca6urw@mail.gmail.com>
	<56F6BCD8.70504@roesner-online.de> <20160328181059.GA83819@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160328181059.GA83819@kernel.org> (Shaohua Li's message of
	"Mon, 28 Mar 2016 11:10:59 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Sebastian Roesner <sroesner-kernelorg@roesner-online.de>, Ming Lei <ming.lei@canonical.com>, Eric Wheeler <bcache@lists.ewheeler.net>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Ming Lin <mlin@kernel.org>, Vlad-Cosmin Miu <miuvlad@gmail.com>, rjones@redhat.com, Kent Overstreet <kent.overstreet@gmail.com>, axboe@fb.com
List-Id: linux-raid.ids

Shaohua Li <shli@kernel.org> writes:

> On Sat, Mar 26, 2016 at 05:46:16PM +0100, Sebastian Roesner wrote:
>> Hello Ming, Eric,
>> 
>> Am 26.03.2016 um 16:40 schrieb Ming Lei:
>> > From the trace, looks the bio returned from bio_clone_mddev() is NULL,
>> >and maybe the source bio is buggy, something like the attached patch
>> >might be helpful, could you apply the attached debug patch, reproduce
>> >and post the log?
>> 
>> I was able to reproduce it on a non-productive system, but only after
>> copying the bcache superblocks/partition starts from the original system,
>> with new created ones it worked fine.
>> 
>> Full trace and check_bio output can be found here:
>> 
>> http://pastebin.com/ngvGGHBZ
>
> 320 bvecs exceeds what bio-clone_set can handle. Could you please try
> below patch?

OK, so bvec_alloc won't allow us to allocate more than BIO_MAX_PAGES.

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
>     This fixes commit 30e2bc08b2bb7c069.

Wrong commit.  You meant this one: d2be537c3ba (block: bump
BLK_DEF_MAX_SECTORS to 2560).

>     We probably should make the bvec_slabs hold bigger bvecs if bigger
>     bio size is required.

This change is okay with me.  So long as it fixes the issue, it should
be marked for stable, too.  Thanks for adding the comment, by the way!

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


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
