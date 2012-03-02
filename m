From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 11:14:43 +0000
Message-ID: <4F50ABA3.1070603@anonymous.org.uk>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk> <4F509402.8070503@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F509402.8070503@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/03/2012 09:33, Stefan Priebe - Profihost AG wrote:
> Am 02.03.2012 10:24, schrieb John Robinson:
>> On 02/03/2012 09:11, Stefan Priebe - Profihost AG wrote:
[...]
>>> No partition table on sda / sdb. Partition table is on md127. This
>>> scenario works fine with metadata 0.9. And as far as i understand it
>>> should work with 1.2 too.
>>
>> No, I don't think it should - 1.2's metadata is offset 4K into the
>> component devices and the data starts later, at 1M or so. That means
>> that the BIOS can't find the partition table where it expects to. Using
>> 1.0, which has its data right at the beginning and metadata at the end,
>> might work if 0.90 does. It's still not 100% because a UEFI BIOS isn't
>> going to find the backup GPT partition table where it ought to.
>
> Maybe i'm wrong here. But shouldn't this get handled by the raid1x
> module of grub? So grub installs at the bootsector of sda / sdb and then
> reads the correct data? Like it does with 0.9 metadata?

No. When booting with MBR, all that goes in the boot sector is enough to 
load the next stage. That next stage will include the raid1x module. It 
lives in the gap between the MBR and the first partition - with old 
fdisk, that was 31K, with more recent fdisk it's 1MB. With no partition 
table on the drives and 1.2 metadata, there's only 3.5K for it, which 
isn't enough.

When booting with UEFI, that next stage lives in the BIOS boot 
partition; the BIOS ignores the MBR, reads the GPT partition table, 
finds the BIOS boot partition, and runs what's there.

What's actually happening with metadata 0.90 or 1.0, because they have 
their data from the beginning, is that the partition table, GRUB etc 
that you have installed into md127 appears to the BIOS as two drives 
with boot sectors, partition tables, etc, and it then proceeds to boot 
off the first drive. Until grub has loaded, you rely on the fact that 
what you installed inside the RAID-1 is laid out in exactly the way the 
BIOS expects to find it on a single drive.

What you've done with metadata 1.2 is put GRUB in a place that needs 
GRUB to find it.

Cheers,

John.
