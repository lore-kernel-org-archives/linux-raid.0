From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md/raid0: Fix an error message in raid0_make_request()
Date: Tue, 1 Oct 2019 16:08:54 -0700
Message-ID: <CAPhsuW7zfwX2GPEhXV_X5F7zKi-NvT0vmP-bCc9qYjmFwSJwFg@mail.gmail.com>
References: <20190921060031.GB18726@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190921060031.GB18726@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 20, 2019 at 11:00 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The first argument to WARN() is supposed to be a condition.  The
> original code will just print the mdname() instead of the full warning
> message.
>
> Fixes: c84a1372df92 ("md/raid0: avoid RAID0 data corruption due to layout confusion.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/md/raid0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f61693e59684..3956ea502f97 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -615,7 +615,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>                 tmp_dev = map_sector(mddev, zone, sector, &sector);
>                 break;
>         default:
> -               WARN("md/raid0:%s: Invalid layout\n", mdname(mddev));
> +               WARN(1, "md/raid0:%s: Invalid layout\n", mdname(mddev));
>                 bio_io_error(bio);
>                 return true;

Applied. Thanks for the fix!

Song
