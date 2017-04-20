From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Thu, 20 Apr 2017 12:05:54 -0400
Message-ID: <59ca76c6-1f1f-4d9c-4eb9-d468131e0d55@gmail.com>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
 <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
 <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com>
 <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com>
 <87k26itx2v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k26itx2v.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/17/2017 07:48 PM, NeilBrown wrote:
> On Fri, Apr 14 2017, Jes Sorensen wrote:
>> Looking some more at this, it may be simpler than I thought. How about
>> this approach (only compile tested):
>>
>> int md_array_active(int fd)
>> {
>> 	struct mdinfo *sra;
>> 	struct mdu_array_info_s array;
>> 	int ret;
>>
>> 	sra = sysfs_read(fd, NULL, GET_VERSION | GET_DISKS);
>> 	if (sra) {
>> 		if (!sra->array.raid_disks &&
>> 		    !(sra->array.major_version == -1 &&
>> 		      sra->array.minor_version == -2))
>> 			ret = -ENODEV;
>> 		else
>> 			ret = 0;
>>
>> 		free(sra);
>> 	} else {
>> 		ret = ioctl(fd, GET_ARRAY_INFO, &array);
>> 	}
>>
>> 	return !ret;
>> }
>>
>> Note 'major = -1 && minor = -2' is sysfs_read's way of saying 'external'.
>>
>> This pretty much mimics what the kernel does in the ioctl handler for
>> GET_ARRAY_INFO:
>>
>> 	case GET_ARRAY_INFO:
>> 		if (!mddev->raid_disks && !mddev->external)
>> 			err = -ENODEV;
>> 		else
>> 			err = get_array_info(mddev, argp);
>> 		goto out;
>>
>> What do you think?
>
> I think that it accurately mimics what the current code does.
> I'm not sure that is what we really want.
> For testing in Incremental.c if an array is "active" we really
> should be testing more than "raid_disks != 0".
> We should be testing, as Shaohua suggested, if
> array_state != 'clear' or 'inactive'.
> You cannot get that info through the ioctl interface, so I suppose
> I decided the current test was 'close enough'.
> If we are going to stop supported kernels that don't have (e.g.)
> array_state, then we should really fo the right thing and test
> array_state.

I think I got it right this time and pushed it into git. It made things 
a lot prettier too IMHO :)

In the process I also changed the behavior of 
sysfs_read(GET_ARRAY_STATE) as I really didn't like how it was copying 
in the string rather than parsing it.

I am traveling at the moment and don't yet have my new raid test box 
setup back at the office, so my testing is limited. If I broke something 
badly, feel free to throw rotten tomatoes at me.

Cheers,
Jes


