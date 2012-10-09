From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Fix race between removing raid1 device and I/O error handling on underlying device
Date: Tue, 09 Oct 2012 08:39:11 +0200
Message-ID: <wrfj1uh8kv3k.fsf@redhat.com>
References: <1349704634-18904-1-git-send-email-Jes.Sorensen@redhat.com>
	<20121009115822.50e5f305@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121009115822.50e5f305@notabene.brown> (NeilBrown's message of
	"Tue, 9 Oct 2012 11:58:22 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, pyu@redhat.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 611b5f7..ffdad74 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2005,7 +2005,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
>>  		if (!success) {
>>  			/* Cannot read from anywhere - mark it bad */
>>  			struct md_rdev *rdev = conf->mirrors[read_disk].rdev;
>> -			if (!rdev_set_badblocks(rdev, sect, s, 0))
>> +			if (rdev && !rdev_set_badblocks(rdev, sect, s, 0))
>>  				md_error(mddev, rdev);
>>  			break;
>>  		}
>
>
> Hi Jes,
> this was already reported on linux-raid and I said I didn't like that fix
> because I think it is wrong that the rdev could be removed while we are
> trying to fix a read error on it.
> So I've applied this following which is in -next.
>
> NeilBrown

Hi Neil,

Whoops, I have to admit I am somewhat backlogged on linux-raid.
Apologies for the noise.

I wasn't wildly happy with the solution myself, but I figured it was the
simplest solution. 

Your patch looks good to me, so I'll go with that.

Cheers,
Jes
