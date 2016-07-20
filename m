From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] Remove: container should wait for an array to release a drive
Date: Wed, 20 Jul 2016 13:35:18 -0400
Message-ID: <wrfjfur4nrft.fsf@redhat.com>
References: <1469001665-13648-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1469001665-13648-1-git-send-email-tomasz.majchrzak@intel.com>
	(Tomasz Majchrzak's message of "Wed, 20 Jul 2016 10:01:05 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> A 'faulty' drive is being removed from a container after it has been
> released by an array, however there is a race there. The drive is
> released asynchronously by a monitor but sometimes it doesn't happen
> before container checks it. It results in a container refusing to remove
> a drive as it still seems to be a part of some array.
>
> It seems 'ping_monitor' could be a solution here to assure monitor has
> had a chance to process the events, however it doesn't resolve the
> problem - sometimes an array has to request a release of the drive few
> times (as the array is busy) and single 'ping_monitor' call is not
> sufficient. As there is no way to query monitor progress, it forces us
> to retry a check several times before an error is returned.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  Manage.c | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/Manage.c b/Manage.c
> index e2e88b8..7f8eb88 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1125,19 +1125,31 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
>  		 */
>  		if (rdev == 0)
>  			ret = -1;
> -		else
> -			ret = sysfs_unique_holder(devnm, rdev);
> -		if (ret == 0) {
> -			pr_err("%s is not a member, cannot remove.\n",
> -			       dv->devname);
> -			close(lfd);
> -			return -1;
> -		}
> -		if (ret >= 2) {
> -			pr_err("%s is still in use, cannot remove.\n",
> -			       dv->devname);
> -			close(lfd);
> -			return -1;
> +		else {
> +			/* The drive has already been set to 'faulty', however monitor might
> +			 * not have had time to process it and the drive might still have
> +			 * an entry in the 'holders' directory. Try a few times to avoid
> +			 * a false error */

Sorry for nagging again, but code is 80 characters wide, and comments
should not go beyond the 80 character limit - just like in the
kernel. The preferred format is (with applicable indentation):

/*
 * Blah blah blah blah blah
 * .... more blah blah blah
 */

Thanks,
Jes
