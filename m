From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Odd (slow) RAID performance
Date: Thu, 30 Nov 2006 10:30:11 -0500
Message-ID: <456EF903.10502@tmr.com>
References: <20061130143123.1E05912EDE@bluewhale.planbit.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061130143123.1E05912EDE@bluewhale.planbit.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Lucas <roger@planbit.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roger Lucas wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Bill Davidsen
>> Sent: 30 November 2006 14:13
>> To: linux-raid@vger.kernel.org
>> Subject: Odd (slow) RAID performance
>>
>> Pardon if you see this twice, I sent it last night and it never showed
>> up...
>>
>> I was seeing some bad disk performance on a new install of Fedora Core
>> 6, so I did some measurements of write speed, and it would appear that
>> write performance is so slow it can't write my data as fast as it is
>> generated :-(
>>     
>
> What drive configuration are you using (SCSI / ATA / SATA), what chipset is
> providing the disk interface and what cpu are you running with?
3xSATA, Seagate 320 ST3320620AS, Intel 6600, ICH7 controller using the 
ata-piix driver, with drive cache set to write-back. It's not obvious to 
me why that matters, but if it helps you see the problem I''m glad to 
provide the info. I'm seeing ~50MB/s on the raw drive, and 3x that on 
plain stripes, so I'm assuming that either the RAID-5 code is not 
working well or I haven't set it up optimally.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

