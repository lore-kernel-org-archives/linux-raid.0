From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [mdadm PATCH 1/1] Fix a building error
Date: Tue, 19 Sep 2017 12:24:52 +0200
Message-ID: <059748ff-f5b9-bdf5-a4eb-ff1acbaa60c3@molgen.mpg.de>
References: <1505816081-7887-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1505816081-7887-1-git-send-email-xni@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: jsorensen@fb.com, zlliu@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Xiao,


Please find some comments and nits below.

On 09/19/17 12:14, Xiao Ni wrote:
> In s390 platform, it gives a building error:

s/building error/build error/

Maybe: On s390 platform the build fails with the error below.

> Manage.c: In function 'Manage_subdevs':
> Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from incompatible pointer type [-Werror]
>       fstat_is_blkdev(tfd, dv->devname, &rdev);
>       ^
> In file included from Manage.c:25:0:
> mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long unsigned int *'
> 
> It was introduced by 0a6bff09 and add a temp variable to fix this.

Maybe: It is introduced by commit 0a6bff09 (mdadm/util: unify fstat 
checking blkdev into function). So use a temp variable to fix this.

> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   Manage.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index 871d342..fbb07ce 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1497,13 +1497,14 @@ int Manage_subdevs(char *devname, int fd,
>   			 */
>   			rdev = makedev(mj, mn);
>   		} else {
> +			dev_t rdev_tmp;

Can we get a better name?

>   			tfd = dev_open(dv->devname, O_RDONLY);
>   			if (tfd >= 0) {
> -				fstat_is_blkdev(tfd, dv->devname, &rdev);
> +				fstat_is_blkdev(tfd, dv->devname, &rdev_tmp);
>   				close(tfd);
>   			} else {
>   				int open_err = errno;
> -				if (!stat_is_blkdev(dv->devname, &rdev)) {
> +				if (!stat_is_blkdev(dv->devname, &rdev_tmp)) {
>   					if (dv->disposition == 'M')
>   						/* non-fatal. Also improbable */
>   						continue;
> @@ -1523,6 +1524,7 @@ int Manage_subdevs(char *devname, int fd,
>   					goto abort;
>   				}
>   			}
> +			rdev = (unsigned long)rdev_tmp;

Are ou sure that this won’t cause problems on other platforms 
(32-bit/64-bit)?

>   		}
>   		switch(dv->disposition){
>   		default:


Kind regards,

Paul
