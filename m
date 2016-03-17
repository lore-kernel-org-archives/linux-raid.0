From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] raid1: include bio_end_io_list in nr_queued to prevent
 freeze_array hang
Date: Thu, 17 Mar 2016 16:29:58 -0400
Message-ID: <56EB13C6.8080009@stratus.com>
References: <1456760638-23936-1-git-send-email-nate.dailey@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1456760638-23936-1-git-send-email-nate.dailey@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>, linux-raid@vger.kernel.org, shli@kernel.org
List-Id: linux-raid.ids

On 02/29/2016 10:43 AM, Nate Dailey wrote:
> If raid1d is handling a mix of read and write errors, handle_read_error's
> call to freeze_array can get stuck.
> 
> This can happen because, though the bio_end_io_list is initially drained,
> writes can be added to it via handle_write_finished as the retry_list
> is processed. These writes contribute to nr_pending but are not included
> in nr_queued.
> 
> If a later entry on the retry_list triggers a call to handle_read_error,
> freeze array hangs waiting for nr_pending == nr_queued+extra. The writes
> on the bio_end_io_list aren't included in nr_queued so the condition will
> never be satisfied.
> 
> To prevent the hang, include bio_end_io_list writes in nr_queued.
> 
> There's probably a better way to handle decrementing nr_queued, but this
> seemed like the safest way to avoid breaking surrounding code.
> 
> I'm happy to supply the script I used to repro this hang.
> 
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> ---
>  drivers/md/raid1.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4e3843f..bb5bce0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2274,6 +2274,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>  	if (fail) {
>  		spin_lock_irq(&conf->device_lock);
>  		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
> +		conf->nr_queued++;
>  		spin_unlock_irq(&conf->device_lock);
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
> @@ -2391,8 +2392,10 @@ static void raid1d(struct md_thread *thread)
>  		LIST_HEAD(tmp);
>  		spin_lock_irqsave(&conf->device_lock, flags);
>  		if (!test_bit(MD_CHANGE_PENDING, &mddev->flags)) {
> -			list_add(&tmp, &conf->bio_end_io_list);
> -			list_del_init(&conf->bio_end_io_list);
> +			while (!list_empty(&conf->bio_end_io_list)) {
> +				list_move(conf->bio_end_io_list.prev, &tmp);
> +				conf->nr_queued--;
> +			}
>  		}
>  		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		while (!list_empty(&tmp)) {
> 

Nate, Shaohua,

It looks like bio_end_io_list was added in 55ce74d4bfe1 "md/raid1:
ensure device failure recorded before write request returns", which
dates back a ways:

  % git tag --contains 55ce74d4bfe1b | grep -v 'rc' | sort -V
  v4.3
  v4.4
  v4.5

Should these patches have 'Fixes' tags for stable backporting?

Regards,

-- Joe
