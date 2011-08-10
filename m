From: Thomas Steinborn <thestonewell@googlemail.com>
Subject: Re: mdadm(IMSM): Unsupported attributes : 40000000
Date: Wed, 10 Aug 2011 11:13:47 +0200
Message-ID: <4E424BCB.30005@googlemail.com>
References: <CACHinyGxah6Utp+ed0WKH58BO8-sOn+QX9DPCy9QGNjuDde=eQ@mail.gmail.com> <20110809085117.5d910aed@notabene.brown> <B76B33F8487BA74591724C4746DFF732938F@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B76B33F8487BA74591724C4746DFF732938F@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Btw, I have a pretty old imsm controller.
[root@pinguin ~]# mdadm --detail-platform

            Platform : Intel(R) Matrix Storage Manager
             Version : 5.0.0.1032
         RAID Levels : raid0 raid1 raid10
         Chunk Sizes : 4k 8k 16k 32k 64k 128k
           Max Disks : 4
         Max Volumes : 2
      I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
               Port0 : /dev/sda (WD-WMANK1522533)
               Port2 : /dev/sdb (WD-WMANK1522480)
               Port1 : - no device attached -
               Port3 : - no device attached -


And indeed this was managed by dmraid before.

The array itself was created by the controller BIOS and not windows or linux.

HTH
Thomas


On 09.08.2011 11:36, Wojcik, Krzysztof wrote:
> Neil,
>
> In fact this bit may cause backward compatibility issue.
> It was used in old versions of IMSM metadata and for some reason was marked as "never use".
> Skipping this bit during compatibility check is good idea.
>
> I've checked compatibility with metadata created using dmraid and got another issue.
> Attribute "MPB_ATTRIB_NEVER_USE2" is set in metadata created by dmraid so mdadm refuse loading metadata.
> Could you add MPB_ATTRIB_NEVER_USE2 to your patch to MPB_ATTRIB_IGNORED list?
>
> Regards
> Krzysztof
>
>> -----Original Message-----
>> From: NeilBrown [mailto:neilb@suse.de]
>> Sent: Tuesday, August 09, 2011 12:51 AM
>> To: Thomas Steinborn
>> Cc: linux-raid@vger.kernel.org; Kwolek, Adam; Wojcik, Krzysztof;
>> Williams, Dan J
>> Subject: Re: mdadm(IMSM): Unsupported attributes : 40000000
>>
>> On Sat, 6 Aug 2011 20:55:47 +0200 Thomas Steinborn
>> <thestonewell@googlemail.com>  wrote:
>>
>>> Hi,
>>>
>>> after updating to mdadm 3.2.2 (by way of upgrading from Fedora 14 to
>>> 15) from 3.1.5 I am no longer able to boot my IMSM raid, which I was
>>> able to for the last 5 years or so.
>>>
>>> The errors I am getting are:
>>>
>>>    mdadm(IMSM): Unsupported attributes : 40000000
>>>    mdadm: IMSM metadata loading not allowed due to attributes
>> incompatibility.
>>> I tracked that down to the patch at
>>>
>>> http://www.spinics.net/lists/raid/msg34783.html
>>>
>>> According to that patch 40000000 means #define MPB_ATTRIB_NEVER_USE
>>> __cpu_to_le32(0x40000000). Any advice why an unused but aparently set
>>> attribute should stop the raid to boot?
>>>
>>> For now I am up and running with 3.1.5 but would like to keep up with
>>> the latest mdadm if possible.
>>>
>>> Thanks
>>> Thomas
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Thanks for the report.
>>
>> It looks like we need something like the following.
>>
>> Adam/Kryzysztof:  Is this patch reasonable?
>>
>> Thanks,
>> NeilBrown
>>
>>
>>
>>
>>
>>  From 418f9b368a1200370695527d22aba8c3606172c5 Mon Sep 17 00:00:00 2001
>> From: NeilBrown<neilb@suse.de>
>> Date: Tue, 9 Aug 2011 08:49:34 +1000
>> Subject: [PATCH] IMSM: allow some array attribute bits to be ignored.
>>
>> Some bits are not handled by mdadm, but their presence should not
>> cause failure.
>> In particular MPB_ATTRIB_NEVER_USE appears harmless.
>>
>> Reported-by: Thomas Steinborn<thestonewell@googlemail.com>
>> Signed-off-by: NeilBrown<neilb@suse.de>
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index dcab5f9..ddf4de9 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -74,14 +74,17 @@
>>
>>   /* Define all supported attributes that have to be accepted by mdadm
>>    */
>> -#define MPB_ATTRIB_SUPPORTED		MPB_ATTRIB_CHECKSUM_VERIFY | \
>> +#define MPB_ATTRIB_SUPPORTED	       (MPB_ATTRIB_CHECKSUM_VERIFY | \
>>   					MPB_ATTRIB_2TB             | \
>>   					MPB_ATTRIB_2TB_DISK        | \
>>   					MPB_ATTRIB_RAID0           | \
>>   					MPB_ATTRIB_RAID1           | \
>>   					MPB_ATTRIB_RAID10          | \
>>   					MPB_ATTRIB_RAID5           | \
>> -					MPB_ATTRIB_EXP_STRIPE_SIZE
>> +					MPB_ATTRIB_EXP_STRIPE_SIZE)
>> +
>> +/* Define attributes that are unused but not harmful */
>> +#define MPB_ATTRIB_IGNORED		(MPB_ATTRIB_NEVER_USE)
>>
>>   #define MPB_SECTOR_CNT 2210
>>   #define IMSM_RESERVED_SECTORS 4096
>> @@ -1141,11 +1144,14 @@ void examine_migr_rec_imsm(struct intel_super
>> *super)
>>   static int imsm_check_attributes(__u32 attributes)
>>   {
>>   	int ret_val = 1;
>> -	__u32 not_supported = (MPB_ATTRIB_SUPPORTED)^0xffffffff;
>> +	__u32 not_supported = MPB_ATTRIB_SUPPORTED^0xffffffff;
>> +
>> +	not_supported&= ~MPB_ATTRIB_IGNORED;
>>
>>   	not_supported&= attributes;
>>   	if (not_supported) {
>> -		fprintf(stderr, Name "(IMSM): Unsupported attributes :
>> %x\n", not_supported);
>> +		fprintf(stderr, Name "(IMSM): Unsupported attributes :
>> %x\n",
>> +			(unsigned)__le32_to_cpu(not_supported));
>>   		if (not_supported&  MPB_ATTRIB_CHECKSUM_VERIFY) {
>>   			dprintf("\t\tMPB_ATTRIB_CHECKSUM_VERIFY \n");
>>   			not_supported ^= MPB_ATTRIB_CHECKSUM_VERIFY;
