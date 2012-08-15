From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: Error in rebuild of two "layered" md devices in container
Date: Wed, 15 Aug 2012 22:04:27 +0200
Message-ID: <502C00CB.3080407@gmail.com>
References: <CAGkViCEBCMgPXbByGPe8MgTKsSkn1Dc=_XLgCCDCfSrEGwEs_w@mail.gmail.com> <20120815094352.38550670@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120815094352.38550670@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

as a first test I can confirm that this fixes the problem with the 
layered md devices in a container.

So far so good on this.

Thanks,

regards,

Albert

On 08/15/2012 01:43 AM, NeilBrown wrote:
> On Wed, 1 Aug 2012 19:52:51 +0200 Albert Pauw <albert.pauw@gmail.com> wrote:
>
>> Hi Neil,
>>
>> found another bug.
>>
>> - Created a container with six disks
>> - Created two md devices in it:
>>
>> mdadm -CR /dev/md0 -l 6 -n 6 -z 50M
>> mdadm -CR /dev/md1 -l 5 -n 6 -z 50M
>>
>> The md devices are "layered" in the container across all disks.
>>
>> They both get build and are online.
>>
>> - Fail one disk, both md devices are affected
>> - Remove disk
>> - Clear superblock of removed disk
>> - Add disk again (in essence, I just added a spare disk)
>>
>> Now comes the error:
>>
>> - md0 is rebuild
>> - md1 is NOT rebuild
> The reason for this is somewhat messy.
> mdadm will currently only add a 'spare' device to an array which needs a
> replacement device.
> In DDF the whole device is either 'active' or 'spare'.  There isn't a concept
> of 'partly active, partly spare'.
> So when mdadm adds part of the disk to one array it stops being spare and
> started being active.  So when mdadm looks for a spare to add to the second
> array, there are no spare devices.
>
> I can hack around it by allowing any non-failed device to be considered as a
> spare but I need to find a better solution.  That might take a while.  I've
> made a note on my to-do list, but it is a rather long list.
>
> Thanks,
> NeilBrown
>
> diff --git a/super-ddf.c b/super-ddf.c
> index d006a04..11b98f7 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2616,7 +2616,7 @@ static int validate_geometry_ddf(struct supertype *st,
>   	if (chunk && *chunk == UnSet)
>   		*chunk = DEFAULT_CHUNK;
>   
> -
> +	if (level == -1000000) level = LEVEL_CONTAINER;
>   	if (level == LEVEL_CONTAINER) {
>   		/* Must be a fresh device to add to a container */
>   		return validate_geometry_ddf_container(st, level, layout,
> @@ -3701,6 +3701,10 @@ static struct mdinfo *ddf_activate_spare(struct active_array *a,
>   			} else if (ddf->phys->entries[dl->pdnum].type &
>   				   __cpu_to_be16(DDF_Global_Spare)) {
>   				is_global = 1;
> +			} else if (!(ddf->phys->entries[dl->pdnum].state &
> +				     __cpu_to_be16(DDF_Failed))) {
> +				/* we can possibly use some of this */
> +				is_global = 1;
>   			}
>   			if ( ! (is_dedicated ||
>   				(is_global && global_ok))) {

