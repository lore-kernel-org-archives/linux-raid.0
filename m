From: Nix <nix@esperi.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Sat, 18 Apr 2020 00:10:05 +0100
Message-ID: <87h7xhemk2.fsf@esperi.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
        <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
        <c6be03e8-7726-f184-7752-b41732a9e015@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c6be03e8-7726-f184-7752-b41732a9e015@peter-speer.de> (Stefanie
        Leisestreichler's message of "Tue, 14 Apr 2020 18:14:00 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc: G <garboge@shaw.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 Apr 2020, Stefanie Leisestreichler outgrape:

> On 14.04.20 18:00, G wrote:
>> Since you are running disks less than 2TB I would suggest a more rudimentary setup using legacy bios booting. This setup will not
>> allow disks greater than 2TB because they would not be partitioned GPT. There would still be an ability to increase total storage
>> using more disks. There would be raid redundancy with the ability for grub to boot off either disk.
>>
>> Two identical partitions on each disk using mbr partition tables.
>
> Thank you for your thoughts and input.
> I would prefer using uefi/gpt in favor of legacy setup even you are
> totally right about the 2TB border.

Agreed. I avoided GPT like the plague for ages (shoddy early-2010s
motherboard firmware), but once I switched to it it was so much easier
to manage than old-style BIOS, and so much easier to deal with when
disaster struck, that I'd never consider going back. Does the BIOS have
anything like an EFI shell? No, no it doesn't. Can you hack your own
device drivers up if need be and throw them into place for more recovery
options? No, no you can't.

Can you play DOOM before the OS starts in your BIOS-based system -- oh
wait, sane people don't do that, do they. But you can't get higher
availability for truly important functions than that!
<https://doomwiki.org/wiki/Doom_UEFI>
