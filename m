From: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: trouble repairing raid10
Date: Thu, 03 Jun 2010 06:38:14 +0200
Message-ID: <4C0731B6.7040701@jungers.net>
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
>>
>> mdadm -Af /dev/md1 /dev/sdm2 /dev/sdp2   /dev/sdb2  /dev/sdd2
>> mdadm: failed to add /dev/sdd2 to /dev/md1: Device or resource busy
>
> Any idea why sdd2 is busy??

No, because sdd2 is not busy.  I have 4 spares (b, c, d and e), the one 
I set in fourth position in the above mdadm -Af command is reported as 
busy, whatever the one I set there.  The same disk in third position get 
a mdadm superblock write on them.  I suspect then an incorrect error 
message.

>> mdadm: /dev/md1 assembled from 2 drives and 1 spare - not enough to
>> start the array.
>>
>> or
>>
>> root@disk:~# mdadm -AR /dev/md1 /dev/sdm2 /dev/sdp2
>> mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
>> mdadm: Not enough devices to start the array.
>> root@disk:~# mdadm --add /dev/md1 /dev/sdb2
>> mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument
>>
>>
>> The array is in near mode and I lost disk 0 and 1.  Does it mean that my
>> data are toasted?
>
> Yes.  RAID10 can survive the failure of 2 non-adjacent devices and sometimes
> 2 adjacent devices.  But not 0 and 1 of a near=2 array.
>
> So if those devices are really dead, so is your data.
>
> If one of these is actually usable and just had a transient failure then you
> could try re-creating the array with the drives, or 'missing' in the right
> order and with the write layout/chunksize set.
> You would need to be user the 'Data Offset' was the same, which unfortunately
> can require using exactly the same version of mdadm as created the array in
> the first place.

will try that, it was created on a beta of Ubuntu 10.04 and is now 
running on shipped 10.04 (kernel 2.6.32)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

