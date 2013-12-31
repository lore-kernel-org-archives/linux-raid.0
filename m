From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Tue, 31 Dec 2013 08:21:19 -0600
Message-ID: <52C2D2DF.5040701@hardwarefreak.com>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net> <52C14FB8.8080005@hardwarefreak.com> <52C162A7.1080309@insync.za.net> <52C1A8F0.2030208@hardwarefreak.com> <52C1BC3A.3070106@insync.za.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C1BC3A.3070106@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/30/2013 12:32 PM, Pieter De Wit wrote:
> Hi Stan,
> 
>> (3407028224 sectors * 512 bytes per sector) / 524288 (chunk bytes) =
>>
>> 3327176 chunks

> Right - more for clarity, these are the 512 byte sectors, not the 4k
> ones (otherwise I would have had a 12 TB drive :) )

Linux works only with 512B sectors at this time, thus all the
partitioning tools use 512B sectors.  At some point in the future we may
see native 4K/sector devices and native Linux support for those.

>> Please show the exact iostat command line you are using and the output. 
> iostat -x 1

You're polling once every second so the 15 MB/s isn't due to averaging.

>>> Also, there is no other disk usage in the system. All the data is
>>> currently on the NAS (except system "stuff" for a quite firewall)
>>>
>>> I just spotted another thing, the two drives are on the same SATA
>>> controller, from rescan-scsi-bus:
>>>
>>> Scanning for device 3 0 0 0 ...
>>> OLD: Host: scsi3 Channel: 00 Id: 00 Lun: 00
>>>        Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>>>        Type:   Direct-Access                    ANSI SCSI revision: 05
>>> Scanning for device 3 0 1 0 ...
>>> OLD: Host: scsi3 Channel: 00 Id: 01 Lun: 00
>>>        Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>>>        Type:   Direct-Access                    ANSI SCSI revision: 05
>>>
>>> Would it be better to move these apart ? I remember IDE used to have
>>> this issue, but I also recall SATA "fixed" that.
>>
>> This isn't the problem.  Even if both drives were connected via a plain
>> old 33MHz 132MB/s PCI SATA card you'd still be capable of 120MB/s
>> throughput, 60MB/s per drive.
>>
>>> Thanks again,
>> You're welcome.  Eventually you get to the bottom of this.
>>
> And the email :) I now have the drive with no data on them, so I can
> even run write tests. I am going to start with the usual "dd" tests, any
> other that you would like to see ?

dd will give you a rough idea of the single streaming throughput of the
array, which will be lower than its maximum throughput due to
serialization and latency.  If you want to see the max the array can do
use FIO as it can do both parallel and async IO.

-- 
Stan

