From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH] md: Add support for data integrity to MD
Date: Sat, 20 Sep 2008 17:26:40 -0700
Message-ID: <e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com>
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 20, 2008 at 5:18 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> If all subdevices support the same protection format the MD device is
> flagged as capable.
>
> Depends on d7533ad0e132f92e75c1b2eb7c26387b25a583c1 being reverted.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/md/md.c |   32 +++++++++++++++++++++++++++++++-
>  1 files changed, 31 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 45521da..b038581 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3497,7 +3497,7 @@ static int do_md_run(mddev_t * mddev)
>        int err;
>        int chunk_size;
>        struct list_head *tmp;
> -       mdk_rdev_t *rdev;
> +       mdk_rdev_t *rdev, *prev;
>        struct gendisk *disk;
>        struct mdk_personality *pers;
>        char b[BDEVNAME_SIZE];
> @@ -3759,6 +3759,35 @@ static int do_md_run(mddev_t * mddev)
>        sysfs_notify(&mddev->kobj, NULL, "sync_action");
>        sysfs_notify(&mddev->kobj, NULL, "degraded");
>        kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +
> +       /* Data integrity passthrough not supported on RAID 4, 5 and 6 */
> +       if (pers->level >= 4 && pers->level <= 6)
> +               return 0;

Do you have a reference to the issues in supporting this?

Thanks,
Dan
