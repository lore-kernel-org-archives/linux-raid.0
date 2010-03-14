From: Joachim Otahal <Jou@gmx.net>
Subject: Re: md devices: Suggestion for in place time and checksum within
 the RAID
Date: Sun, 14 Mar 2010 02:25:38 +0100
Message-ID: <4B9C3B12.5070401@gmx.net>
References: <4B9C1915.9080009@gmx.net> <4B9C2800.7070802@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9C2800.7070802@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen schrieb:
> Joachim Otahal wrote:
>> Current Situation in RAID:
>> If a drive fails silently and is giving out wrong data instead of 
>> read errors there is no way to detect that corruption (no fun, I had 
>> that a few times already).
>
> That is almost certainly a hardware issue, the chances of silent bad 
> data are tiny, the chances of bad hardware messing the data is more 
> likely. Often cable issues.
In over 20 years (including our customer drives) about ten harddrives of 
that type. Does indeed not happen often. Were not cable issues, we 
replaced the drive with the same type and vendor and RMA'd the original. 
It is not vendor specific, it's like every vendor does have such 
problematic drives during their existence. The last case was just a few 
month ago.

>> Even in RAID1 with three drives there is no "two over three" voting 
>> mechanism.
>>
>> A workaround for that problem would be:
>> Adding one sector to each chunk to store the time (in nanoseconds 
>> resolution) + CRC or ECC value of the whole stripe, making it 
>> possible to see and handle such errors below the filesystem level.
>> Time in nanoseconds only to differ between those many writes that 
>> actually happen, it does not really matter how precise the time 
>> actually is, just every stripe update should have a different time 
>> value from the previous update.
>
> Unlikely to have meaning, there is so much caching and delay that it 
> would be inaccurate. A simple monotonic counter of writes would do as 
> well. And I think you need to do it at a lower level than chuck, like 
> sector. Have to look at that code again.
 From what I know from the docs: The "stripe" is normally 64k, so the 
"chunk" on each drive when using raid5 with three drives is 32k, smaller 
with more drives. At least that is what I am referring to : ). The 
filesystem level never sees what is done on the raid level not even in 
the ZFS implementation on linux which was originally designed for such a 
case.

>> The use of CRC or ECC or whatever hash should be obvious, their 
>> existence would make it easy to detect drive degration, even in a 
>> RAID0 or LINEAR.
>
> There is a ton of that in the drive already.
That is mainly meant to know whether the stripe is consistent (after 
power fail etc), and if not, correct it. Currently that cannot be 
detected, especially since the the partiy is not read in the current 
implementation (at least the docs say so!). If it can be reconstructed 
using the ECC and/or parity write the corrected data back silently (if 
mounted rw) to get the data consistent again. For successful silent 
correction only one syslog line would be enough, if correction is not 
possible it can still go back to the current default behaviour, read 
whatever is there, but at least we could _detect_ such inconsistency.

>> Bad side: Adding this might break the on the fly raid expansion 
>> capabilities. A workaround might be using 8K(+ one sector) chunks by 
>> default upon creation or the need to specify the chunk size on 
>> creation (like 8k+1 sector) if future expansion capabilities are 
>> actually wanted with RAID0/4/5/6, but that is a different issue anyway.
>>
>> Question:
>> Will RAID4/5/6 in the future use the parity upon read too? Currently 
>> it would not detect wrong data reads from the parity chunk, resulting 
>> in a disaster when it is actually needed.
>>
>> Do those plans already exist and my post was completely useless?
>>
>> Sorry that I cannot give patches, my last kernel patch + compile was 
>> 2.2.26, since then I never compiled a kernel.
>>
>> Joachim Otahal
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

