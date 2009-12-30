From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: make recovery started by do_md_run() visible via
 sync_action
Date: Wed, 30 Dec 2009 12:37:14 +1100
Message-ID: <20091230123714.6c1c8571@notabene.brown>
References: <20091222011305.27523.26165.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222011305.27523.26165.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Dec 2009 18:18:36 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> By default md_do_sync() will perform recovery if no other actions are
> specified.  However, action_show() relies on MD_RECOVERY_RECOVER to be
> set otherwise it returns 'idle'.  So, add a missing set
> MD_RECOVERY_RECOVER when starting recovery.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Hi Neil,
> 
> One more to finish off recovery checkpoint support.  Without this mdmon
> never notices that the array was rebuilding and never marks the
> completion.  I did not see any urgency to workaround this in the mdadm
> patchset, but let me know if you think a "kernel version > 2.6.33-rcX"
> check is warranted.

Thanks Dan.
This is "obviously correct" and I have queued it.
However...
I wonder if we want that code in do_md_run at all.
It claims to be there because if we leave the recovery to
md_check_recovery, then it will remove and re-add the spares,
and this will lose the recovery_offset information.

However presumably the same problem applies to recovery_offset
information that we set manually.  Won't the call to
remove_and_add_spares() lose that information too?

I think we need to make sure that remove_and_add_spares
doesn't lose information that we want to keep, and then
remove this code from do_md_run.

So my first question is:  did the current code really work for you?
It looks like it would zero recovery_offset in remove_and_add_spares ??

No, I don't think you want a kernel-version test just for this.

Thanks,
NeilBrown

> 
> Thanks,
> Dan
> 
>  drivers/md/md.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1cc5f2d..fa93de0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4286,6 +4286,7 @@ static int do_md_run(mddev_t * mddev)
>  		if (spares && mddev->pers->sync_request) {
>  			mddev->recovery = 0;
>  			set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>  			mddev->sync_thread = md_register_thread(md_do_sync,
>  								mddev,
>  								"resync");

