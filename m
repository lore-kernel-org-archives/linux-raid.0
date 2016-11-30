From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 1/7] imsm: metadata changes for PPL
Date: Wed, 30 Nov 2016 08:34:44 +0100
Message-ID: <6897db1e-01e8-ce8a-cd77-19a54badafdb@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
 <20161124122952.16529-2-artur.paszkiewicz@intel.com>
 <wrfjpolfjibn.fsf@redhat.com>
 <f4ded4a5-abf2-f988-f5d0-7063f5d080d1@intel.com>
 <wrfj4m2qia5r.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj4m2qia5r.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/29/2016 04:21 PM, Jes Sorensen wrote:
> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>> On 11/29/2016 12:27 AM, Jes Sorensen wrote:
>>> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>>>> @@ -189,7 +195,30 @@ struct imsm_dev {
>>>>  	__u16 cache_policy;
>>>>  	__u8  cng_state;
>>>>  	__u8  cng_sub_state;
>>>> -#define IMSM_DEV_FILLERS 10
>>>> +	__u16 my_vol_raid_dev_num; /* Used in Unique volume Id for this RaidDev */
>>>> +
>>>> +	/* NVM_EN */
>>>> +	__u8 nv_cache_mode;
>>>> +	union {
>>>> +		__u8 nv_cache_flags;
>>>> +		struct {
>>>> +		    __u8 dirty:1; /* 1 - cache is dirty, 0 - clean */
>>>> +		    __u8 nvc_health:2;
>>>> +		    __u8 expansion_bytes:5;
>>>> +		} nvCache;
>>>> +	};
>>>
>>> This sets off alarm bells here - you declare a union of a u8 and a
>>> matching bitfield, but do not handle bit endian bitfields. If someone
>>> tried to use this on a big endian system this could get messy.
>>
>> Those fields are not used in the code at all, the only thing added to
>> this structure that is used is 'rwh_policy'. The rest is to fill the
>> gaps between IMSM format in UEFI/Windows.
> 
> Hi Artur,
> 
> I did notice the code wasn't actually used, sorry I didn't mention
> that. However I would still prefer to see at least a comment in the code
> indicating that this would fail on BE systems.

Since I wasn't going to use those fields I had not given this much
thought, but you are right - this is definitely not portable. I think
I'll remove those bitfields in the next version.

Thanks,
Artur
