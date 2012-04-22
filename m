From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Removing a failing drive from multiple arrays
Date: Sun, 22 Apr 2012 19:41:21 +0100
Message-ID: <4F9450D1.40305@anonymous.org.uk>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home> <4F918F5C.2000607@anonymous.org.uk> <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/04/2012 17:50, Mark Knecht wrote:
> On Fri, Apr 20, 2012 at 9:31 AM, John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
[...]
>> On small machines (3-6 drives) I will regularly have a RAID-1 /boot, RAID-10
>> swap and RAID-5 or 6 everything else, done with partitions. I do use LVM too
>> though - that "everything else" will be LVM over the big RAID.
>
> Thanks for the info John. Can you tell me what are the requirements
> for the RAID-1 /boot? grub2? initrd? BIOS-based RAID? Something else?
> I'm still just mirroring my boot drives - booting from sda1 but
> copying everything to /sdb1, sdc1, etc. I think I'd like to go full
> RAID on /boot if the requirements are too high.

Pretty much any modern distro's installer will do the right thing with 
whatever boot loader it uses. Also, there are so many boot methods - 
BIOS/MBR, GPT, UEFI - that in one short email it's tricky to give advice 
in one short email. It's all out there via Google.

But no, you can do a RAID-1 /boot with LILO or grub, and without BIOS 
RAID. The BIOS will boot off the first available hard drive and doesn't 
understand md RAID. grub doesn't understand md RAID either. You have to 
make your md RAID-1 /boot with metadata 1.0 (or 0.90) because they have 
the data at the beginning so when you create a filesystem on the array, 
each individual component (partition) looks like it has a filesystem on 
it. You install grub (or LILO) onto the MBR (or GPT boot partition, 
which isn't the same as your /boot partition), pointing to the partition 
(not the md array).

grub2 does understand md RAID, but has to be loaded by the BIOS, so 
there are still restrictions.

Without either hardware or BIOS RAID, you can still end up being unable 
to boot, e.g. the BIOS will try to boot from the first hard drive 
present, but if it has bad sectors in the MBR or /boot partition, 
booting may fail even though there's a perfectly good mirror on the 
second drive, because the BIOS doesn't understand RAID. This has 
happened to me :-(

Cheers,

John.
