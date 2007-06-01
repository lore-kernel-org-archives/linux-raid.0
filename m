From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 check/repair read error recovery in 2.6.20
Date: Fri, 1 Jun 2007 10:18:52 +1000
Message-ID: <18015.26092.718913.90023@notabene.brown>
References: <6834.1180063677@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Accetta on Thursday May 24
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 24, maccetta@laurelnetworks.com wrote:
> I believe I've come across a bug in the disk read error recovery logic
> for raid1 check/repair operations in 2.6.20.  The raid1.c file looks
> identical in 2.6.21 so the problem should still exist there as well.

Yes, you have found a bug, thanks.

> 
> I tried the following patch to raid1.c which short-ciruits the data
> comparison in the read error case but otherwise does the rest of the
> sbio prep for the mirror with the error.  It seems to have eliminated
> the ATA warning at least.  Is it a correct thing to do?

Yes, that is the correct thing to do.  I'll get this (with maybe some
small cosmetic changes) upstream.

Thanks again,
NeilBrown

> 
> @@ -1235,17 +1242,20 @@
>  			}
>  		r1_bio->read_disk = primary;
>  		for (i=0; i<mddev->raid_disks; i++)
> -			if (r1_bio->bios[i]->bi_end_io == end_sync_read &&
> -			    test_bit(BIO_UPTODATE, &r1_bio->bios[i]->bi_flags)) {
> +			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
>  				int j;
>  				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
>  				struct bio *pbio = r1_bio->bios[primary];
>  				struct bio *sbio = r1_bio->bios[i];
> -				for (j = vcnt; j-- ; )
> -					if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
> -						   page_address(sbio->bi_io_vec[j].bv_page),
> -						   PAGE_SIZE))
> -						break;
> +				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
> +					for (j = vcnt; j-- ; )
> +						if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
> +							   page_address(sbio->bi_io_vec[j].bv_page),
> +							   PAGE_SIZE))
> +							break;
> +				} else {
> +					j = 0;
> +				}
>  				if (j >= 0)
>  					mddev->resync_mismatches += r1_bio->sectors;
>  				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
