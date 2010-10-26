From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] md/raid5: initialize ->recovery_offset when growing
 raid_disks
Date: Tue, 26 Oct 2010 01:43:10 -0700
Message-ID: <4CC6949E.8050605@intel.com>
References: <20101022180311.6563.6666.stgit@localhost6.localdomain6>	<20101022180359.6563.11717.stgit@localhost6.localdomain6>	<20101026163524.09b9e812@notabene>	<4CC682A9.2080507@intel.com> <20101026185424.6d13f43b@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101026185424.6d13f43b@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On 10/26/2010 12:54 AM, Neil Brown wrote:
> On Tue, 26 Oct 2010 00:26:33 -0700
> Dan Williams<dan.j.williams@intel.com>  wrote:
>
>> On 10/25/2010 10:35 PM, Neil Brown wrote:
>>> On Fri, 22 Oct 2010 11:03:59 -0700
>>> Dan Williams<dan.j.williams@intel.com>   wrote:
>>>
>>>> We mark the disk in-sync, and also need to init ->recovery_offset lest
>>>> we confuse older versions of mdadm that don't consider this case at
>>>> assembly (i.e. that when growing we assume the disk is insync).
>>>>
>>>> mdadm: /dev/md0 assembled from 3 drives and  1 rebuilding - not enough to start the array.
>>>>
>>>> Cc:<stable@kernel.org>
>>>> Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>>>> ---
>>>>    drivers/md/raid5.c |    1 +
>>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 9e8ecd5..f8a27d4 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -5580,6 +5580,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>>>>    			if (raid5_add_disk(mddev, rdev) == 0) {
>>>>    				char nm[20];
>>>>    				if (rdev->raid_disk>= conf->previous_raid_disks) {
>>>> +					rdev->recovery_offset = MaxSector;
>>>>    					set_bit(In_sync,&rdev->flags);
>>>>    					added_devices++;
>>>>    				} else
>>>
>>>
>>> Sorry, but I'm not getting this one....
>>>
>>> rdev->recovery_offset is only ever used when In_sync is clear.  So it makes
>>> no sense to give it a value when In_sync is set.
>>>
>>> Maybe there are some places where we clear In_sync that need to have
>>> recovery_offset set to zero, but it isn't obvious to me that that would
>>> explain your symptom.
>>>
>>> Can you give a bit more detail of the problem you are seeing please?
>>
>> mdadm -A an array growing raid disks by more than max_degraded.
>>
>> Here is the related mdadm fix, but I figured it was worhtwhile to also
>> address this in the kernel for the corner case of new kernel + old mdadm.
>>
>>> commit 156a33719d956fe90cbb1625b13beb52a0d6fd87
>>> Author: Dan Williams<dan.j.williams@intel.com>
>>> Date:   Mon Jul 12 12:03:13 2010 -0700
>>>
>>>      Assemble: fix assembly in the delta_disks>  max_degraded case
>>>
>>>      Incremental assembly works on such an array because the kernel sees the
>>>      disk as in-sync and that the array is reshaping.  Teach Assemble() the
>>>      same assumptions.
>>>
>>>      This is only needed on kernels that do not initialize ->recovery_offset
>>>      when activating spares for reshape.
>>>
>>>      Signed-off-by: Dan Williams<dan.j.williams@intel.com>
>>>
>>> diff --git a/Assemble.c b/Assemble.c
>>> index afd4e60..409f0d7 100644
>>> --- a/Assemble.c
>>> +++ b/Assemble.c
>>> @@ -804,7 +804,9 @@ int Assemble(struct supertype *st, char *mddev,
>>>                      devices[most_recent].i.events) {
>>>                          devices[j].uptodate = 1;
>>>                          if (i<  content->array.raid_disks) {
>>> -                               if (devices[j].i.recovery_start == MaxSector) {
>>> +                               if (devices[j].i.recovery_start == MaxSector ||
>>> +                                   (content->reshape_active&&
>>> +                                    j>= content->array.raid_disks - content->delta_disks)) {
>>>                                          okcnt++;
>>>                                          avail[i]=1;
>>>                                  } else
>>
>> --
>> Dan
>
>
> I think the issue here is probably that the metadata handler isn't setting
> recovery_start "properly" for devices that are in-sync just as far as the
> the current reshape has progressed.
>
> I really don't think the kernel has anything to do with it as it doesn't
> report any recovery_start value at all when the device is 'in_sync'.

This was a few months back, but it looks like I looked at the mdadm fix 
and thought I could derive a kernel fix, but yes, the real problem is in 
the mdadm metadata handler.

> So I think this patch is wrong

The kernel patch, not the mdadm patch.

> and you need to fix the getinfo_super method
> to set recovery_start to MaxSector when the device is a new device in an
> array being reshaped.
>
> Could that make sense?

Yes, I can push this fix down to super1.c to avoid:

# mdadm -A /dev/md1 /dev/loop[0-3]
mdadm: /dev/md1 assembled from 3 drives and  1 rebuilding - not enough 
to start the array.

--
Dan
