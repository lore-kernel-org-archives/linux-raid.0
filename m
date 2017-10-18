From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: [PATCH] md: forbid a RAID5 from having both a bitmap and a
 journal.
Date: Tue, 17 Oct 2017 21:50:03 -0400
Message-ID: <3a975c4c-ccb0-7dec-cfba-e1fe22a2e94c@gentoo.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
 <87bmldnjtq.fsf@notabene.neil.brown.name>
 <20171012173019.c2bbfyz3hgudjbhz@kernel.org>
 <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com>
 <87wp3zlj9q.fsf@notabene.neil.brown.name>
 <20171013195122.mi7gr4xxm77odx7t@kernel.org>
 <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com>
 <877evulrpm.fsf@notabene.neil.brown.name>
 <20171016235609.mmo3vbqiekr4li5c@kernel.org>
 <87sheijw2u.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87sheijw2u.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 10/16/2017 23:24, NeilBrown wrote:
> 
> Having both a bitmap and a journal is pointless.
> Attempting to do so can corrupt the bitmap if the journal
> replay happens before the bitmap is initialized.
> Rather than try to avoid this corruption, simply
> refuse to allow arrays with both a bitmap and a journal.
> So:
>  - if raid5_run sees both are present, fail.
>  - if adding a bitmap finds a journal is present, fail
>  - if adding a journal finds a bitmap is present, fail.
> 
> Cc: stable@vger.kernel.org (4.10+)
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
> 
> This patch should replace 8031c3ddc70ab, which should be reverted.
> 
> Thanks,
> NeilBrown
> 
> 
>  drivers/md/bitmap.c | 6 ++++++
>  drivers/md/md.c     | 2 +-
>  drivers/md/raid5.c  | 7 +++++++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index cae57b5be817..f425905c97fa 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1816,6 +1816,12 @@ struct bitmap *bitmap_create(struct mddev *mddev, int slot)
>  
>  	BUG_ON(file && mddev->bitmap_info.offset);
>  
> +	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
> +		pr_notice("md/raid:%s: array with journal cannot have bitmap\n",
> +			  mdname(mddev));
> +		return ERR_PTR(-EBUSY);
> +	}
> +
>  	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
>  	if (!bitmap)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 63ecfb063b76..bf06ff017eda 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6384,7 +6384,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
>  					break;
>  				}
>  			}
> -			if (has_journal) {
> +			if (has_journal || mddev->bitmap) {
>  				export_rdev(rdev);
>  				return -EBUSY;
>  			}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4f40ccd21cbb..e070e5c68801 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7134,6 +7134,13 @@ static int raid5_run(struct mddev *mddev)
>  			min_offset_diff = diff;
>  	}
>  
> +	if ((test_bit(MD_HAS_JOURNAL, &mddev->flags) || journal_dev) &&
> +	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
> +		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
> +			  mdname(mddev));
> +		return -EINVAL;
> +	}
> +
>  	if (mddev->reshape_position != MaxSector) {
>  		/* Check that we can continue the reshape.
>  		 * Difficulties arise if the stripe we would write to
> 

Currently running the above patch, with 8031c3ddc70ab reverted, on both my SGI
Octane and larger SGI Onyx2, both using md/raid5 with PAGE_SIZE=64K, and no new
issues noticed thus far with a few heavy compile runs.  Thanks for looking into
this!

Tested-by: Joshua Kinard <kumba@gentoo.org>
Acked-by: Joshua Kinard <kumba@gentoo.org>

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
