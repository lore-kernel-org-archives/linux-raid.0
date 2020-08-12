From: Vojtech Myslivec <vojtech@xmyslivec.cz>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Wed, 12 Aug 2020 16:19:31 +0200
Message-ID: <442d5127-11f0-80ca-5914-1a561bb2c292@xmyslivec.cz>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
 <CAJCQCtQAHr91wEwvFmh_-UB3Cd3UecSjjy6w7nOeqUktrn4UzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------57103BF7AD3DB5087083F2D0"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQAHr91wEwvFmh_-UB3Cd3UecSjjy6w7nOeqUktrn4UzQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Linux-RAID <linux-raid@vger.kernel.org>, Michal Moravec <michal.moravec@logicworks.cz>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------57103BF7AD3DB5087083F2D0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit



On 29. 07. 20 23:48, Chris Murphy wrote:
> On Wed, Jul 29, 2020 at 3:06 PM Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com> wrote:
>> On 7/22/20 10:47 PM, Vojtech Myslivec wrote:
>>> 1. What should be the cause of this problem?
>>
>> Just a quick glance based on the stacks which you attached, I guess it
>> could be
>> a deadlock issue of raid5 cache super write.
>>
>> Maybe the commit 8e018c21da3f ("raid5-cache: fix a deadlock in superblock>> write") didn't fix the problem completely.  Cc Song.
> 
> That references discards, and it make me relook at mdadm -D which
> shows a journal device:
> 
>        0     253        2        -      journal   /dev/dm-2
> 
> Vojtech, can you confirm this device is an SSD? There are a couple
> SSDs that show up in the dmesg if I recall correctly.

I tried to explain this in my first post. It's logical volume in a
volume group over RAID 1 over 2 SSDs.

My colleague replied to with more details:

On 05. 08. 2020 Michal Moravec wrote:
>> On 29 Jul 2020, Chris Murphy wrote:
>> Vojtech, can you confirm this device is an SSD? There are a couple
>> SSDs that show up in the dmesg if I recall correctly.
>
> Yes. We have a pair (sdg, sdh) of INTEL D3-S4610 240 GB SSDs
> (SSDSC2KG240G8).
> We use them for OS and the raid6 journal.
> They are configured as raid md0 array with LVM on top of it.
> Logical volume vg0-journal_md1 (of 1G size) is used as journal device
> for md1 array (where are problem with proccess md1_raid6 consuming
> 100%
> CPU and blocking btrfs operation is happening)


>> What is the default discard hinting for this SSD when it's used as
>> a journal device for mdadm?
>
> What do you mean by discard hinting?
> We have a issue_discards = 1 configuration in /etc/lvm/lvm.conf


>> And what is the write behavior of the journal?
>
> That would be journal_mode set to write-through, right?


>> I'm not familiar with this feature at all, whether it's treated as a
>> raw block device for the journal or if the journal resides on a file
>> system.
>
> From lsblk output I see no filesystem on vg0-journal_md1. It looks
> like plain logical volume to me.

[my comment]: yes, it's LV block device, no filesystem here.


>> So I get kinda curious what might happen long term if this is a very
>> busy file system, very busy raid5/6 journal on this SSD, without any
>> discard hints?
>> Is it possible the SSD runs out of ready-to-write erase blocks, and
>> the firmware has become super slow doing erasure/garbage collection
>> on demand?
>> And the journal is now having a hard time flushing?
>
> What kind of information could we gather to verify/reject any of these
> ideas?


[my question]: Is LVM configuration (above) enough? Sadly, there are not
much information about RAID 6 journaling at kernel wiki. There are some
info in mdadm(8), but nothing about discards/trim operation.

--------------57103BF7AD3DB5087083F2D0
Content-Type: text/plain; charset=UTF-8;
 name="lsblk-output.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsblk-output.txt"

TkFNRSAgICAgICAgICAgICAgICAgIE1BSjpNSU4gUk0gICBTSVpFIFJPIFRZUEUgIE1PVU5U
UE9JTlQKc2RnICAgICAgICAgICAgICAgICAgICAgODo5NiAgIDEgMjIzLDZHICAwIGRpc2sg
IArilJzilIBzZGcxICAgICAgICAgICAgICAgICAgODo5NyAgIDEgIDM3LDNHICAwIHBhcnQg
IArilIIg4pSU4pSAbWQwICAgICAgICAgICAgICAgICA5OjAgICAgMCAgMzcsMkcgIDAgcmFp
ZDEgCuKUgiAgIOKUnOKUgHZnMC1zd2FwICAgICAgICAyNTM6MCAgICAwICAgMyw3RyAgMCBs
dm0gICBbU1dBUF0K4pSCICAg4pSc4pSAdmcwLXJvb3QgICAgICAgIDI1MzoxICAgIDAgIDE0
LDlHICAwIGx2bSAgIC8K4pSCICAg4pSU4pSAdmcwLWpvdXJuYWxfbWQxIDI1MzoyICAgIDAg
ICAgIDFHICAwIGx2bSAgIArilIIgICAgIOKUlOKUgG1kMSAgICAgICAgICAgICA5OjEgICAg
MCAgMjksMVQgIDAgcmFpZDYgL21udC9kYXRhCuKUnOKUgHNkZzIgICAgICAgICAgICAgICAg
ICA4Ojk4ICAgMSAgICAgMUsgIDAgcGFydCAgCuKUlOKUgHNkZzUgICAgICAgICAgICAgICAg
ICA4OjEwMSAgMSAxODYsM0cgIDAgcGFydCAgCnNkaCAgICAgICAgICAgICAgICAgICAgIDg6
MTEyICAxIDIyMyw2RyAgMCBkaXNrICAK4pSc4pSAc2RoMSAgICAgICAgICAgICAgICAgIDg6
MTEzICAxICAzNywzRyAgMCBwYXJ0ICAK4pSCIOKUlOKUgG1kMCAgICAgICAgICAgICAgICAg
OTowICAgIDAgIDM3LDJHICAwIHJhaWQxIArilIIgICDilJzilIB2ZzAtc3dhcCAgICAgICAg
MjUzOjAgICAgMCAgIDMsN0cgIDAgbHZtICAgW1NXQVBdCuKUgiAgIOKUnOKUgHZnMC1yb290
ICAgICAgICAyNTM6MSAgICAwICAxNCw5RyAgMCBsdm0gICAvCuKUgiAgIOKUlOKUgHZnMC1q
b3VybmFsX21kMSAyNTM6MiAgICAwICAgICAxRyAgMCBsdm0gICAK4pSCICAgICDilJTilIBt
ZDEgICAgICAgICAgICAgOToxICAgIDAgIDI5LDFUICAwIHJhaWQ2IC9tbnQvZGF0YQrilJzi
lIBzZGgyICAgICAgICAgICAgICAgICAgODoxMTQgIDEgICAgIDFLICAwIHBhcnQgIArilJTi
lIBzZGg1ICAgICAgICAgICAgICAgICAgODoxMTcgIDEgMTg2LDNHICAwIHBhcnQgIAo=
--------------57103BF7AD3DB5087083F2D0--
