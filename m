From: Nix <nix@esperi.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Fri, 24 Apr 2020 21:24:45 +0100
Message-ID: <87ftcsk4xe.fsf@esperi.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
        <f9f2f479-2899-6774-eb20-bf81ed24bc7b@shaw.ca>
        <c6be03e8-7726-f184-7752-b41732a9e015@peter-speer.de>
        <87h7xhemk2.fsf@esperi.org.uk> <87d07wr8z9.fsf@vps.thesusis.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d07wr8z9.fsf@vps.thesusis.net> (Phillip Susi's message of
        "Fri, 24 Apr 2020 15:15:22 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <phill@thesusis.net>
Cc: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, G <garboge@shaw.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 Apr 2020, Phillip Susi stated:

>
> Nix writes:
>
>> Agreed. I avoided GPT like the plague for ages (shoddy early-2010s
>> motherboard firmware), but once I switched to it it was so much easier
>> to manage than old-style BIOS, and so much easier to deal with when
>> disaster struck, that I'd never consider going back. Does the BIOS have
>> anything like an EFI shell? No, no it doesn't. Can you hack your own
>
> My current and previous motherboard with UEFI boot support did not come
> with the shell.  I once tried downloading one and running it but never
> could find anything useful to do with it.

It's mostly useful for emergency recovery, I'll admit :)

>                                            I also haven't ever been able
> to find any useful UEFI drivers or programs.

They are very thin on the ground :( a shame, really: it seems like
something you *should* be able to use to build whole rescue
environments, but nooo. I guess it *is* easier to stick those in an
initramfs linked into a kernel built as an EFI stub, since at least it's
a Linux rather than the rather weird PE-based environment which is EFI.
