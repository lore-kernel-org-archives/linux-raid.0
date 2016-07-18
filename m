From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] Remove: container should wait for an array to release a drive
Date: Mon, 18 Jul 2016 09:37:38 -0400
Message-ID: <22412.56226.478064.375583@quad.stoffel.home>
References: <1468843890-30425-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1468843890-30425-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com, aleksey.obitotskiy@intel.com, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

>>>>> "Tomasz" == Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:

Tomasz> A 'faulty' drive is being removed from a container after it
Tomasz> has been released by an array, however there is a race
Tomasz> there. The drive is released asynchronously by a monitor but
Tomasz> sometimes it doesn't happen before container checks it. It
Tomasz> results in a container refusing to remove a drive as it still
Tomasz> seems to be a part of some array.

Tomasz> It seems 'ping_monitor' could be a solution here to assure
Tomasz> monitor has had a chance to process the events, however it
Tomasz> doesn't resolve the problem - sometimes an array has to
Tomasz> request a release of the drive few times (as the array is
Tomasz> busy) and single 'ping_monitor' call is not sufficient. As
Tomasz> there is no way to query monitor progress, it forces us to
Tomasz> retry a check several times before an error is returned.

Tomasz> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Tomasz> ---
Tomasz>  Manage.c | 38 +++++++++++++++++++++++++-------------
Tomasz>  1 file changed, 25 insertions(+), 13 deletions(-)

Tomasz> diff --git a/Manage.c b/Manage.c
Tomasz> index e2e88b8..7f8eb88 100644
Tomasz> --- a/Manage.c
Tomasz> +++ b/Manage.c
Tomasz> @@ -1125,19 +1125,31 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
Tomasz>  		 */
Tomasz>  		if (rdev == 0)
Tomasz>  			ret = -1;
Tomasz> -		else
Tomasz> -			ret = sysfs_unique_holder(devnm, rdev);
Tomasz> -		if (ret == 0) {
Tomasz> -			pr_err("%s is not a member, cannot remove.\n",
Tomasz> -			       dv->devname);
Tomasz> -			close(lfd);
Tomasz> -			return -1;
Tomasz> -		}
Tomasz> -		if (ret >= 2) {
Tomasz> -			pr_err("%s is still in use, cannot remove.\n",
Tomasz> -			       dv->devname);
Tomasz> -			close(lfd);
Tomasz> -			return -1;
Tomasz> +		else {
Tomasz> +			/* The drive has already been set to 'faulty', however monitor might
Tomasz> +			 * not have had time to process it and the drive might still have
Tomasz> +			 * an entry in the 'holders' directory. Try a few times to avoid
Tomasz> +			 * a false error */
Tomasz> +			int count = 20;
Tomasz> +			do {
Tomasz> +				ret = sysfs_unique_holder(devnm, rdev);
Tomasz> +				if (ret < 2)
Tomasz> +					break;
Tomasz> +				usleep(100000);

Really, you're sleeping 10 seconds without telling the user?  That
seems to be a bit obnoxious.  Logging something here would be good.

