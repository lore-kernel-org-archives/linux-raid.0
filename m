From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Mon, 27 Mar 2017 18:10:08 -0400
Message-ID: <wrfjk27aid6n.fsf@gmail.com>
References: <1489987229-22631-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489987229-22631-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Mon, 20 Mar 2017 13:20:29 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org, Harald Hoyer <harald@redhat.com>
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> it would be stuck at the beginning of reshape progress
> when grows array from raid1 to raid5, correct the name
> of mdadm-grow-continue@.service in continue_via_systemd.
>
> reproduce steps:
> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Grow.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 455c5f9..10c02a1 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2808,13 +2808,11 @@ static int continue_via_systemd(char *devnm)
>  		 */
>  		close(2);
>  		open("/dev/null", O_WRONLY);
> -		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@%s.service",
> -			 devnm);
> +		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@.service");

My memory is rusty here, isn't systemctl interpreting the device name in
mdadm-grow-continue@<device>.service as an argument?

>  		status = execl("/usr/bin/systemctl", "systemctl",
>  			       "start",
>  			       pathbuf, NULL);
> -		status = execl("/bin/systemctl", "systemctl", "start",
> -			       pathbuf, NULL);
> +		pr_err("/usr/bin/systemctl %s got failure\n", pathbuf);
>  		exit(1);

This assumes systemctl is location in /usr/bin only - you removed the
fallback case for it being location in /bin.

In addition, instead of saying 'got failure' lets do something with the
errno value so the user gets a more descriptive error message.

Cheers,
Jes
