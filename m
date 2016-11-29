From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 3/7] imsm: PPL support
Date: Tue, 29 Nov 2016 10:23:07 -0500
Message-ID: <wrfjzikigvj8.fsf@redhat.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
        <20161124122952.16529-4-artur.paszkiewicz@intel.com>
        <wrfjlgw3jh8c.fsf@redhat.com>
        <bdf93ddb-689e-fa11-ebaa-3d5d19480d82@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdf93ddb-689e-fa11-ebaa-3d5d19480d82@intel.com> (Artur
        Paszkiewicz's message of "Tue, 29 Nov 2016 12:02:36 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 11/29/2016 12:51 AM, Jes Sorensen wrote:
>>> @@ -3177,6 +3195,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
>>>  
>>>  		disk = &super->disks->disk;
>>>  		info->data_offset = total_blocks(&super->disks->disk) - reserved;
>>> +		/* mpb anchor sector - see store_imsm_mpb() */
>>> +		info->sb_start = total_blocks(&super->disks->disk) -
>>> +				 ((2 * super->sector_size) >> 9);
>>>  		info->component_size = reserved;
>>>  		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
>>>  		/* we don't change info->disk.raid_disk here because
>> 
>> Hi Artur,
>> 
>> I have been sitting staring at the above for a while, and looking at
>> store_imsm_mpb() it is not clear to me what is meant to happen here.
>> 
>> For 4k sector drives, aren't you pushing back sb_start way further than
>> you are for 512 byte sector drives? Ie. you are subtracting 16 sectors
>> for the 4k drive but only two sectors for the 512 byte sector drive?
>> 
>> Maybe it's because it's Monday or I lost the last of my marbles, but
>> could you possibly enlighten me here please?
>
> Jes,
>
> You read it correctly. The reason for this is that the IMSM anchor is
> located in the second _logical_ sector from the end of the drive. So for
> 4k drives this will be 16 512-byte sectors from the end.

I see, so the IMSM implementation uses 512 byte logical sectors on top
of 4k drives? Could I ask you to add a note explaining this in the code?

Thanks,
Jes
