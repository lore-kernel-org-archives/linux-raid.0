From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Explicitly turn off bad block support
Date: Mon, 22 Apr 2013 11:29:48 -0500
Message-ID: <1EBA319B-13B9-4E75-A62F-C3F180A08C07@redhat.com>
References: <1366378224.14427.1.camel@f16> <20130422105228.3948c69f@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130422105228.3948c69f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Apr 21, 2013, at 7:52 PM, NeilBrown wrote:

> On Fri, 19 Apr 2013 08:30:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
>> DM RAID:  Explicitly turn off bad block support
>> 
>> DM RAID does not currently use the bad block tracking available in
>> MD.  'badblocks.shift' must be set to '-1' in order to explicitly
>> tell MD not to perform bad block related functions, like
>> narrow_write_error().
>> 
>> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>> 
>> Index: linux-upstream/drivers/md/dm-raid.c
>> ===================================================================
>> --- linux-upstream.orig/drivers/md/dm-raid.c
>> +++ linux-upstream/drivers/md/dm-raid.c
>> @@ -170,8 +170,10 @@ static struct raid_set *context_alloc(st
>> 	rs->md.delta_disks = 0;
>> 	rs->md.recovery_cp = 0;
>> 
>> -	for (i = 0; i < raid_devs; i++)
>> +	for (i = 0; i < raid_devs; i++) {
>> 		md_rdev_init(&rs->dev[i].rdev);
>> +		rs->dev[i].rdev.badblocks.shift = -1; /* No bad block support */
>> +	}
>> 
>> 	/*
>> 	 * Remaining items to be initialized by further RAID params:
>> 
> 
> Thanks, but I don't think this is the right fix.
> md_rdev_init really should set shift to -1, because we can only support
> badblocks if the metadata explicitly supports it.
> 
> What do you think of this instead?

I like it much better.  It means that the proper initialization is done centrally, rather than expecting every super block type to know enough to turn off things they may not know about.  I considered this, but went along with the idea that it was the responsibility of the individual superblock handlers.

thanks!
 brassow



