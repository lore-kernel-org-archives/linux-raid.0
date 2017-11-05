From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID header in XFS area?
Date: Sun, 5 Nov 2017 09:16:11 +0000
Message-ID: <59FED6DB.9040303@youngman.org.uk>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
 <CAGRSmLuoauKaSZ5Z73+Tg19e_1q9Tc-A0ZjqMgr4Lv9Tfer6QQ@mail.gmail.com>
 <5cffac57-7e37-b8cb-ee77-cb9cb6c0f616@youngman.org.uk>
 <CAGRSmLvou+yEb2VLJoounbuiEdfrPSEC+8xBtdp9nfOpj8y-8Q@mail.gmail.com>
 <CAGRSmLuBEUynKNirFi9FuoJz82F4hDimmJWZSSfpQhoOi_9Rog@mail.gmail.com>
 <CAGRSmLtSLQzL01EEnGnafbnTYeC55aK1UEcJBfazoCgTsFXcXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLtSLQzL01EEnGnafbnTYeC55aK1UEcJBfazoCgTsFXcXw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/11/17 02:12, David F. wrote:
> gmail started doing private replies for some reason..
> 
> Anyway, looking deeper found it.  That partition xfs information was
> old left over items.  Searching for another header was found further
> up, at byte offset 22000h (sector 110h), and looking at the RAID
> header area, found bytes for 110h which must be a pointer to to where
> the data starts (don't have the mdadm struct available).   Does anyone
> have the RAID structure available using signature A92B4EFCh ?
> 
> So the old XFS information was confusing the whole situation.
> 
No surprise. Old data does that :-( Why I always prefer "dd if=/dev/zero
of=/dev/sdx" to clear a device. It just takes so long ...

What really worried me was if they'd created the array over the
partitions, then accidentally created XFS on the partitions. That would
have crashed at the first reboot, but there's a good chance that if they
didn't reboot it would have run and run until ...

If you want the raid structure, download mdadm and read the source. I'll
probably document it on the wiki, but I need to read and understand the
source first, too.

As for accessing the data, md2 and md/2 are the same thing :-) Raid is
moving to named arrays rather than default numbers. Can they run a fsck
equivalent over the filesystem? Read-only of course, just to see whether
it's minimally damaged or there's something more seriously wrong.

Cheers,
Wol
> 
> On Sat, Nov 4, 2017 at 6:58 PM, David F. <df7729@gmail.com> wrote:
>> Oh shoot, forgot to mention.  The customer did the mdadm --run --force
>> /dev/md2 (or may have been /dev/md/2) but when trying to access it
>> read errors. ?
>>
>> On Sat, Nov 4, 2017 at 6:55 PM, David F. <df7729@gmail.com> wrote:
>>> That's what I would expect, which is why it's weird that that
>>> signature for metadata 1.2 was 4K within the XFS partition itself (the
>>> XFS partition started after a bunch of other partitions at LBA 6474176
>>> and the xfs superblock is there (the RAID data is at LBA 6474184).
>>> The information in that report also show that when it looked at
>>> /dev/sdb4 it found metadata 1.2 ?? I'll see if there is another xfs
>>> header after that location.
>>>
>>> ARRAY /dev/md0 UUID=06ba2d0c:8282ab7e:3b6d8c49:0838e6b9
>>> ARRAY /dev/md1 UUID=5972f4e9:22fa2576:3b6d8c49:0838e6b9
>>> ARRAY /dev/md3 UUID=f18a5702:7247eda1:3b6d8c49:0838e6b9
>>> ARRAY /dev/md/2  metadata=1.2 UUID=38c9c38c:589967cd:80324986:f1f5e32a
>>> name=MyBook:2
>>>

