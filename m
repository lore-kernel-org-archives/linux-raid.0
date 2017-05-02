From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 1/2] util: unify fstat operations into function
Date: Tue, 2 May 2017 09:50:15 -0400
Message-ID: <5af21d7d-b7a8-71f2-1598-e39dafd61649@gmail.com>
References: <20170502032646.20220-1-zlliu@suse.com>
 <20170502032646.20220-2-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502032646.20220-2-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/01/2017 11:26 PM, Zhilong Liu wrote:
> declare new function to integrate repeated fstat operation,
> the fd and devname are necessary arguments, the dev_t *rdev
> is optional. according to parse the pointer of dev_t *rdev,
> if valid, assigned device number to rdev, if NULL, ignores.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Assemble.c    | 17 +++++------------
>  Build.c       |  5 +++--
>  Create.c      | 23 ++++++++++-------------
>  Grow.c        | 10 ++++------
>  Incremental.c | 33 ++++++++++++---------------------
>  Manage.c      |  2 +-
>  bitmap.c      | 10 +---------
>  mdadm.h       |  1 +
>  super-intel.c | 13 +++----------
>  util.c        | 17 +++++++++++++++++
>  10 files changed, 57 insertions(+), 74 deletions(-)
>
[snip]
> diff --git a/util.c b/util.c
> index 21a63c9..6294fff 100644
> --- a/util.c
> +++ b/util.c
> @@ -706,6 +706,23 @@ int check_raid(int fd, char *name)
>  	return 1;
>  }
>
> +int fstat_md_is_blkdev(int fd, char *devname, dev_t *rdev)
> +{
> +	struct stat stb;
> +
> +	if (fstat(fd, &stb) != 0) {
> +		pr_err("fstat failed for %s: %s\n", devname, strerror(errno));
> +		return 1;
> +	}
> +	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
> +		pr_err("%s is not a block device.\n", devname);
> +		return 1;
> +	}
> +	if (rdev)
> +		*rdev = stb.st_rdev;
> +	return 0;
> +}
> +
>  int ask(char *mesg)
>  {
>  	char *add = "";
>

Hi Zhilong,

I like this approach better, however, I believe the return logic in the 
function is wrong. When the function is named fstat_md_is_blkdev() it 
should return 'true/1' when the device is a blk device, and 'false/0' 
when it is not.

I also think it should either be named md_fstat_is_blkdev() or 
fstat_is_blkdev() but that is a minor detail.

Cheers,
Jes

