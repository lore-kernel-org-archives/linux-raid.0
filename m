From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID5 up, but one drive removed, one says spare building, what
 now?
Date: Fri, 10 Nov 2017 23:17:38 +0000
Message-ID: <5A063392.4060809@youngman.org.uk>
References: <CAA4aoFaEwv=EPcotAbjzkgXWoOFwxo2XAoMzN1Zfb62k4Fngxw@mail.gmail.com>
 <5A058E25.1020608@youngman.org.uk>
 <34b72bc9-9a72-3143-bd1e-d00f90493d04@turmel.org>
 <CAK2H+ec6DxBE_Mxq9skOa3XNGMc2BW8Q4+ieoA13uG+UhE4nZg@mail.gmail.com>
 <CAA4aoFbOnCtj_+qbfuzz7qS6xrt5HB9XJK-E+h0_eEu=vLdftg@mail.gmail.com>
 <3fa05723-8275-8840-7fbc-397801fa17de@turmel.org>
 <0B536D2C-1919-4704-94D3-6EB733B73E9D@gmail.com>
 <8822270a-a88b-fe9a-daae-22df155f5062@turmel.org>
 <66C593A3-D4BD-4B80-AF7D-B1693F8271CA@gmail.com>
 <e23f4047-9e7d-73b5-0dad-81575a04649c@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e23f4047-9e7d-73b5-0dad-81575a04649c@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jun-Kai Teoh <kai.teoh@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/11/17 21:58, Phil Turmel wrote:
>>> But don't add any more complete devices to the array -- use a
>>> >> partition that starts at 1MB and covers the rest of the device
>>> >> (default for most partition tools nowadays).
>> > 
>> > Where can I read about how to do this properly? I tried googling it
>> > but I'm pretty lost. Or what tool I should use etc.
> parted or gdisk or a very modern version of fdisk will let you partition
> your new drives.  They will default to a "GPT" disk label and will
> generally place the first partition you create in the "right" place -- a
> multiple of 4K, typically 1MB.  When you save the new partition table
> (aka disk label), the #1 partition will show up in your list of devices.
> 
>>> >> I recommend that when/if your array is stable again, you add one
>>> >> more spare (with partition) and then use mdadm's --replace
>>> >> operation to move complete-device members to the new member.  When
>>> >> each is done, take the newly freed device and partition it and do
>>> >> the next.  When you have no more complete-device members and have
>>> >> the last freed device partitioned, consider converting to raid6
>>> >> with that spare.
>> > 
>> > I think I understand what you mean here, but it sounds like I need to
>> > figure out the top two parts first and that'll take me awhile.

If you take the wiki slowly, you'll hopefully grasp what's going on.

https://raid.wiki.kernel.org/index.php/Linux_Raid#Overview

Especially the bit about setting up a new system or converting an
existing system. Okay, they're not at all about what you're doing, but
if you work your way through and get what's happening there straight in
your head, you'll then be able to apply it to your setup.

Note that they're written from my perspective as a gentoo user, so I
have to do everything from scratch - boot into a live/rescue CD, and
then configure/setup the system from there.

I know it doesn't cover LVM - that is very patchy at the moment - but I
just need to troubleshoot my new machine to get a bios screen, and I'll
be setting that up with LVM and all that should be appearing on the wiki.

(My new system at the moment isn't even POSTing :-( I'm not used to
troubleshooting builds, I've usually been lucky, so I hope everything is
working soon :-)

Cheers,
Wol
