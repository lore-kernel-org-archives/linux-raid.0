From: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: trouble repairing raid10
Date: Sun, 06 Jun 2010 18:28:53 +0200
Message-ID: <4C0BCCC5.4000709@jungers.net>
References: <4C068616.3070703@jungers.net> <20100603101913.3839c934@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100603101913.3839c934@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/03/2010 02:19 AM, Neil Brown wrote:
> On Wed, 02 Jun 2010 18:25:58 +0200
> Nicolas Jungers<nicolas@jungers.net>  wrote:
>
>> I've a 4 HD raid10 with to failed drive.  Any attempt I made to add 2
>> replacement disks fail consistently.

[snip]
>
> If one of these is actually usable and just had a transient failure then you
> could try re-creating the array with the drives, or 'missing' in the right
> order and with the write layout/chunksize set.
> You would need to be user the 'Data Offset' was the same, which unfortunately
> can require using exactly the same version of mdadm as created the array in
> the first place.

I managed to copy the two failed disk on a new one (same brand/model) 
with (gnu) ddrescue for a grand total of 512 B lost.  With that copy and 
a copy of one of the non failed disk I recreated (mdadm -C) the array 
over the disks with the same creation parameters and two missing drives. 
  I'm not sure that the procedure was quicker than pulling the data back 
from the backup, but nevertheless, the exercise was interesting.

When thinking about it, could it not be automated/detected in some way 
by mdadm or a related utility?  Or documented in a FAQ?  I had the 
feeling that the close to easy recovery state could be eased by mdadm 
itself, or am I dreaming?

N.


>
> NeilBrown
>
>>
>>
>>
>> mdadm --examine /dev/sdm2
>> /dev/sdm2:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : d90ad6fe:1355134f:f83ffadc:a4fe7859
>>              Name : m1:1
>>     Creation Time : Thu Apr  1 21:28:58 2010
>>        Raid Level : raid10
>>      Raid Devices : 4
>>
>>    Avail Dev Size : 3907026909 (1863.02 GiB 2000.40 GB)
>>        Array Size : 7814049792 (3726.03 GiB 4000.79 GB)
>>     Used Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
>>       Data Offset : 272 sectors
>>      Super Offset : 8 sectors
>>             State : clean
>>       Device UUID : e217355e:632ac2f0:8120e55e:3878bd88
>>
>>       Update Time : Wed Jun  2 12:31:39 2010
>>          Checksum : feef2809 - correct
>>            Events : 1377156
>>
>>            Layout : near=2, far=1
>>        Chunk Size : 1024K
>>
>>       Array Slot : 3 (failed, failed, 2, 3)
>>      Array State : __uU 2 failed
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

