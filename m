From: Chris Walker <cwalker@cray.com>
Subject: Re: FW: change in disk failure policy for non-BBL arrays?
Date: Fri, 3 Nov 2017 17:59:09 -0400
Message-ID: <8edf8bf4-728c-5bdb-6508-8da0f2a73b85@cray.com>
References: <ebc61f38-b401-c01a-5c2a-4671287f6eee@cray.com>
 <294F8C1D-AFB2-4445-9F7B-18D761A6D846@cray.com>
 <2bd80694-a168-2ae7-c1db-e9b8d3b29657@prgmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2bd80694-a168-2ae7-c1db-e9b8d3b29657@prgmr.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Sarah Newman <srn@prgmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Note that this only affects arrays on which the bad block table has been 
disabled.  The BBT is enabled by default, so this is only an issue for 
you if you have actively disabled the BBT (assembling with the -U no-bbl 
option, for example).

Thanks,
Chris



On 11/3/17 4:19 PM, Sarah Newman wrote:
> On 11/03/2017 12:58 PM, Chris Walker wrote:
>> Hello,
>> I was looking at this again today and it appears that with this change, error handling no longer works correctly in RAID10 (I haven't checked the other levels yet).  Without a BBL configured, an error cycles through fix_read_error until max_read_errors is exceeded, and only then is the drive kicked out of the array.  For example, if I inject errors in response to both read and write commands at sector 16392 of /dev/sda, logs in response to a read of the corresponding md0 sector look like:
>>   
>> (many repeats)
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: unable to read back corrected sectors (8 sectors at 16392 on sda)
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: read correction write failed (8 sectors at 16392 on sda)
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: unable to read back corrected sectors (8 sectors at 16392 on sda)
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: failing drive
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: Raid device exceeded read_error threshold [cur 21:max 20]
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: sda: Failing raid device
>> Oct 27 16:15:16 c1 kernel: md/raid10:md0: Disk failure on sda, disabling device.
>>
>> Previously, the drive would have been failed out of the array by the call of md_error at the end of r10_sync_page_io.
>>
>> Is there an appetite for a patch that takes the easy way out by reverting to the previous behavior with changes like
>>
>> -       if (!rdev_set_badblocks(rdev, sector, sectors, 0))
>> +       if (!rdev_set_badblocks(rdev, sector, sectors, 0) || rdev->badblocks.shift < 0)
>>
>> Thanks,
>> Chris
>>
> As a RAID10 user that seems like the right thing to do, thank you.
>
> --Sarah

