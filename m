From: jes.sorensen@gmail.com
Subject: Re: [PATCH v3] mdadm/r5cache: allow adding journal to array without journal
Date: Tue, 28 Mar 2017 13:52:57 -0400
Message-ID: <wrfjpoh1gufa.fsf@gmail.com>
References: <20170317233111.2452831-1-songliubraving@fb.com>
        <20170317233111.2452831-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170317233111.2452831-2-songliubraving@fb.com> (Song Liu's
        message of "Fri, 17 Mar 2017 16:31:11 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

Song Liu <songliubraving@fb.com> writes:
> Currently, --add-journal can be only used to recreate broken journal
> for arrays with journal since  creation. As the kernel code getting
> more mature, this constraint is no longer necessary.
>
> This patch allows --add-journal to add journal to array without
> journal.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  Manage.c   | 9 ---------
>  mdadm.8.in | 5 ++---
>  2 files changed, 2 insertions(+), 12 deletions(-)
>
> diff --git a/Manage.c b/Manage.c
> index 5c3d2b9..d038b68 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -946,7 +946,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  
>  	/* only add journal to array that supports journaling */
>  	if (dv->disposition == 'j') {
> -		struct mdinfo mdi;
>  		struct mdinfo *mdp;
>  
>  		mdp = sysfs_read(fd, NULL, GET_ARRAY_STATE);
> @@ -960,14 +959,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			pr_err("%s is not readonly, cannot add journal.\n", devname);
>  			return -1;
>  		}
> -
> -		sysfs_free(mdp);
> -

Song,

Sorry for nagging you again on this one, however removing
sysfs_free(mdp) means you are leaking mbp here.

Cheers,
Jes
