From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 18:57:41 +0000
Message-ID: <52AA0725.6070808@mpstor.com>
References: <52A98FAF.4000205@insync.za.net> <52A9A380.50805@hesbynett.no> <52A9EAF9.6020804@insync.za.net> <52A9EED1.40703@mpstor.com> <ff87dc745635b18a71b98ce36356eea7@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff87dc745635b18a71b98ce36356eea7@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/12/13 18:11, Pieter De Wit wrote:
>> Hi,
>>
>> <snip>
>>
>> When resyncing a RAID5, is the CPU running 100%? Even old CPUs should be
>> able to resync faster than that. What CPU is that if I may ask?
>>
>> I just confirmed they are *not* at 100% so the bottleneck is somewhere else. Here is the last cpu in cpuinfo:
>>
>> processor : 3
>> vendor_id : GenuineIntel
>> cpu family : 15
>> model : 2
>> model name : Intel(R) Xeon(TM) CPU 2.80GHz
>> stepping : 7
>> microcode : 0x38
>> cpu MHz : 2791.161
>> cache size : 512 KB
>> physical id : 3
>> siblings : 1
>> core id : 0
>> cpu cores : 0
>> apicid : 7
>> initial apicid : 7
>> fdiv_bug : no
>> hlt_bug : no
>> f00f_bug : no
>> coma_bug : no
>> fpu : yes
>> fpu_exception : yes
>> cpuid level : 2
>> wp : yes
>> flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
>> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid
>> xtpr
>> bogomips : 5582.28
>> clflush size : 64
>> cache_alignment : 128
>> address sizes : 36 bits physical, 32 bits virtual
>> power management:
>>
>> This is rebuilding of RAID6:
>>
>> [>....................]  resync =  0.1% (1215876/732443136)
>> finish=4444.2min speed=2741K/sec
>>
>> # tail sync_speed sync_speed_max sync_speed_min
>>
>> ==> sync_speed <==
>> 2788
>>
>> ==> sync_speed_max <==
>> 200000 (system)
>>
>> ==> sync_speed_min <==
>> 200000 (local)
>>
>> # tail sync_speed sync_speed_max sync_speed_min
>> ==> sync_speed <==
>> 2788
>>
>> ==> sync_speed_max <==
>> 200000 (system)
>>
>> ==> sync_speed_min <==
>> 200000 (local)
>>
>> # dmesg | grep "raid6: using algorithm"
>> [ 2.244060] raid6: using algorithm mmxx2 (1916 MB/s)
>>
We have similar CPUs here and we get good resync speed. How many disks 
are in your array, and what's their size?

Maybe one of your disk is not performing well, you could try to profile 
their individual speed.

>>> I, naively perhaps, assumed the bottleneck to be the Intel CPU's
>>> which sparked this idea. What about block level hashing ? (Unless
>>> this is already done and I just never knew it :) )
>> Like keeping a checksum of each RAID chunk or stripe for data
>> consistency checks? RAID doesn't deal with that, it deals with
>> reconstructing data in the event of a drive failure but doesn't
>> guarantee data consistency. Therefore, if some bits on a drive were to
>> be "flipped", the next RAID "scrub" (repair) would detect a mismatch
>> between the data chunks and the parity and would simply update the
>> parity from the available data (not "repairing" the corrupted data), as
>> far as I know that's because there's no way for the array to know
>> whether the data or the parity was written wrong or corrupted.
>>
>> Regards,
>> Ben.
>>
>> Is there parity in RAID10/RAID1 ? It seems my idea won't work either way as there isn't the bus bandwidth to support it, this is now more an educational thing :)
>>
RAID1 is a mirror (a full copy), while RAID10 is different than RAID1 
it's still not using parity but chunk copies.

>> Cheers,
>>
>> Pieter

