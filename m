From: Alex Pientka <alex.pientka@gmail.com>
Subject: Re: super slow reshape speed after power failure
Date: Thu, 20 Dec 2012 16:06:05 -0500
Message-ID: <CA+Z7oPiGE+E-jH=uBm5DCxO-vTnjNrW0gYLHnNdfLwExHswdxA@mail.gmail.com>
References: <CA+Z7oPhgrmC+nNxdRXjNPdOTSRbmy_aEYm=m_sO=7H6fBjh3yw@mail.gmail.com>
 <20690.985.485075.572934@tree.ty.sabi.co.UK> <CA+Z7oPgp_fu3sFzJefoTzvd-eQUCv7qqS38ZkHes3EqysuM8Ng@mail.gmail.com>
 <20691.8559.262520.841910@tree.ty.sabi.co.UK> <CA+Z7oPgpkhJFRGwmt7camqeKMYpZVGO1gwX7+-F820+miQzyOQ@mail.gmail.com>
 <CAAMCDeeYTB1jfUoLQzXLG+XP3DR_=M5Jz0_6uozn+BSH9Yw_Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeeYTB1jfUoLQzXLG+XP3DR_=M5Jz0_6uozn+BSH9Yw_Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Peter Grandi <pg@lx.to.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

What kind of promise card and how is it connected to the motherboard?
=> pci-x promise 16300. Currently I have a ticket open with promise
and I have been talking to the developer, who wrote the stex driver.
He says it is a very lightweight driver. I assume it is a firmware
issue on the promise card. If you check the promise release notes they
constantly talk about hitachi 2tb drive issues all related to
performance. My co-worker has 500gb, 750gb and 1000mb drives
connected, which work fast. My 2tb drives are very slow. My writes are
usually around 50mb/s.

And how were the old disk controller connected to the motherboard?
=> abit pro ip35 motherboard; 5 of them connected to the intel on
board controller and one disk was running on a sil sata2 pci-express
1x controller. This was necessary since I was not able to put the boot
drive on the pci express controller.


MB/s------------INTEL-SIL----PROMISE--
Writer Report--------584.91-----51.54---
Re-writer Report-----645.69----126.38---
Random Read Report--4190.72------6.12---
Random Write Report--474.83-----58.54---
Alex


On Thu, Dec 20, 2012 at 3:56 PM, Roger Heflin <rogerheflin@gmail.com> wrote:
> On Thu, Dec 20, 2012 at 1:53 PM, Alex Pientka <alex.pientka@gmail.com> wrote:
>> The six drives have been moved from one system to another system. In
>> the previous system the partition table looked fine and the raid was
>> unbelievable fast. The new system has an older promise raid
>> controller, but way faster hardware. In the raid promise bios I had to
>> present every disk as a jbod device. Now on the linux boot up every
>> drive shows up. I highly doubt that the promise card made any
>> adjustments to the partition table. If that would be so I would assume
>> that the raid wouldn't even assemble since I am pointing to the entire
>> raw disk.
>>
>> It may be good to reassemble the array with '--freeze-reshape'
>> to allow it to resync without interference from reshaping,
>> hopefully faster, and then '--continue' after resyning has
>> ended.
>>> You think the reshape is so slow right now since a reshape and resync are running? Since the entire system crashed I would assume this is a logical conclusion. Is there a way to double check that I am actually doing both currently?!
>>
>> To start the raid I had to run the export command followed by "mdadm
>> -A /dev/md0 /dev /sd[bcdefg] --verbose --backup-file /root/chunk/1"
>> I assume you want me to do a --stop and then "mdadm -A /dev/md0 /dev
>> /sd[bcdefg] --verbose --backup-file /root/chunk/1 --freeze-reshape" ?
>> At that point I should see the rsync running, correct?
>> Alex
>>
>
> What kind of promise card and how is it connected to the motherboard?
>
> And how were the old disk controller connected to the motherboard?
