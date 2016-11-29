From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 3/7] imsm: PPL support
Date: Tue, 29 Nov 2016 12:02:36 +0100
Message-ID: <bdf93ddb-689e-fa11-ebaa-3d5d19480d82@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
 <20161124122952.16529-4-artur.paszkiewicz@intel.com>
 <wrfjlgw3jh8c.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjlgw3jh8c.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/29/2016 12:51 AM, Jes Sorensen wrote:
> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>> Enable creating and assembling IMSM raid5 arrays with PPL.
>>
>> Write the IMSM MPB location for a device to the newly added rdev
>> sb_start sysfs attribute and 'journal_ppl' to 'state' attribute for
>> every active member.
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  mdadm.h       |  1 +
>>  super-intel.c | 33 +++++++++++++++++++++++++++++++++
>>  sysfs.c       |  4 ++++
>>  3 files changed, 38 insertions(+)
>>
>> diff --git a/mdadm.h b/mdadm.h
>> index 4eabf59..5600341 100755
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -252,6 +252,7 @@ struct mdinfo {
>>  	unsigned long long	custom_array_size; /* size for non-default sized
>>  						    * arrays (in sectors)
>>  						    */
>> +	unsigned long long	sb_start;
>>  #define NO_RESHAPE		0
>>  #define VOLUME_RESHAPE		1
>>  #define CONTAINER_RESHAPE	2
>> diff --git a/super-intel.c b/super-intel.c
>> index df09272..79a3d78 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -1261,6 +1261,15 @@ static void print_imsm_dev(struct intel_super *super,
>>  	}
>>  	printf("\n");
>>  	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
>> +	printf("     RWH Policy : ");
>> +	if (dev->rwh_policy == RWH_OFF)
>> +		printf("off\n");
>> +	else if (dev->rwh_policy == RWH_DISTRIBUTED)
>> +		printf("PPL distributed\n");
>> +	else if (dev->rwh_policy == RWH_JOURNALING_DRIVE)
>> +		printf("PPL journaling drive\n");
>> +	else
>> +		printf("<unknown:%d>\n", dev->rwh_policy);
>>  }
>>  
>>  static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
>> @@ -3043,6 +3052,15 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>>  			}
>>  		}
>>  	}
>> +
>> +	if (info->array.level == 5) {
>> +		if (dev->rwh_policy == RWH_OFF)
>> +			info->rwh_policy = RWH_POLICY_OFF;
>> +		else if (dev->rwh_policy == RWH_DISTRIBUTED)
>> +			info->rwh_policy = RWH_POLICY_PPL;
>> +		else
>> +			info->rwh_policy = RWH_POLICY_UNKNOWN;
>> +	}
>>  }
>>  
>>  static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
>> @@ -3177,6 +3195,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
>>  
>>  		disk = &super->disks->disk;
>>  		info->data_offset = total_blocks(&super->disks->disk) - reserved;
>> +		/* mpb anchor sector - see store_imsm_mpb() */
>> +		info->sb_start = total_blocks(&super->disks->disk) -
>> +				 ((2 * super->sector_size) >> 9);
>>  		info->component_size = reserved;
>>  		info->disk.state  = is_configured(disk) ? (1 << MD_DISK_ACTIVE) : 0;
>>  		/* we don't change info->disk.raid_disk here because
> 
> Hi Artur,
> 
> I have been sitting staring at the above for a while, and looking at
> store_imsm_mpb() it is not clear to me what is meant to happen here.
> 
> For 4k sector drives, aren't you pushing back sb_start way further than
> you are for 512 byte sector drives? Ie. you are subtracting 16 sectors
> for the 4k drive but only two sectors for the 512 byte sector drive?
> 
> Maybe it's because it's Monday or I lost the last of my marbles, but
> could you possibly enlighten me here please?

Jes,

You read it correctly. The reason for this is that the IMSM anchor is
located in the second _logical_ sector from the end of the drive. So for
4k drives this will be 16 512-byte sectors from the end.

Thanks,
Artur

