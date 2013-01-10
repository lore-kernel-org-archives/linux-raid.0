From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] DM-RAID: Fix RAID10's check for sufficient redundancy
Date: Wed, 09 Jan 2013 20:02:32 -0600
Message-ID: <1357783352.9103.7.camel@f16>
References: <1357783259.9103.5.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357783259.9103.5.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: linux-raid.ids


On Wed, 2013-01-09 at 20:00 -0600, Jonathan Brassow wrote:
> DM RAID:  Fix RAID10's check for sufficient redundancy
> 
> Before attempting to activate a RAID array, it is checked for sufficient
> redundancy.  That is, we make sure that there are not too many failed
> devices - or devices specified for rebuild - to undermine our ability to
> activate the array.  The current code performs this check twice - once to
> ensure there were not too many devices specified for rebuild by the user
> ('validate_rebuild_devices') and again after possibly experiencing a failure
> to read the superblock ('analyse_superblocks').  Neither of these checks are
> sufficient.  The first check is done properly but with insufficient
> information about the possible failure state of the devices to make a good
> determination if the array can be activated.  The second check is simply
> done wrong in the case of RAID10 because it doesn't account for the
> independence of the stripes (i.e. mirror sets).  The solution is to use the
> properly written check ('validate_rebuild_devices'), but perform the check
> after the superblocks have been read and we know which devices have failed.
> This gives us one check instead of two and performs it in a location where
> it can be done right.
> 
> Only RAID10 was affected and it was affected in the following ways:
> - the code did not properly catch the condition where a user specified
>   a device for rebuild that already had a failed device in the same mirror
>   set.  (This condition would, however, be caught at a deeper level in MD.)
> - the code triggers a false positive and denies activation when devices in
>   independent mirror sets have failed - counting the failures as though they
>   were all in the same set.
> 
> The most likely place this error was introduced (or this patch should have
> been included) is in commit 4ec1e369 - first introduced in v3.7-rc1.
> 
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Neil,

This patch should apply cleanly on top of recent changes, but will not
apply cleanly on an older kernel (like 3.7) due to version # changes and
introduction of the new 'far' and 'offset' RAID10 algorithms.  If you
think this fix should be pushed back into 3.7 rather than just applying
on the latest code, I will make a patch for 3.7 - although I'm not
certain how I'd handle the version number conflict.

Thanks,
 brassow


