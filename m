From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [mdadm PATCH 1/1] Fix some type comparison problems
Date: Mon, 08 Feb 2016 10:51:04 -0500
Message-ID: <wrfjtwljgpzr.fsf@redhat.com>
References: <1454721521-7118-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454721521-7118-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Sat, 6 Feb 2016 09:18:41 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, deepa.kernel@gmail.com, maxin.john@gmail.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> As 26714713cd2bad9e0bf7f4669f6cc4659ceaab6c said, 32 bit signed 
> timestamps will overflow in the year 2038. It already changed the
> utime and ctime in struct mdu_array_info_s from int to unsigned 
> int. So we need to change the values that compared with them to
> unsigned int too.
>
> Signed-off-by : Xiao Ni <xni@redhat.com>
> ---
>  Monitor.c | 2 +-
>  util.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes

> diff --git a/Monitor.c b/Monitor.c
> index f19c2e5..6df80f9 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -33,7 +33,7 @@
>  struct state {
>  	char *devname;
>  	char devnm[32];	/* to sync with mdstat info */
> -	long utime;
> +	unsigned int utime;
>  	int err;
>  	char *spare_group;
>  	int active, working, failed, spare, raid;
> diff --git a/util.c b/util.c
> index 970d484..6e7d3fb 100644
> --- a/util.c
> +++ b/util.c
> @@ -1267,7 +1267,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
>  	 */
>  	struct superswitch  *ss;
>  	struct supertype *st;
> -	time_t besttime = 0;
> +	unsigned int besttime = 0;
>  	int bestsuper = -1;
>  	int i;
