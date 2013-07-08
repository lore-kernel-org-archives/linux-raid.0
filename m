From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 11/27] DDF: layout_ddf2md: new DDF->md RAID layout conversion
Date: Mon, 08 Jul 2013 23:06:31 +0200
Message-ID: <51DB29D7.5030207@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>	<1372883287-8859-12-git-send-email-mwilck@arcor.de> <20130708164820.3a344e28@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708164820.3a344e28@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/08/2013 08:48 AM, NeilBrown wrote:

>> -static struct num_mapping ddf_level_num[] = {
>> -	{ DDF_RAID0, 0 },
>> -	{ DDF_RAID1, 1 },
>> -	{ DDF_RAID3, LEVEL_UNSUPPORTED },
>> -	{ DDF_RAID4, 4 },
>> -	{ DDF_RAID5, 5 },
>> -	{ DDF_RAID1E, LEVEL_UNSUPPORTED },
>> -	{ DDF_JBOD, LEVEL_UNSUPPORTED },
>> -	{ DDF_CONCAT, LEVEL_LINEAR },
>> -	{ DDF_RAID5E, LEVEL_UNSUPPORTED },
>> -	{ DDF_RAID5EE, LEVEL_UNSUPPORTED },
>> -	{ DDF_RAID6, 6},
>> -	{ MAXINT, MAXINT }
>> -};
> 
> Ooops.  You removed that while there was still a user.
> Code must compile after each patch!
> I've delayed the removal of this structure to the next patch, which removes
> the last user.

Sorry for that. It happened when I tried to cleanup + reorder my patches.

Martin
