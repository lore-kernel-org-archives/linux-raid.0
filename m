From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 13:45:59 +0000
Message-ID: <4F50CF17.5060503@anonymous.org.uk>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk> <4F509402.8070503@profihost.ag> <4F50ABA3.1070603@anonymous.org.uk> <4F50C7DC.3000700@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F50C7DC.3000700@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/03/2012 13:15, Stefan Priebe - Profihost AG wrote:
>> No. When booting with MBR, all that goes in the boot sector is enough to
>> load the next stage. That next stage will include the raid1x module. It
>> lives in the gap between the MBR and the first partition - with old
>> fdisk, that was 31K, with more recent fdisk it's 1MB. With no partition
>> table on the drives and 1.2 metadata, there's only 3.5K for it, which
>> isn't enough.
> But that's why i've a BIOS_GRUB partition on the raid and so also on the
> disk.

No, you don't have a BIOS_GRUB partition also on the disk. When you 
partition an array, the partition table goes inside the data area of the 
array.

> Shouldn't it be the same size for 0.9 which starts at the
> beginning, too?

With 0.9 or 1.0, because the data area is at the start of the array, and 
therefore at the start of the disc when you create an array over the 
whole disc, all the boot stuff is visible to the BIOS because it's in 
the same place as it would be on a bare drive.

>> What's actually happening with metadata 0.90 or 1.0, because they have
>> their data from the beginning, is that the partition table, GRUB etc
>> that you have installed into md127 appears to the BIOS as two drives
>> with boot sectors, partition tables, etc, and it then proceeds to boot
>> off the first drive.
> So the bios needs to read the partition table? I thought the MBR would
> be enough.

If you're booting with MBR (traditional BIOS), the MBR plus the gap 
before the first partition is enough.

If you're booting with UEFI (modern BIOS), the MBR is totally irrelevant 
and the BIOS has to read the GPT partition table to find the BIOS_GRUB 
partition.

If we're going to go any further than this, please can you indicate 
which you are using?

>
>> Until grub has loaded, you rely on the fact that
>> what you installed inside the RAID-1 is laid out in exactly the way the
>> BIOS expects to find it on a single drive.
>>
>> What you've done with metadata 1.2 is put GRUB in a place that needs
>> GRUB to find it.
> With metadata 0.9 i can install grub on sda and sdb even when there's no
> part. table.

No, you can't; installing on sda and sdb overwrites the beginning of the 
array, and vice versa; you aren't installing it twice. grub-probe or 
grub-install understands this, which is why it works.

> But with 1.2 grub says it cannot find a partition table so it cannot
> install . So it seems to be a grub bug? grub-probe correctly dectecs a
> 1.2 metadata md raid on the disks but then still doesn't want to install
> with the no partition table message.

It's not a grub bug. It's not a bug at all. When you create a 1.2 array, 
the data area is 1MB into the component devices, and when you partition 
the array, that's where its partition table goes. grub-probe looks for 
what the BIOS will see, and the BIOS will not see the partition table 
because it's not at the start of the component devices, it's 1MB in.

One way to make this work is: partition your discs (either MBR with a 
data partition starting 1M into the disc and spanning the rest of the 
disc, or UEFI with a BIOS_GRUB partition from as early as it'll let you 
up to 1M and a data partition from 1M and spanning the rest of the 
disc). You will need to do this for all your discs separately. Then 
create an array with any metadata and of any type supported by grub on 
the data partitions. The array need not be partitioned, but you want 
separate /boot, swap and root, so partition it. Then install grub and it 
will work it out.

Alternatively, partition all your discs as you previously partitioned 
your array. Create 3 arrays of any metadata and type, the first being 
for /boot, which must be of a metadata and type supported by grub. 
Install grub and it will work it out.

Cheers,

John.
