From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: lots of "md: export_rdev(sde)" printed after create IMSM RAID10 with missing
Date: Wed, 14 Sep 2016 17:05:33 -0400
Message-ID: <wrfjy42u2nvm.fsf@redhat.com>
References: <338941973.7699634.1473230038475.JavaMail.zimbra@redhat.com>
        <1648084319.7702644.1473230621059.JavaMail.zimbra@redhat.com>
        <20160908225607.GA66921@kernel.org>
        <7910bc85-f9c4-1ea3-76a6-40b819738537@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7910bc85-f9c4-1ea3-76a6-40b819738537@intel.com> (Artur
        Paszkiewicz's message of "Fri, 9 Sep 2016 14:56:12 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Shaohua Li <shli@kernel.org>, Yi Zhang <yizhan@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 09/09/2016 12:56 AM, Shaohua Li wrote:
>> On Wed, Sep 07, 2016 at 02:43:41AM -0400, Yi Zhang wrote:
>>> Hello
>>>
>>> I tried create one IMSM RAID10 with missing, found lots of "md:
>>> export_rdev(sde)" printed, anyone could help check it?
>>>
>>> Steps I used:
>>> mdadm -CR /dev/md0 /dev/sd[b-f] -n5 -e imsm
>>> mdadm -CR /dev/md/Volume0 -l10 -n4 /dev/sd[b-d] missing
>>>
>>> Version:
>>> 4.8.0-rc5
>>> mdadm - v3.4-84-gbd1fd72 - 25th August 2016
>> 
>> can't reproduce with old mdadm but can with upstream mdadm. Looks mdadm is
>> keeping write the new_dev sysfs entry.
>> 
>> Jes, any idea?
>> 
>> Thanks,
>> Shaohua 

[snip]

> Can you check if this fix works for you? If it does I'll send a proper
> patch for this.
>
> Thanks,
> Artur

Artur,

You were too fast :) Did you intend to post a patch with a commit
message?

Cheers,
Jes

>
> diff --git a/super-intel.c b/super-intel.c
> index 92817e9..ffa71f6 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7789,6 +7789,9 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
>  			IMSM_T_STATE_DEGRADED)
>  		return NULL;
>  
> +	if (get_imsm_map(dev, MAP_0)->map_state == IMSM_T_STATE_UNINITIALIZED)
> +		return NULL;
> +
>  	/*
>  	 * If there are any failed disks check state of the other volume.
>  	 * Block rebuild if the another one is failed until failed disks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
