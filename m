From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm 2.4: fix write mostly for add and re-add
Date: Mon, 3 Apr 2006 10:12:17 +1000
Message-ID: <17456.26721.577745.219133@cse.unsw.edu.au>
References: <442DED37.9030504@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday March 31
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday March 31, paul.clements@steeleye.com wrote:
> The following patch makes it possible to tag a device as write-mostly on 
> --add and --re-add with a non-persistent superblock array. Previously, 
> this was not working.

Thanks Paul.  It'll be in the next release.

NeilBrown

> 
> Thanks,
> Paul
> 
> Signed-Off-By: Paul Clements <paul.clements@steeleye.com>
> 
>  Manage.c |    2 ++
>  1 files changed, 2 insertions(+)
> --- mdadm-2.4/Manage.c	2006-03-28 01:11:11.000000000 -0500
> +++ mdadm-2.4-fix-write-mostly/Manage.c	2006-03-31 21:56:37.000000000 -0500
> @@ -341,6 +341,8 @@ int Manage_subdevs(char *devname, int fd
>  						break;
>  					}
>  			}
> +			if (dv->writemostly)
> +				disc.state |= (1 << MD_DISK_WRITEMOSTLY);
>  			if (ioctl(fd,ADD_NEW_DISK, &disc)) {
>  				fprintf(stderr, Name ": add new device failed for %s as %d: %s\n",
>  					dv->devname, j, strerror(errno));
