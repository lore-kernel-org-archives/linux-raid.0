From: Alex Pientka <alex.pientka@gmail.com>
Subject: Re: super slow reshape speed after power failure
Date: Thu, 20 Dec 2012 21:35:12 -0500
Message-ID: <CA+Z7oPhsUiRmLKPo-ML37i1t=g60i3nROwNC5ZsN3vFEXskCog@mail.gmail.com>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
 <20690.985.485075.572934@tree.ty.sabi.co.UK> <CA+Z7oPgp_fu3sFzJefoTzvd-eQUCv7qqS38ZkHes3EqysuM8Ng@mail.gmail.com>
 <20691.8559.262520.841910@tree.ty.sabi.co.UK> <CA+Z7oPgpkhJFRGwmt7camqeKMYpZVGO1gwX7+-F820+miQzyOQ@mail.gmail.com>
 <CAAMCDeeYTB1jfUoLQzXLG+XP3DR_=M5Jz0_6uozn+BSH9Yw_Fg@mail.gmail.com>
 <CA+Z7oPiGE+E-jH=uBm5DCxO-vTnjNrW0gYLHnNdfLwExHswdxA@mail.gmail.com> <CAAMCDefZGejefPeOxEVuA8VxejwH-b7zELFXaULSxk2GObFOpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefZGejefPeOxEVuA8VxejwH-b7zELFXaULSxk2GObFOpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Peter Grandi <pg@lx.to.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

50mb/s

but now it's even worse. i rebooted and now i get this

21:34:12^root@datastorm:~/chunk > mdadm -A /dev/md0 /dev/sd[bcdefg]
--backup-file=/root/chunk/1
mdadm: Failed to restore critical section for reshape, sorry.

any ideas to force it?
Alex


On Thu, Dec 20, 2012 at 9:01 PM, Roger Heflin <rogerheflin@gmail.com> wrote:
> On Thu, Dec 20, 2012 at 3:06 PM, Alex Pientka <alex.pientka@gmail.com> wrote:
>> What kind of promise card and how is it connected to the motherboard?
>> => pci-x promise 16300. Currently I have a ticket open with promise
>> and I have been talking to the developer, who wrote the stex driver.
>> He says it is a very lightweight driver. I assume it is a firmware
>> issue on the promise card. If you check the promise release notes they
>> constantly talk about hitachi 2tb drive issues all related to
>> performance. My co-worker has 500gb, 750gb and 1000mb drives
>> connected, which work fast. My 2tb drives are very slow. My writes are
>> usually around 50mb/s.
>>
>> And how were the old disk controller connected to the motherboard?
>> => abit pro ip35 motherboard; 5 of them connected to the intel on
>> board controller and one disk was running on a sil sata2 pci-express
>> 1x controller. This was necessary since I was not able to put the boot
>> drive on the pci express controller.
>>
>>
>> MB/s------------INTEL-SIL----PROMISE--
>> Writer Report--------584.91-----51.54---
>> Re-writer Report-----645.69----126.38---
>> Random Read Report--4190.72------6.12---
>> Random Write Report--474.83-----58.54---
>> Alex
>>
>>
>
> And the pci-x slot that it is in should be at least running at 66mhzx64bit so
> should be able to do 500mb/second or so.
>
> I would do separate "dd if=/dev/<diskname> of=/dev/null bs=1M count=1000" on
> the disks and see if that even gets good speed.
>
> If that gets good speed do all disks at once and see how fast they all
> are at the same time,
> "vmstat 1" (bi) will tell you how fast the whole group is running at
> the same time.
