From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Storage device enumeration script
Date: Fri, 27 May 2011 12:42:54 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105271241150.25096@unicorn.drogon.net>
References: <42.A9.00666.D9CEEDD4@cdptpa-omtalb.mail.rr.com>  <4DDEED47.1040809@fnarfbargle.com> <20110527095840.427d90be@natsu>  <alpine.DEB.2.00.1105271142110.25096@unicorn.drogon.net> <1306495608.9437.140.camel@torbjorn>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="180569313-157037677-1306496574=:25096"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1306495608.9437.140.camel@torbjorn>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--180569313-157037677-1306496574=:25096
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 27 May 2011, Torbjørn Skagestad wrote:

> Hi,
>
> Some info can be found here https://github.com/pturmel/lsdrv
>
> The output will typically be like this:

Ok. Intersting, thanks.

I generllyy know what's inside my servers, but I suppose visualising it is 
good, or having to work on someone elses server...

Gordon


>
> Controller platform [None]
> ??platform floppy.0
>    ??fd0: Empty/Unknown 4.00k
> PCI [pata_jmicron] 03:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 02)
> ??scsi 0:x:x:x [Empty]
> ??scsi 2:x:x:x [Empty]
> PCI [ahci] 03:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller (rev 02)
> ??scsi 12:0:0:0 ATA THROTTLE
> ?  ??sdu: Empty/Unknown 7.51g
> ?     ??sdu1: Empty/Unknown 243.00m
> ?     ?  ??Mounted as /dev/sdu1 @ /boot
> ?     ??sdu2: Empty/Unknown 1.00k
> ?     ??sdu5: Empty/Unknown 7.27g
> ?        ??dm-0: Empty/Unknown 6.90g
> ?        ?  ??Mounted as /dev/mapper/server-root @ /
> ?        ??dm-1: Empty/Unknown 368.00m
> ??scsi 13:0:0:0 ATA WDC WD10EACS-00Z
>    ??sdv: Empty/Unknown 931.51g
>       ??md1: Empty/Unknown 3.64t
>          ??dm-3: Empty/Unknown 3.64t
>             ??Mounted as /dev/mapper/big1 @ /mnt/big1
> PCI [pcieport] 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
> ??scsi 15:0:0:0 ATA WDC WD20EARS-00J
> ?  ??sdy: Empty/Unknown 1.82t
> ?     ??sdy1: Empty/Unknown 1.82t
> ?        ??md3: Empty/Unknown 7.28t
> ?           ??dm-5: Empty/Unknown 7.28t
> ?              ??Mounted as /dev/mapper/big3 @ /mnt/big3
> ??scsi 15:0:1:0 ATA WDC WD20EARS-00J
> ?  ??sdz: Empty/Unknown 1.82t
> ?     ??sdz1: Empty/Unknown 1.82t
> ??scsi 15:0:2:0 ATA WDC WD20EARS-00J
> ?  ??sda: Empty/Unknown 1.82t
> ?     ??sda1: Empty/Unknown 1.82t
> ??scsi 15:0:3:0 ATA WDC WD20EARS-00J
> ?  ??sdw: Empty/Unknown 1.82t
> ?     ??sdw1: Empty/Unknown 1.82t
> ??scsi 15:0:4:0 ATA WDC WD20EARS-00J
>    ??sdae: Empty/Unknown 1.82t
>       ??sdae1: Empty/Unknown 1.82t
> ---snip---
>
>
> On Fri, 2011-05-27 at 11:45 +0100, Gordon Henderson wrote:
>> On Fri, 27 May 2011, Roman Mamedov wrote:
>>
>>> On Fri, 27 May 2011 08:16:07 +0800
>>> Brad Campbell <brad@fnarfbargle.com> wrote:
>>>
>>>> On 27/05/11 08:13, Leslie Rhorer wrote:
>>>>>>
>>>>> 	I can't speak to Ubuntu, but Debian evidently does not.  I don't
>>>>> know what "pvs" is, but neither bash nor Python recognize it as a file
>>>>> anywhere in the path.
>>>> apt-get install lvm2.
>>>
>>> Sure, but lsdrv shouldn't assume lvm2 is installed or require it to be
>>> installed. Not everyone uses LVM, and simply installing it automatically adds
>>> things to initramfs (PV/VG/LV detection?), which can slow down boot-up process.
>>
>> As well as not using LVM, some of us don't even use udev... Or kernels
>> with modules...
>>
>> Can someone post the output of this utility so I can see what it's
>> actually doing?
>>
>> (I don't have python on all my servers either)
>>
>> Cheers,
>>
>> Gordon
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -- 
> Torbjørn Skagestad
> Idé Til Produkt AS
> torborn@itpas.no
>
--180569313-157037677-1306496574=:25096--
