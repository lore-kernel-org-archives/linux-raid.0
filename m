From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] md: forbid a RAID5 from having both a bitmap and a journal.
Date: Tue, 17 Oct 2017 16:41:16 -0400
Message-ID: <23014.27372.306872.143938@quad.stoffel.home>
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
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87sheijw2u.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> Having both a bitmap and a journal is pointless.
NeilBrown> Attempting to do so can corrupt the bitmap if the journal
NeilBrown> replay happens before the bitmap is initialized.
NeilBrown> Rather than try to avoid this corruption, simply
NeilBrown> refuse to allow arrays with both a bitmap and a journal.
NeilBrown> So:
NeilBrown>  - if raid5_run sees both are present, fail.

So what happens if there's someone out there with an array setup with
both already?  Should the journal or the bitmap be removed at this
time?  

NeilBrown>  - if adding a bitmap finds a journal is present, fail
NeilBrown>  - if adding a journal finds a bitmap is present, fail.

NeilBrown> Cc: stable@vger.kernel.org (4.10+)
NeilBrown> Signed-off-by: NeilBrown <neilb@suse.com>
NeilBrown> ---

NeilBrown> This patch should replace 8031c3ddc70ab, which should be reverted.

NeilBrown> Thanks,
NeilBrown> NeilBrown


NeilBrown>  drivers/md/bitmap.c | 6 ++++++
NeilBrown>  drivers/md/md.c     | 2 +-
NeilBrown>  drivers/md/raid5.c  | 7 +++++++
NeilBrown>  3 files changed, 14 insertions(+), 1 deletion(-)

NeilBrown> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
NeilBrown> index cae57b5be817..f425905c97fa 100644
NeilBrown> --- a/drivers/md/bitmap.c
NeilBrown> +++ b/drivers/md/bitmap.c
NeilBrown> @@ -1816,6 +1816,12 @@ struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 
NeilBrown>  	BUG_ON(file && mddev->bitmap_info.offset);
 
NeilBrown> +	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
NeilBrown> +		pr_notice("md/raid:%s: array with journal cannot have bitmap\n",
NeilBrown> +			  mdname(mddev));
NeilBrown> +		return ERR_PTR(-EBUSY);
NeilBrown> +	}
NeilBrown> +
NeilBrown>  	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
NeilBrown>  	if (!bitmap)
NeilBrown>  		return ERR_PTR(-ENOMEM);
NeilBrown> diff --git a/drivers/md/md.c b/drivers/md/md.c
NeilBrown> index 63ecfb063b76..bf06ff017eda 100644
NeilBrown> --- a/drivers/md/md.c
NeilBrown> +++ b/drivers/md/md.c
NeilBrown> @@ -6384,7 +6384,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
NeilBrown>  					break;
NeilBrown>  				}
NeilBrown>  			}
NeilBrown> -			if (has_journal) {
NeilBrown> +			if (has_journal || mddev->bitmap) {
NeilBrown>  				export_rdev(rdev);
NeilBrown>  				return -EBUSY;
NeilBrown>  			}
NeilBrown> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
NeilBrown> index 4f40ccd21cbb..e070e5c68801 100644
NeilBrown> --- a/drivers/md/raid5.c
NeilBrown> +++ b/drivers/md/raid5.c
NeilBrown> @@ -7134,6 +7134,13 @@ static int raid5_run(struct mddev *mddev)
NeilBrown>  			min_offset_diff = diff;
NeilBrown>  	}
 
NeilBrown> +	if ((test_bit(MD_HAS_JOURNAL, &mddev->flags) || journal_dev) &&
NeilBrown> +	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
NeilBrown> +		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
NeilBrown> +			  mdname(mddev));
NeilBrown> +		return -EINVAL;
NeilBrown> +	}
NeilBrown> +
NeilBrown>  	if (mddev->reshape_position != MaxSector) {
NeilBrown>  		/* Check that we can continue the reshape.
NeilBrown>  		 * Difficulties arise if the stripe we would write to
NeilBrown> -- 
NeilBrown> 2.14.0.rc0.dirty

NeilBrown> [DELETED ATTACHMENT signature.asc, application/pgp-signature]
