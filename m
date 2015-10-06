From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/6] Check write journal in incremental
Date: Tue, 6 Oct 2015 13:17:20 -0700
Message-ID: <CAPcyv4iYxLm1uoHM1Rrz7jyecrf+8Luby8CjmQwdK0Pvs6Ya+w@mail.gmail.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
	<1440804426-1461372-6-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-6-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Aug 28, 2015 at 4:27 PM, Song Liu <songliubraving@fb.com> wrote:
> If journal device is missing, do not start the array, and shows:
>
> ./mdadm -I /dev/sdf
> mdadm: journal device is missing, not safe to start yet.
>
> The array will be started when the journal device is attached with -I
>
> ./mdadm -I /dev/sdb1
> mdadm: /dev/sdb1 attached to /dev/md/0_0, which has been started.
>
> To force start without journal device:
>
> ./mdadm -I /dev/sdf --run
> mdadm: Trying to run with missing journal device
> mdadm: /dev/sdf attached to /dev/md/0_0, which has been started.
>
> Signed-off-by: Shaohua Li <shli@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Incremental.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/Incremental.c b/Incremental.c
> index 304cc6d..74905e3 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -35,7 +35,7 @@
>
>  static int count_active(struct supertype *st, struct mdinfo *sra,
>                         int mdfd, char **availp,
> -                       struct mdinfo *info);
> +                       struct mdinfo *info, int *journal_device_missing);
>  static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
>                         int number, __u64 events, int verbose,
>                         char *array_name);
> @@ -104,6 +104,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>         struct map_ent target_array;
>         int have_target;
>         char *devname = devlist->devname;
> +       int journal_device_missing = 0;
>
>         struct createinfo *ci = conf_get_create_info();
>
> @@ -518,7 +519,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>         sysfs_free(sra);
>         sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
>                                     GET_OFFSET | GET_SIZE));
> -       active_disks = count_active(st, sra, mdfd, &avail, &info);
> +       active_disks = count_active(st, sra, mdfd, &avail, &info, &journal_device_missing);
>         if (enough(info.array.level, info.array.raid_disks,
>                    info.array.layout, info.array.state & 1,
>                    avail) == 0) {
> @@ -548,10 +549,12 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>         }
>
>         map_unlock(&map);
> -       if (c->runstop > 0 || active_disks >= info.array.working_disks) {
> +       if (c->runstop > 0 || (!journal_device_missing && active_disks >= info.array.working_disks)) {

A minor comment, and I'd defer to Neil's opinion, but I think this is
asking for mdu_array_info_t to grow a "journal_disks" attribute.
