From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/7] imsm: metadata changes for PPL
Date: Tue, 29 Nov 2016 10:21:52 -0500
Message-ID: <wrfj4m2qia5r.fsf@redhat.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
        <20161124122952.16529-2-artur.paszkiewicz@intel.com>
        <wrfjpolfjibn.fsf@redhat.com>
        <f4ded4a5-abf2-f988-f5d0-7063f5d080d1@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4ded4a5-abf2-f988-f5d0-7063f5d080d1@intel.com> (Artur
        Paszkiewicz's message of "Tue, 29 Nov 2016 11:47:59 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 11/29/2016 12:27 AM, Jes Sorensen wrote:
>> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>>> @@ -189,7 +195,30 @@ struct imsm_dev {
>>>  	__u16 cache_policy;
>>>  	__u8  cng_state;
>>>  	__u8  cng_sub_state;
>>> -#define IMSM_DEV_FILLERS 10
>>> +	__u16 my_vol_raid_dev_num; /* Used in Unique volume Id for this RaidDev */
>>> +
>>> +	/* NVM_EN */
>>> +	__u8 nv_cache_mode;
>>> +	union {
>>> +		__u8 nv_cache_flags;
>>> +		struct {
>>> +		    __u8 dirty:1; /* 1 - cache is dirty, 0 - clean */
>>> +		    __u8 nvc_health:2;
>>> +		    __u8 expansion_bytes:5;
>>> +		} nvCache;
>>> +	};
>> 
>> This sets off alarm bells here - you declare a union of a u8 and a
>> matching bitfield, but do not handle bit endian bitfields. If someone
>> tried to use this on a big endian system this could get messy.
>
> Those fields are not used in the code at all, the only thing added to
> this structure that is used is 'rwh_policy'. The rest is to fill the
> gaps between IMSM format in UEFI/Windows.

Hi Artur,

I did notice the code wasn't actually used, sorry I didn't mention
that. However I would still prefer to see at least a comment in the code
indicating that this would fail on BE systems.

>>> @@ -7565,12 +7594,15 @@ mark_checkpoint:
>>>  
>>>  skip_mark_checkpoint:
>>>  	/* mark dirty / clean */
>>> -	if (dev->vol.dirty != !consistent) {
>>> +	if ((dev->vol.dirty & RAIDVOL_DIRTY) != !consistent) {
>> 
>> This part makes my head spin (to be honest, the original code did
>> too). I had to go write a small snipped of C to figure out what the
>> compiler does with !x given x > 0, since consistent can be 0, 1, and 2
>> here.
>> 
>> Basically for RAIDVOL_CLEAN and consistent = 0, and RAIDVOL_DIRTY and
>> consistent = 1 and 2, this statement triggers. Maybe I am just terrible
>> dense when it comes to reading obfuscated C, but could we change this
>> round to a construct that is a little easier to read?
>
> Yes, I admit it is confusing. Does this look better?
>
> -       if (dev->vol.dirty != !consistent) {
> +       if (((dev->vol.dirty & RAIDVOL_DIRTY) && consistent) ||
> +           (!(dev->vol.dirty & RAIDVOL_DIRTY) && !consistent)) {

This I can read without getting headache, so yes :)

Cheers,
Jes
