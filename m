From: Samuli Suominen <ssuominen@gentoo.org>
Subject: Re: [PATCH] IMSM: move "validate_container_imsm" to be included in
 mdassemble
Date: Mon, 21 Jul 2014 10:47:44 +0300
Message-ID: <53CCC5A0.7090004@gentoo.org>
References: <20140718150127.10665.91982.stgit@gklab-154-222.intel.com> <20140721165743.4be73256@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140721165743.4be73256@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids


On 21/07/14 09:57, NeilBrown wrote:
> On Fri, 18 Jul 2014 17:01:27 +0200 Pawel Baldysiak
> <pawel.baldysiak@intel.com> wrote:
>
>> Commit 0c21b485e4beb7bcfe631412a231f7c1ea1067bc added new
>> function in imsm superswitch. This function should be
>> included in mdassemble.
>>
>> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
>> ---
>>  super-intel.c |   82 +++++++++++++++++++++++++++++----------------------------
>>  1 file changed, 41 insertions(+), 41 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index b4efa72..e28ac7d 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -9048,6 +9048,47 @@ int open_backup_targets(struct mdinfo *info, int raid_disks, int *raid_fds,
>>  	return 0;
>>  }
>>  
>> +/*******************************************************************************
>> + * Function:	validate_container_imsm
>> + * Description: This routine validates container after assemble,
>> + *		eg. if devices in container are under the same controller.
>> + *
>> + * Parameters:
>> + *	info	: linked list with info about devices used in array
>> + * Returns:
>> + *	1 : HBA mismatch
>> + *	0 : Success
>> + ******************************************************************************/
>> +int validate_container_imsm(struct mdinfo *info)
>> +{
>> +	if (!check_env("IMSM_NO_PLATFORM")) {
>> +		struct sys_dev *idev;
>> +		struct mdinfo *dev;
>> +		char *hba_path = NULL;
>> +		char *dev_path = devt_to_devpath(makedev(info->disk.major,
>> +										info->disk.minor));
>> +
>> +		for (idev = find_intel_devices(); idev; idev = idev->next) {
>> +			if (strstr(dev_path, idev->path)) {
>> +				hba_path = idev->path;
>> +				break;
>> +			}
>> +		}
>> +		free(dev_path);
>> +
>> +		if (hba_path) {
>> +			for (dev = info->next; dev; dev = dev->next) {
>> +				if (!devt_attached_to_hba(makedev(dev->disk.major,
>> +						dev->disk.minor), hba_path)) {
>> +					pr_err("WARNING - IMSM container assembled with disks under different HBAs!\n"
>> +						"       This operation is not supported and can lead to data loss.\n");
>> +					return 1;
>> +				}
>> +			}
>> +		}
>> +	}
>> +	return 0;
>> +}
>>  #ifndef MDASSEMBLE
>>  /*******************************************************************************
>>   * Function:	init_migr_record_imsm
>> @@ -10524,47 +10565,6 @@ abort:
>>  	return ret_val;
>>  }
>>  
>> -/*******************************************************************************
>> - * Function:	validate_container_imsm
>> - * Description: This routine validates container after assemble,
>> - *		eg. if devices in container are under the same controller.
>> - *
>> - * Parameters:
>> - *	info	: linked list with info about devices used in array
>> - * Returns:
>> - *	1 : HBA mismatch
>> - *	0 : Success
>> - ******************************************************************************/
>> -int validate_container_imsm(struct mdinfo *info)
>> -{
>> -	if (!check_env("IMSM_NO_PLATFORM")) {
>> -		struct sys_dev *idev;
>> -		struct mdinfo *dev;
>> -		char *hba_path = NULL;
>> -		char *dev_path = devt_to_devpath(makedev(info->disk.major,
>> -										info->disk.minor));
>> -
>> -		for (idev = find_intel_devices(); idev; idev = idev->next) {
>> -			if (strstr(dev_path, idev->path)) {
>> -				hba_path = idev->path;
>> -				break;
>> -			}
>> -		}
>> -		free(dev_path);
>> -
>> -		if (hba_path) {
>> -			for (dev = info->next; dev; dev = dev->next) {
>> -				if (!devt_attached_to_hba(makedev(dev->disk.major,
>> -						dev->disk.minor), hba_path)) {
>> -					pr_err("WARNING - IMSM container assembled with disks under different HBAs!\n"
>> -						"       This operation is not supported and can lead to data loss.\n");
>> -					return 1;
>> -				}
>> -			}
>> -		}
>> -	}
>> -	return 0;
>> -}
>>  #endif /* MDASSEMBLE */
>>  
>>  struct superswitch super_imsm = {
>
> Applied, thanks.
>
> Though I do wonder if we really need mdassemble.  Is there a convincing
> use-case?
>
> NeilBrown
>

This is why we are packaging mdassemble in Gentoo's sys-fs/mdadm package:

http://bugs.gentoo.org/show_bug.cgi?id=211426

Quoting from the bug:

"mdassemble is a lightweight program to assemble raid devices that can
be called directly for an initramfs filesystem. It weights 88ko compiled
statically with dietlibc."

So the use case seems to be initramfs, embedded, minimal systems

- Samuli
