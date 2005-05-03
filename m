From: Tyler <pml@dtbb.net>
Subject: Re: Any way to Increase MD_SB_DISKS=27 ? I need 31 devices
Date: Tue, 03 May 2005 15:28:58 -0700
Message-ID: <4277FB2A.5060008@dtbb.net>
References: <427583FA.7030704@dtbb.net> <42764014.5060909@steeleye.com> <42775EF9.7030009@dtbb.net> <427784CB.7070000@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <427784CB.7070000@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, I will give that a try paul... but i've actually tryed using mdadm 
v2.0-devel to create an array with a version 1 superblock, using only 3 
drives in a raid5 array.  It hasn't worked so far, read my 2 bugreports 
to the mailing list, to see whats happening.. and maybe draw some 
insight from them?  I'm at a loss as to why mdadm is failing right now.. 
even without going over the 27 drive limit.  Neil hasn't responded to 
any emails I've sent regarding this either..

Thanks,
Tyler.

PS - Can you see any kind of order to the "applied" patches on Neil's 
site? .. I can't tell which ones are for the 2.0-devel version and which 
are for 1.9.x .. and one says 1.8 ... etc..

Paul Clements wrote:

> Tyler wrote:
>
>> Isn't the superblock still limited to 27 drives though? .. is there 
>
>
> The version 0.90 superblock is limited to 27 drives. Version 1 
> superblock is limited to about 2000 drives, because Neil shrunk the 
> amount of per-drive data stored in the superblock drastically. The 
> check in mdadm, is in the file mdadm.c, just grep for the message that 
> you got ("invalid number of raid devices"). Comment out that code and 
> recompile mdadm. Everything should work after that. The kernel you 
> have already has support for version 1 superblocks.
>
> -- 
> Paul
>
>> maybe a patch for version 1 superblocks that i don't have in 
>> 2.6.12-rc3-mm2, that changes the max drives in the md_p.h and md.c 
>> driver?  There is only 4096 bytes earmarked for superblocks, and 
>> within that amount, there isn't enough room to list more than 27 
>> drives that may be part of the same array.
>>
>> Do I need some more patches for this to work, that aren't in the -mm 
>> tree yet?  I was under the impression (from the mdadm v2.0 announce 
>> file, that anything *after* 2.6.11-rc3 in the -mm tree would have the 
>> required patches.
>>
>> Also, where can I disable the check in mdadm?
>>
>> Thanks,
>> Tyler.
>>
>> Paul Clements wrote:
>>
>>> Tyler wrote:
>>>
>>>> PS - I've tryed the latest 2.6.12-rc3-mm2 kernel, with mdadm 
>>>> v2.0-devel, using the --metadata 1.0 option on the create line, and 
>>>> still get:
>>>
>>>
>>>
>>>
>>>> # mdadm -C -e 1.0 -l 6 -n 31 /dev/md0 /dev/hdb /dev/hdc /dev/hdd 
>>>> /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg 
>>>> /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn 
>>>> /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu 
>>>> /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab
>>>> mdadm: invalid number of raid devices: 31
>>>
>>>
>>>
>>>
>>> As far as I can tell, mdadm just shouldn't give this error when 
>>> you're using a version 1 superblock. If you disable that check in 
>>> mdadm.c, I think everything will work. Version 1 superblocks allow 
>>> something like 2000 disks in an array.
>>>
>>> -- 
>>> Paul
>>
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
