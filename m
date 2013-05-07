From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH - RFC] MD: Sync thread not properly shutdown after mddev_suspend()
Date: Tue, 7 May 2013 08:25:40 -0500
Message-ID: <9B569D3F-CAC3-408B-ACDF-EE19BE2E82A7@redhat.com>
References: <1367525963.23442.4.camel@f16> <20130506161245.548b47a1@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506161245.548b47a1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On May 6, 2013, at 1:12 AM, NeilBrown wrote:

> On Thu, 02 May 2013 15:19:23 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> MD: Sync thread not properly shutdown after mddev_suspend()
>> 
>> After performing an 'md_stop_writes' followed by an 'mddev_suspend',
>> it is possible to have 'MD_RECOVERY_RUNNING' set in mddev->recovery.
>> It doesn't happen often, but when it does, the recovery thread does
>> not restart properly after a resume.
>> 
>> The problem seems to come from 'md_stop_writes'.  This function is a
>> wrapper around '__md_stop_writes' - surrounding it with mddev_[un]lock
>> calls.  While '__md_stop_writes' properly cleans up the sync thread,
>> the subsequent 'mddev_unlock' call will wake up the personality thread,
>> which in turn calls 'md_check_recovery' - a function that sets
>> mddev->recovery flags and potentially launches the sync thread.
>> Effectively, this can undo what has just been done.
>> 
>> When 'mddev_suspend' is called, it sets the mddev->suspended variable.
>> This variable causes 'md_check_recovery' to simply return if set.  Thus,
>> it is better to reap the sync thread in mddev_suspend, because it cannot
>> be respawned until mddev_resume is called.
>> 
>> There are probably several ways to solve this problem.  The simplest way
>> was to add 'md_reap_sync_thread' to mddev_suspend.  It may be
>> better fixed in 'md_stop_writes' though.  We could also combine
>> 'md_stop_writes' and 'mddev_suspend' by calling '__md_stop_writes' from
>> within 'mddev_suspend' after mddev->suspended has been set.
>> 
>> Thoughts?
> 
> Thanks for the thorough analysis.
> 
> Your patch looks like it would work,  but it involves calling
> md_reap_sync_thread() twice which is a little ugly.
> 
> How about this:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4c74424..3e2acfa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5277,8 +5277,8 @@ static void md_clean(struct mddev *mddev)
> 
> static void __md_stop_writes(struct mddev *mddev)
> {
> +	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> 	if (mddev->sync_thread) {
> -		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> 		md_reap_sync_thread(mddev);
> 	}
> 
> 
> Callers of md_stop_writes() already need to be prepared for
> MD_RECOVERY_FROZEN to get set, and raid_resume() clears it for dm-raid.c, so
> it should be safe.
> An md_check_recovery won't start anything while MD_RECOVERY_FROZEN is set.
> So this should *really* stop writes going to the devices.
> 
> Make sense?

Yeah, that looks good, but give me a day or two to test it.   It seems that with the addition of this patch, the previous patch we added to revive failed devices on raid_resume sometimes fails.  I can't reproduce it by hand, but some of my automated tests will hit it ~ 1 out of 100 times.  So let me investigate a bit more.

 brassow


