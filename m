From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Tue, 31 Dec 2013 07:32:26 +1300
Message-ID: <52C1BC3A.3070106@insync.za.net>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net> <52C14FB8.8080005@hardwarefreak.com> <52C162A7.1080309@insync.za.net> <52C1A8F0.2030208@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C1A8F0.2030208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stan,

  

> (3407028224 sectors * 512 bytes per sector) / 524288 (chunk bytes) =
>
> 3327176 chunks
Right - more for clarity, these are the 512 byte sectors, not the 4k 
ones (otherwise I would have had a 12 TB drive :) )
> Please show the exact iostat command line you are using and the output. 
iostat -x 1
>> Also, there is no other disk usage in the system. All the data is
>> currently on the NAS (except system "stuff" for a quite firewall)
>>
>> I just spotted another thing, the two drives are on the same SATA
>> controller, from rescan-scsi-bus:
>>
>> Scanning for device 3 0 0 0 ...
>> OLD: Host: scsi3 Channel: 00 Id: 00 Lun: 00
>>        Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>>        Type:   Direct-Access                    ANSI SCSI revision: 05
>> Scanning for device 3 0 1 0 ...
>> OLD: Host: scsi3 Channel: 00 Id: 01 Lun: 00
>>        Vendor: ATA      Model: WDC WD20EARX-008 Rev: 51.0
>>        Type:   Direct-Access                    ANSI SCSI revision: 05
>>
>> Would it be better to move these apart ? I remember IDE used to have
>> this issue, but I also recall SATA "fixed" that.
> This isn't the problem.  Even if both drives were connected via a plain
> old 33MHz 132MB/s PCI SATA card you'd still be capable of 120MB/s
> throughput, 60MB/s per drive.
>
>> Thanks again,
> You're welcome.  Eventually you get to the bottom of this.
And the email :) I now have the drive with no data on them, so I can 
even run write tests. I am going to start with the usual "dd" tests, any 
other that you would like to see ?

Cheers,

Pieter
