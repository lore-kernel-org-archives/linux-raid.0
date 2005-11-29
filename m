From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH md 014 of 18] Attempt to auto-correct read errors in raid1.
Date: Tue, 29 Nov 2005 11:38:51 -0500
Message-ID: <438C841B.7000405@steeleye.com>
References: <20051128102824.14498.patches@notabene> <1051127234048.14901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051127234048.14901@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Glad to see this patch is making its way to mainline. I have a couple of 
questions on the patch, though...

NeilBrown wrote:

> +	if (uptodate || conf->working_disks <= 1) {

Is it valid to mask a read error just because we have only 1 working disk?



> +				do {
> +					rdev = conf->mirrors[d].rdev;
> +					if (rdev &&
> +					    test_bit(In_sync, &rdev->flags) &&
> +					    sync_page_io(rdev->bdev,
> +							 sect + rdev->data_offset,
> +							 s<<9,
> +							 conf->tmppage, READ))
> +						success = 1;
> +					else {
> +						d++;
> +						if (d == conf->raid_disks)
> +							d = 0;
> +					}
> +				} while (!success && d != r1_bio->read_disk);
> +
> +				if (success) {
> +					/* write it back and re-read */
> +					while (d != r1_bio->read_disk) {

Here, it looks like if we retry the read on the same disk that just gave 
the read error, then we will not do any re-writes? I assume that is 
intentional? I guess it's a judgment call whether the sector is really 
bad at that point.

> +						if (d==0)
> +							d = conf->raid_disks;
> +						d--;
> +						rdev = conf->mirrors[d].rdev;
> +						if (rdev &&
> +						    test_bit(In_sync, &rdev->flags)) {
> +							if (sync_page_io(rdev->bdev,
> +									 sect + rdev->data_offset,
> +									 s<<9, conf->tmppage, WRITE) == 0 ||
> +							    sync_page_io(rdev->bdev,
> +									 sect + rdev->data_offset,
> +									 s<<9, conf->tmppage, READ) == 0) {
> +								/* Well, this device is dead */
> +								md_error(mddev, rdev);

Here, we might have gotten garbage back from the sync_page_io(..., 
READ), if it failed. So don't we have to quit the re-write loop at this 
point? Otherwise, aren't we potentially writing bad data over other 
disks? Granted, this particular case might never actually happen in the 
real world.


Thanks,
Paul
