From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Filesystem on RAID5 missing or corrupted after reboot (bad
 superblock error)
Date: Fri, 23 Jan 2009 16:39:54 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901231639290.1866@p34.internal.lan>
References: <497A226D.9030807@mike01.com> <alpine.DEB.1.10.0901231622490.1615@p34.internal.lan> <497A387B.9000300@mike01.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <497A387B.9000300@mike01.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Berger <lists@mike01.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 23 Jan 2009, Mike Berger wrote:

> Justin Piszcz wrote:
>>
>> Hi,
>>
>> If you are using GPT partitions, the kernel will not recognize them
>> after stop/start or a reboot unless you have this option enabled in the
>> kernel:
>>
>> CONFIG_EFI_PARTITION=y
>>
>> Also, why use a GPT partition, do you have individual HDDs over 2TiB?
>> If not, just make a regular partition on each HDD with fdisk and make
>> it type
>> 'fd'?
>>
>> Justin.
> This seems likely to be the problem.
> CONFIG_LBD=y
> CONFIG_EFI=y
> CONFIG_FB_EFI=y
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_EFI_VARS is not set
> # CONFIG_EFI_PARTITION is not set
>
>
> I've got a kernel building now with CONFIG_EFI_PARTITION=y so I will
> know shortly.
>
> My thinking with the GPT partition table was to be more future proof.
> I'm already using 1.5 TiB drives, so it seems likely I would transition
> to 2 TiB or larger drives whenever I replaced these or added to the
> array.  Do you know if using a traditional/msdos partition table now
> would be an issue if I wanted to migrate to larger disks in the future?
>
> Thanks,
> Mike
>

In that case, use GPT.  Who knows, maybe next year there will be > 2T disks
and in that case you need GPT I believe..

Justin.

