From: Brad Campbell <brad@wasp.net.au>
Subject: Re: libata and md issues with 2.9.1-rc1
Date: Wed, 25 Aug 2004 08:53:12 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412C1B38.7090401@wasp.net.au>
References: <412B79DF.2000705@wasp.net.au> <412BC1C4.2060506@clanhk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <412BC1C4.2060506@clanhk.org>
To: "J. Ryan Earl" <heretic@clanhk.org>
Cc: linux-ide@vger.kernel.org, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

J. Ryan Earl wrote:
> Brad Campbell wrote:
> 
>> Just a heads up. I'm experiencing "issues" with 2.6.9-rc1 that don't 
>> occur with 2.6.5.
>>
>> I run a 10 disk raid-5 on 3xPromise SATA150 cards and a 2 disk raid-0 
>> on the on-board VIA chipset.
>> The 10 disks are Maxtor Maxline-II SATA drives and the raid-0 is a 
>> pair of WD2000JB drives with
>> Addonics SATA->PATA converters. 
> 
> 
> Did you try RAID-0 with the pair of Western Digital drives on the two 
> free Promise slots?  If that fails similarly, it might not be a libata 
> issue.

I thought about it. Given the drives are giving write errors when I write to /dev/md1 and not giving 
write errors when the raid is stopped and I write to the individual disks then it *must* be some 
issue with the hardware drivers.

If the block layer can submit a block to the driver that causes the drive to error out, then it's 
really a fault of the driver for trying to do something illegal.

Anyway, I have done a clone of the libata-2.6 bk tree and I'm trying to figure out how to extract 
all the individual csets between 2.6.6 and 2.6.7-rc1 so I can back them out 1 by 1 and see what 
caused the problem.

My other tack is to enable full SCSI debugging and compare the trace from 2.6.5 and 2.6.7-rc1 to see 
what is different.

I will give your suggestion a try when I get home tonight and fire it up on the extra promise channels.

Can anyone point me to a dummys guide to regression testing with BK? I read a great one by the WINE 
guys years ago on regression testing by date with CVS and it has proved immensely helpful over the 
years.

Regards,
Brad
