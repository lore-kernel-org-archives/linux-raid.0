From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Tue, 18 Apr 2017 12:28:24 -0400
Message-ID: <8a7c2d8a-b64c-3ccb-e3f8-54c23fce0ddc@gmail.com>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
 <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
 <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com>
 <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com>
 <87k26itx2v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k26itx2v.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/17/2017 07:48 PM, NeilBrown wrote:
> On Fri, Apr 14 2017, Jes Sorensen wrote:
>
>> On 04/13/2017 05:06 PM, Jes Sorensen wrote:
>>> On 04/13/2017 04:37 PM, Shaohua Li wrote:
>>>> On Thu, Apr 13, 2017 at 01:50:06PM -0400, Jes Sorensen wrote:
>>>>> Hi Neil,
>>>>>
>>>>> Looking at trying to phase out the ioctl usage, I am trying to
>>>>> introduce a
>>>>> helper for the 'is the array valid' situation.
>>>>>
>>>>> Now looking at places like Incremental.c (around like 557 in my current
>>>>> tree):
>>>>>     /* 7b/ if yes, */
>>>>>     /* - if number of OK devices match expected, or -R and there */
>>>>>     /*             are enough, */
>>>>>     /*   + add any bitmap file  */
>>>>>     /*   + start the array (auto-readonly). */
>>>>>
>>>>>     if (md_get_array_info(mdfd, &ainf) == 0) {
>>>>>         if (c->export) {
>>>>>             printf("MD_STARTED=already\n");
>>>>>         } else if (c->verbose >= 0)
>>>>>             pr_err("%s attached to %s which is already active.\n",
>>>>>                    devname, chosen_name);
>>>>>         rv = 0;
>>>>>         goto out_unlock;
>>>>>     }
>>>>>
>>>>> I am wondering if there are any side effects/assumptions about
>>>>> GET_ARRAY_INFO that I am not considering? Basically I am making the
>>>>> assumption that if /sys/block/md<X>/md exists, the array is valid.
>>>>
>>>> what does 'valid' really mean? md<x>/md exists after a md device is
>>>> allocated,
>>>> the md device might not have any under layer disks bound yet.
>>>>
>>>>> The code in Incremental.c already deals with sysfs higher up in the
>>>>> code, so
>>>>> I guess the question is if the above test is even relevant anymore?
>>>>>
>>>>> Alternative, do we need export a new state in sysfs 'running'?
>>>>
>>>> I'd assume 'running' means the md device has a personality attached. See
>>>> array_state_show(), !running == 'clear' or 'inactive'.
>>>
>>> Good point, I guess what I am trying to figure out is what is assumed
>>> when ioctl(GET_ARRAY_INFO) returns 0 and how do we map it to sysfs?
>>
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

Neil,

That makes a lot of sense - let me look into this. There are other cases 
in the code where the intention isn't 100% clear, so expect me to nag 
you as I work through them :)

Cheers,
Jes

