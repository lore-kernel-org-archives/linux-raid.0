From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH v2] md: also hot remove disk from pers when hot removing
Date: Fri, 16 Nov 2012 16:07:34 -0800
Message-ID: <CAA9_cmcViMsVMrxyEcC9yaHPq9Xc-5Dt63fMEJ+X+kZst8O9Fg@mail.gmail.com>
References: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

On Fri, Nov 16, 2012 at 8:04 AM, Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:
> If hot adding a disk not as spare but at the same slot, the disk isn't added
> correctly in the pers and it is possible to cause a kernel panic/oops due to
> the invalid pointer to the old rdev in the pers. So hot remove the disk from
> the personality before removing it from the array.
>
> Tested with raid1.
>
> Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> ---
>  drivers/md/md.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..1fc545b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5852,6 +5852,7 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
>  {
>         char b[BDEVNAME_SIZE];
>         struct md_rdev *rdev;
> +       int err;
>
>         rdev = find_rdev(mddev, dev);
>         if (!rdev)
> @@ -5860,6 +5861,12 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
>         if (rdev->raid_disk >= 0)
>                 goto busy;
>
> +       if (mddev->pers && mddev->pers->hot_remove_disk) {
> +               err = mddev->pers->hot_remove_disk(mddev, rdev);
> +               if (err)
> +                       return err;
> +               sysfs_unlink_rdev(mddev, rdev);
> +       }

Hmm, how are you getting ->raid_disk set to -1 without the personality
being notified?  That seems to be the source of the bug.  Otherwise it
would seem the state_store("remove") path is also susceptible.

--
Dan
