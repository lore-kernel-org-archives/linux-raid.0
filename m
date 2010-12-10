From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: disable creation of md127
Date: Fri, 10 Dec 2010 15:43:12 -0700
Message-ID: <4D02AD00.6070705@feystorm.net>
References: <4D029DD6.5070705@feystorm.net> <20101211085859.55d0f889@notabene.brown> <4D02AB51.5090707@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D02AB51.5090707@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Fri Dec 10 2010 15:36:01 GMT-0700 (Mountain Standard Time)
From: Patrick H. <linux-raid@feystorm.net>
To: linux-raid@vger.kernel.org
Subject: Re: disable creation of md127
> Sent: Fri Dec 10 2010 14:58:59 GMT-0700 (Mountain Standard Time)
> From: Neil Brown <neilb@suse.de>
> To: Patrick H. <linux-raid@feystorm.net> linux-raid@vger.kernel.org
> Subject: Re: disable creation of md127
>> On Fri, 10 Dec 2010 14:38:30 -0700 "Patrick H." 
>> <linux-raid@feystorm.net>
>> wrote:
>>
>>  
>>> How can I prevent the MD driver from auto-creating md127 on boot?
>>> I have a server which is exporting /dev/sdb1 via iSCSI. The remote 
>>> client for this device is using it in a raid device so it has raid 
>>> metadata on it. However because of this, when the target server 
>>> boots up, the md driver shoves it into md127. And because of this, 
>>> the iSCSI target daemon (tgtd) wont export the device as its now 
>>> part of a raid device.
>>> The partition type is 0x83, not 0xfd.
>>>
>>> RHEL6 2.6.32-71
>>>     
>>
>> The md driver isn't auto-creating this.  mdadm is being run and being 
>> asked to create this, possibly implicitly.
>>
>> Exactly how you stop this from happening depends on where it is an 
>> initrd
>> script or a boot script that is doing it, and which version of mdadm 
>> you have.
>>
>> If you have 3.0 or later, then putting
>>    AUTO -all
>>
>> in mdadm.conf might be enough.
>> If you have a 2.x, you probably need to tell the init script not to run
>> mdadm, maybe edit the script, maybe set some default variable.  I 
>> know little
>> about RHEL and so cannot suggest specifics.
>>
>> NeilBrown
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
> Youre right. I removed every single md-related init script so I didnt 
> think mdadm was doing it. But apparently I forgot about udev. I 
> replaced mdadm with a script to dump out a bunch of info and found 
> that udev is calling `mdadm -I /dev/sdb1`. Any idea where this might 
> be configured at? I did a recursive grep for 'mdadm' in the entire 
> /etc and found nothing but init scripts and a little selinux stuff  
> (nothing in /etc/udev).
>
> -Patrick
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Nevermind, found it. /lib/udev/rules.d/65-md-incremental.rules
Thanks for pointing me back at mdadm (had ruled it out after I removed 
the init scripts) :-)
