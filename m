From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: LVM cannot stop/remove LV, cannot stop/delete dead RAID situation.
Date: Wed, 26 Aug 2009 13:20:52 +0100
Message-ID: <4A9528A4.1030500@mpstor.com>
References: <4A93F912.5040900@mpstor.com> <87d46i95yq.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d46i95yq.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Goswin,

Thank you for your reply, I had no knowledge of this tool (dmsetup).

After using the following commands:

dmsetup remove -f -j 253 -m 0
dmsetup remove -f -j 253 -m 1
dmsetup remove -f -j 253 -m 2
dmsetup remove -f -j 253 -m 4

I was able to remove all of the LVM LVs, they disappeared from 
/proc/partitions,
from /sys/block too

It seems that the /dev/xxxx/yyyy links were still active though, but 
they disappeared shortly after the above command.

This worked actually pretty well, within 30 seconds of stopping these,
I was able to stop the RAID with the stuck handle!

Thank you very much for your help!

Ben - MPSTOR.

Goswin von Brederlow wrote:
> Benjamin ESTRABAUD <be@mpstor.com> writes:
>
>   
>> Hi,
>>
>> I am having an issue with LVM and RAID in some failure cases:
>>
>> It seems that any operations on a LVM LV (lvchange, lvremove, etc..),
>> require this LV's metadata to be readable.
>>
>> In case a LVM LV is setup ontop of a RAID 0, or a RAID 5 for instance,
>> if two disks are lost from the RAID array, the array dies.
>>
>> Now that the array is dead, I would like to recreate a new RAID 0 or 5
>> using the remaining alive disks and some new ones. For this reason,
>> I'd like to stop the previous dead RAID using mdadm.
>>
>> However, because the LVM LV does still exists, it seems to have a
>> handle on the dead RAID, as shon below:
>>
>> ...
>>
>> The problem with the above is that because LVM depends on the RAID's
>> good health to perform any operations, and the MD forbids to perform
>> any operation should a handle be opened on itself, we cannot stop
>> either the RAID or the LVM, unless the system is rebooted.
>>
>> Since rebooting works, but that I cannot afford to reboot in this
>> case, I was wondering if anybody
>> knew where to start looking to force the handle opened by LVM on the
>> RAID to go away, maybe in the LVM admin programs (lvremove, lvchange)
>> or in the dm driver itself?
>>
>> Thanks a million in advance for your advices.
>>
>> Ben - MPSTOR.
>>     
>
> You can remove the lvm devices yourself:
>
> man dmsetup
>
> MfG
>         Goswin
>
>   

