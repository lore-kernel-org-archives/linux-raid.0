From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 4 of 4] DM RAID:  Add support for MD's RAID10 "far" and "offset" algorithms
Date: Mon, 7 Jan 2013 14:46:57 -0600
Message-ID: <98BBD0AF-BD94-4954-B322-08DFE78589EE@redhat.com>
References: <1355769688.15326.26.camel@f16> <20130107170554.3764bb45@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130107170554.3764bb45@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Jan 7, 2013, at 12:05 AM, NeilBrown wrote:

> On Mon, 17 Dec 2012 12:41:28 -0600 Jonathan Brassow <jbrassow@redhat.com>
> wrote:
> 
> 
>> --- linux-upstream.orig/drivers/md/dm-raid.c
>> +++ linux-upstream/drivers/md/dm-raid.c
>> @@ -91,15 +91,44 @@ static struct raid_type {
>> 	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTINUE}
>> };
>> 
>> +static char *raid10_md_layout_to_format(int layout)
>> +{
>> +	/*
>> +	 * Bit 16 and 17 stand for "offset" and "dev_stride"
>> +	 * Refer to MD's raid10.c for details
>> +	 */
> 
> I don't think "bit 17" is "dev_stride" any more..  "use_far_sets" ??

yes, s/dev_stride/use_far_sets/.

Thanks for catching that.   I think there was a change made to dm-raid.c recently (an arg was removed from the mapping function) that causes this patch to not apply cleanly.  I correct the above and resend a fresh patch for this.

 brassow

