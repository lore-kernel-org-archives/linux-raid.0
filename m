From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: protecting sys_name overflow
Date: Wed, 15 Jun 2016 14:40:03 -0400
Message-ID: <wrfjeg7yuwho.fsf@redhat.com>
References: <57612976.6030801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57612976.6030801@redhat.com> (Nikhil Kshirsagar's message of
	"Wed, 15 Jun 2016 15:39:58 +0530")
Sender: linux-raid-owner@vger.kernel.org
To: Nikhil Kshirsagar <nkshirsa@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nikhil Kshirsagar <nkshirsa@redhat.com> writes:
> Hello,
>
> Devices with names larger than 31 bytes will overflow the sys_name array.
>
> This patch enables mdadm to fail and log a message if a long device name
> is going to cause a buffer overflow.
>
> Signed-off-by: Nikhil Kshirsagar <nkshirsa@redhat.com>
>
> From 705aec84c6abf5b09c4202aec7cade9824ca7f12 Mon Sep 17 00:00:00 2001
> From: root <root@nkshirsa.pnq.csb>
> Date: Wed, 15 Jun 2016 15:23:12 +0530
> Subject: [PATCH] Protecting overflow of sys_name. If a long device name is
>  going to cause a buffer overflow, we fail with a log message.
>
> ---
>  sysfs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/sysfs.c b/sysfs.c
> index 8379ca8..68b8b95 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -283,6 +283,15 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
>  			}
>  
>  		}
> +                /*  strlen computes length of string *not* including the terminating null character. */
> +
> +                if(strlen(de->d_name) >= sizeof(dev->sys_name))
> +                {
> +                  pr_err("Device name %s larger than currently supported by mdadm\n",de->d_name);
> +                  free(dev);
> +                  goto abort;
> +
> +                }

Nikhil,

Please respect the coding style of mdadm. Code indents at 8 characters
using a tab, not whitespace, and brackets should be placed correctly.

Just like with kernel code.

Jes
