From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Retry writing 'inactive' state during stopping array
Date: Fri, 18 Mar 2011 12:43:15 +1100
Message-ID: <20110318124315.14ac9813@notabene.brown>
References: <20110317163457.5322.18237.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110317163457.5322.18237.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 17 Mar 2011 17:34:57 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Issue observed:
> Sporadicaly stopping arrays using "mdadm -Ss" command does not succeded.
> Cause:
> Writting "inactive" to the array state not succeded- array is busy
> (accessed by udev, blkid etc.)
> Resolution:
> If writing 'inactive' fails, wait and retry again (because it is possibly
> a transient failure)
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>

Thanks.  Applied,
though with a small change so that it will print an error message even if the
error isn't EBUSY.

Thanks,
NeilBrown


> ---
>  Manage.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index ed3112e..a6531f3 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -224,7 +224,9 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
>  				close(fd);
>  			fprintf(stderr,
>  				Name ": Cannot get exclusive access to %s:"
> -				" possibly it is still in use.\n",
> +				"Perhaps a running "
> +				"process, mounted filesystem "
> +				"or active volume group?\n",
>  				devname);
>  			return 1;
>  		}
> @@ -234,12 +236,18 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
>  		    is_subarray(mdi->text_version)) {
>  			/* This is mdmon managed. */
>  			close(fd);
> -			if (sysfs_set_str(mdi, NULL,
> -					  "array_state", "inactive") < 0) {
> -				if (quiet == 0)
> -					fprintf(stderr, Name
> -						": failed to stop array %s: %s\n",
> -						devname, strerror(errno));
> +
> +			count = 25;
> +			while (count && sysfs_set_str(mdi, NULL,
> +				  "array_state", "inactive") < 0
> +				  && errno == EBUSY) {
> +				usleep(200000);
> +				count--;
> +			}
> +			if (!count && !quiet) {
> +				fprintf(stderr, Name
> +					": failed to stop array %s: %s\n",
> +					devname, strerror(errno));
>  				return 1;
>  			}
>  
> @@ -297,6 +305,7 @@ int Manage_runstop(char *devname, int fd, int runstop, int quiet)
>  			usleep(200000);
>  			count --;
>  		}
> +
>  		if (fd >= 0 && err) {
>  			if (quiet == 0) {
>  				fprintf(stderr, Name

