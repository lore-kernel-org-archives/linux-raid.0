From: Tim T <irule@irule.net>
Subject: Re: Raid5 reshape
Date: Fri, 16 Jun 2006 09:14:17 -0700
Message-ID: <4492D8D9.7010101@irule.net>
References: <449250ED.7090302@irule.net> <17554.21119.487820.638171@cse.unsw.edu.au> <4492D5B1.60004@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4492D5B1.60004@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You have to grow the ext3 fs separately. ext2resize /dev/mdX. Keep in 
mind this can only be done off-line.

-Tim

Nigel J. Terry wrote:
> Neil Brown wrote:
>> On Thursday June 15, irule@irule.net wrote:
>>  
>>> Hello all,
>>>
>>> I'm sorry if this is a silly question, but I've been digging around for
>>> a few days now and have not found a clear answer, so I'm tossing it out
>>> to those who know it best.
>>>
>>> I see that as of a few rc's ago, 2.6.17 has had the capability of 
>>> adding
>>> additional drives to an active raid 5 array (w/ the proper ver of 
>>> mdadm,
>>> of course). I cannot, however, for the life of me find out exactly how
>>> one goes about doing it! I would love if someone could give a
>>> step-by-step on what needs to be changed in, say, mdadm.conf (if
>>> anything), and what args you need to throw at mdadm to start the 
>>> reshape
>>> process.
>>>
>>> As a point of reference, here's my current mdadm.conf:
>>>
>>>
>>> DEVICE /dev/sda1
>>> DEVICE /dev/sdb1
>>> DEVICE /dev/sdc1
>>> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1 level=5 
>>> num-devices=3
>>>
>>>     
>>
>> May I suggest:
>>
>>    DEVICE /dev/sd?1
>>    ARRAY /dev/md0 UUID=whatever
>>
>> it would be a lot safer.
>>
>>  
>>> I will be adding the devices /dev/sde1 and /dev/sdf1 (when I can find
>>> out how :)
>>>     
>>
>>  mdadm /dev/md0 --add /dev/sde1 /dev/sdf1
>>  mdadm --grow /dev/md0 --raid-disks=5
>>
>> NeilBrown
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
> This might be an even sillier question, but I'll ask it anyway...
>
> If I add a drive to my RAID5 array, what happens to the ext3 
> filesystem on top of it? Does it grow automatically? Do I have to take 
> some action to use the extra space?
>
> Thanks
>
> Nigel
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

