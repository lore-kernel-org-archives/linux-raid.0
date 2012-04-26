From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Wed, 25 Apr 2012 22:37:50 -0400
Message-ID: <4F98B4FE.5010101@tmr.com>
References: <4F905F66.6070803@tmr.com> <20369.29756.761374.308057@quad.stoffel.home> <4F918F5C.2000607@anonymous.org.uk> <CAK2H+efwgznsS4==Rrtm6UE=uOb25-Q0Qm84i8yAJEJJ2JLdgg@mail.gmail.com> <4F9450D1.40305@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9450D1.40305@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> On 20/04/2012 17:50, Mark Knecht wrote:
>> On Fri, Apr 20, 2012 at 9:31 AM, John Robinson
>> <john.robinson@anonymous.org.uk> wrote:
> [...]
>>> On small machines (3-6 drives) I will regularly have a RAID-1 /boot, RAID-10
>>> swap and RAID-5 or 6 everything else, done with partitions. I do use LVM too
>>> though - that "everything else" will be LVM over the big RAID.
>>
>> Thanks for the info John. Can you tell me what are the requirements
>> for the RAID-1 /boot? grub2? initrd? BIOS-based RAID? Something else?
>> I'm still just mirroring my boot drives - booting from sda1 but
>> copying everything to /sdb1, sdc1, etc. I think I'd like to go full
>> RAID on /boot if the requirements are too high.
>
> Pretty much any modern distro's installer will do the right thing with whatever
> boot loader it uses. Also, there are so many boot methods - BIOS/MBR, GPT, UEFI
> - that in one short email it's tricky to give advice in one short email. It's
> all out there via Google.
>
> But no, you can do a RAID-1 /boot with LILO or grub, and without BIOS RAID. The
> BIOS will boot off the first available hard drive and doesn't understand md
> RAID. grub doesn't understand md RAID either. You have to make your md RAID-1
> /boot with metadata 1.0 (or 0.90) because they have the data at the beginning so
> when you create a filesystem on the array, each individual component (partition)
> looks like it has a filesystem on it. You install grub (or LILO) onto the MBR
> (or GPT boot partition, which isn't the same as your /boot partition), pointing
> to the partition (not the md array).
>
> grub2 does understand md RAID, but has to be loaded by the BIOS, so there are
> still restrictions.
>
> Without either hardware or BIOS RAID, you can still end up being unable to boot,
> e.g. the BIOS will try to boot from the first hard drive present, but if it has
> bad sectors in the MBR or /boot partition, booting may fail even though there's
> a perfectly good mirror on the second drive, because the BIOS doesn't understand
> RAID. This has happened to me :-(
>
Doesn't need to understand RAID, just be willing to try the next item in the 
boot list on failure. My experience has been that almost every BIOS will try the 
2nd item if the 1st fails totally (ie. drive isn't there). A _good_ BIOS will 
try the next item on sector error in the MBR. After that the BIOS needs to 
understand a lot more to do anything smart after the MBR runs.

I have put MBR and boot partition on a USB thumb drive because the failure rate 
of a R/O flash is lower than rotating devices (in my experience). Use ext2 for 
boot, no journal so the drive works really read-only. Hopefully grub2 mounts the 
boot noatime.



-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
