From: David Greaves <david@dgreaves.com>
Subject: Re: sync_action repair not reading all sectors?
Date: Wed, 18 Mar 2009 12:23:02 +0000
Message-ID: <49C0E7A6.3070502@dgreaves.com>
References: <49BE3786.50809@dgreaves.com> <e9c3a7c20903171446w122ef4f5ibb127b9cbec3c636@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20903171446w122ef4f5ibb127b9cbec3c636@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On Mon, Mar 16, 2009 at 4:27 AM, David Greaves <david@dgreaves.com> wrote:
>> I have a drive that has bad sectors. Lots of them.
>>
>> smartctl shows
>> # 1  Short offline       Completed: read failure       20%       530
>> 1953520877
>>
>> A simple ddrescue to this part of the disk gets this:
>>
>> Mar 16 10:41:28 elm kernel: [ 8643.123397] sd 3:0:0:0: [sdd] 1953525168 512-byte
>> hardware sectors (1000205 MB)
>> <snip<>51/40:00:f0:5c:70/00:00:74:00:00/e0 Emask 0x9 (media error)
>> Mar 16 10:41:29 elm kernel: [ 8644.190060] ata4.00: status: { DRDY ERR }
>> Mar 16 10:41:29 elm kernel: [ 8644.190099] ata4.00: error: { UNC }
>>
>> and reports 30 or so errors.
>>
>>
>> mdstat tells me:
>> md0 : active raid5 sdd1[0] sdb1[2] sda1[1]
>>      1953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>>
>> So sdd1 is in there.
>>
>> /dev/sdd1 is the full disk
>>
> 
> Are you sure?  Maybe I did the following math wrong, but it seems
> there is a chance this bad region is outside the raid array.
> /proc/mdstat says the array is 1953519872 blocks large which is
> 3907039744 sectors.  For a three disk raid5 that means we are using
> 1953519872 sectors per disk.  The failing sector of 1953520877 is 1005
> sectors outside the array, probably 942 assuming partition 1 starts at
> sector 63??
> 
> --
> Dan

Thanks for taking the time to look and for spotting this Dan.

Well you are right. The media error is occurring outside the partition.

But equally: yes, it's the full disk according to cfdisk,fdisk

I *knew* that I'd allocated the full disk to the partition and checked at a
cursory level but not at a sector level :(

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
/dev/sdd1               1      121601   976760001   83  Linux

1 Primary           0  1953520064     63  1953520065 Linux (83)           None

but kernel.log says:
sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)

So I humbly apologise for doubting md :)


Pragmatically it looks like a genuine disk error but I should be OK to recover
by stopping the array and doing a fast ddrescue mirror on this device rather
than a more risky replace/resync now the advance replacement has arrived.

Shame we can't do that without stopping the array yet ;)

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
