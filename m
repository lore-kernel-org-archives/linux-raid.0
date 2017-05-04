From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v1 2/2] mdadm/util: unify stat checking blkdev into
 function
Date: Thu, 4 May 2017 11:33:54 -0400
Message-ID: <2234ff90-2ed8-217f-bdcd-ef08008f9d2c@gmail.com>
References: <20170504121622.4014-1-zlliu@suse.com>
 <20170504121622.4014-3-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170504121622.4014-3-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/2017 08:16 AM, Zhilong Liu wrote:
> declare function stat_is_blkdev() to integrate repeated stat
> checking blkdev operations, it returns 'true/1' when it is a
> block device, and returns 'false/0' when it isn't.
> The devname is necessary parameter, *rdev is optional, parse
> the pointer of dev_t *rdev, if valid, assigned device number
> to dev_t *rdev, if NULL, ignores.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    |  7 ++-----
>  Build.c       | 25 ++++---------------------
>  Incremental.c | 21 ++++-----------------
>  Manage.c      | 11 +----------
>  Monitor.c     | 16 ++++------------
>  mdadm.h       |  1 +
>  super-ddf.c   | 10 ++++------
>  super-intel.c | 10 ++++------
>  util.c        | 17 +++++++++++++++++
>  9 files changed, 41 insertions(+), 77 deletions(-)


> diff --git a/Manage.c b/Manage.c
> index af55266..2c82326 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1510,24 +1510,16 @@ int Manage_subdevs(char *devname, int fd,
>  			 */
>  			rdev = makedev(mj, mn);
>  		} else {
> -			struct stat stb;
>  			tfd = dev_open(dv->devname, O_RDONLY);
>  			if (tfd >= 0) {
>  				fstat_is_blkdev(tfd, dv->devname, &rdev);
>  				close(tfd);
>  			} else {
>  				int open_err = errno;
> -				if (stat(dv->devname, &stb) != 0) {
> -					pr_err("Cannot find %s: %s\n",
> -					       dv->devname, strerror(errno));
> -					goto abort;
> -				}
> -				if ((stb.st_mode & S_IFMT) != S_IFBLK) {
> +				if (!stat_is_blkdev(dv->devname, &rdev))
>  					if (dv->disposition == 'M')
>  						/* non-fatal. Also improbable */
>  						continue;
> -					pr_err("%s is not a block device.\n",
> -					       dv->devname);
>  					goto abort;
>  				}
>  				if (dv->disposition == 'r')

cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -O2 
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" 
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" 
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM 
-DVERSION=\"4.0-108-g688a44b\" -DVERS_DATE="\"2017-05-04\"" 
-DUSE_PTHREADS -DBINDIR=\"/sbin\"  -c -o Manage.o Manage.c
Manage.c: In function ‘Manage_subdevs’:
Manage.c:1519:5: error: this ‘if’ clause does not guard... 
[-Werror=misleading-indentation]
      if (!stat_is_blkdev(dv->devname, &rdev))
      ^~

Please at least test build your patch before posting it.

Jes

