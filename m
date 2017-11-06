From: Chris Walker <cwalker@cray.com>
Subject: Re: FW: change in disk failure policy for non-BBL arrays?
Date: Mon, 6 Nov 2017 08:42:50 -0500
Message-ID: <4d710aa5-152d-d665-3be7-3abcca853ff5@cray.com>
References: <ebc61f38-b401-c01a-5c2a-4671287f6eee@cray.com>
 <294F8C1D-AFB2-4445-9F7B-18D761A6D846@cray.com>
 <a19fee9c-71bc-6c58-3730-baf24f051468@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a19fee9c-71bc-6c58-3730-baf24f051468@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Perfect, thanks very much Artur.

Chris


On 11/6/17 3:14 AM, Artur Paszkiewicz wrote:
> On 11/03/2017 08:58 PM, Chris Walker wrote:
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
> Hi,
>
> Some time ago I sent a patch that fixed this issue but now I see that it
> never got applied:
> https://marc.info/?l=linux-block&m=145986120124345&w=2. I'll resend it
> and hopefully it gets applied this time.
>
> Thanks,
> Artur

