From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Thu, 13 Apr 2017 17:06:03 -0400
Message-ID: <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com>
 <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170413203742.wg6mrnzedw7ew5ky@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/13/2017 04:37 PM, Shaohua Li wrote:
> On Thu, Apr 13, 2017 at 01:50:06PM -0400, Jes Sorensen wrote:
>> Hi Neil,
>>
>> Looking at trying to phase out the ioctl usage, I am trying to introduce a
>> helper for the 'is the array valid' situation.
>>
>> Now looking at places like Incremental.c (around like 557 in my current
>> tree):
>> 	/* 7b/ if yes, */
>> 	/* - if number of OK devices match expected, or -R and there */
>> 	/*             are enough, */
>> 	/*   + add any bitmap file  */
>> 	/*   + start the array (auto-readonly). */
>>
>> 	if (md_get_array_info(mdfd, &ainf) == 0) {
>> 		if (c->export) {
>> 			printf("MD_STARTED=already\n");
>> 		} else if (c->verbose >= 0)
>> 			pr_err("%s attached to %s which is already active.\n",
>> 			       devname, chosen_name);
>> 		rv = 0;
>> 		goto out_unlock;
>> 	}
>>
>> I am wondering if there are any side effects/assumptions about
>> GET_ARRAY_INFO that I am not considering? Basically I am making the
>> assumption that if /sys/block/md<X>/md exists, the array is valid.
>
> what does 'valid' really mean? md<x>/md exists after a md device is allocated,
> the md device might not have any under layer disks bound yet.
>
>> The code in Incremental.c already deals with sysfs higher up in the code, so
>> I guess the question is if the above test is even relevant anymore?
>>
>> Alternative, do we need export a new state in sysfs 'running'?
>
> I'd assume 'running' means the md device has a personality attached. See
> array_state_show(), !running == 'clear' or 'inactive'.

Good point, I guess what I am trying to figure out is what is assumed 
when ioctl(GET_ARRAY_INFO) returns 0 and how do we map it to sysfs?

Jes

