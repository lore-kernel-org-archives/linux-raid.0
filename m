From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] md/raid5: skip wait for MD_CHANGE_DEVS
 acknowledgement in the external case
Date: Tue, 26 Oct 2010 16:22:43 +1100
Message-ID: <20101026162243.263a96ae@notabene>
References: <20101022180311.6563.6666.stgit@localhost6.localdomain6>
	<20101022180354.6563.52476.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101022180354.6563.52476.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 22 Oct 2010 11:03:54 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> mdmon is orchestrating the reshape progress and we rely on it to manage the
> reshape position and metadata updates.
> 
> Reported-by: Adam Kwolek <adam.kwolek@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/raid5.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 69b0a16..9e8ecd5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4243,7 +4243,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
>  		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  		md_wakeup_thread(mddev->thread);
>  		wait_event(mddev->sb_wait, mddev->flags == 0 ||
> -			   kthread_should_stop());
> +			   !mddev->persistent || kthread_should_stop());
>  		spin_lock_irq(&conf->device_lock);
>  		conf->reshape_safe = mddev->reshape_position;
>  		spin_unlock_irq(&conf->device_lock);
> @@ -4344,8 +4344,8 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
>  		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  		md_wakeup_thread(mddev->thread);
>  		wait_event(mddev->sb_wait,
> -			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
> -			   || kthread_should_stop());
> +			   !test_bit(MD_CHANGE_DEVS, &mddev->flags) ||
> +			   !mddev->persistent || kthread_should_stop());
>  		spin_lock_irq(&conf->device_lock);
>  		conf->reshape_safe = mddev->reshape_position;
>  		spin_unlock_irq(&conf->device_lock);


Do we really need this?

If we set MD_CHANGE_DEVS as wake up the thread, the thread will call
md_update_sb which, in the !persistent case, will clear the bit and wakeup
sb_wait.  So we should block on those wait_events anyway...

Am I missing something?

And as ->persistent doesn't change, I would rather have that test outside the
wait_event() to make the meaning more explicit.  So if I have missed
something, I'll make that change.

Thanks,
NeilBrown
