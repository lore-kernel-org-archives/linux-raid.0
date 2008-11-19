From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: fix multipath oops
Date: Thu, 20 Nov 2008 08:57:50 +1100
Message-ID: <18724.35806.320253.868473@notabene.brown>
References: <20081117103203.GL17300@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday November 17
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday November 17, maan@systemlinux.org wrote:
> Hi
> 
> the current for-next kernel oopses on the 00multipath test of the
> mdadm test suite. I'm not sure if the patch below is the best way to
> fix this problem, but it avoids the oops and makes the 00multipath
> test succeed. In the long run it might be preferable to use a wrapper
> for sysfs_notify_dirent() that checks for NULL pointers, or even teach
> sysfs_notify_dirent() to return early if it gets passed a NULL pointer.

Hi Andre,
 Thanks for this.
 I thought I had fixed that already, but maybe I hadn't pushed the
 tree out.  I have now.


 BTW, I have two problems with your patch as it stands.
> @@ -6233,8 +6233,8 @@ void md_check_recovery(mddev_t *mddev)
>  	unlock:
>  		if (!mddev->sync_thread) {
>  			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> -			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
> -					       &mddev->recovery))
> +			if (mddev->sysfs_action && test_and_clear_bit(
> +				MD_RECOVERY_RECOVER, &mddev->recovery))
>  				sysfs_notify_dirent(mddev->sysfs_action);
>  		}

1/ The indenting is not what I like.  Having the arguments to a
function further left than the function name makes is hard to read.
I would prefer

			if (mddev->sysfs_action &&
			    test_and_clear_bit(MD_RECOVERY_RECOVER,
					       &mddev->recovery))
				sysfs_notify_dirent(mddev->sysfs_action);

which is one more line, but worth it.

2/ You have introduced a subtle semantic change.  If ->sys_action is
   NULL, we no longer clear MD_RECOVERY_RECOVER.  I suspect this isn't
   actually an error in practice, but I think it is still the wrong
   way around to do the tests.
   I have
			if (test_and_clear_bit(MD_RECOVERY_RECOVER,
					       &mddev->recovery))
				if (mddev->sysfs_action)
					sysfs_notify_dirent(mddev->sysfs_action);


Thanks,
NeilBrown
