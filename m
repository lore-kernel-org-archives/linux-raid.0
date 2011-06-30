From: Phil Turmel <philip@turmel.org>
Subject: Re: misunderstanding of spare and raid devices?
Date: Thu, 30 Jun 2011 08:32:04 -0400
Message-ID: <4E0C6CC4.3030506@turmel.org>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C5E47.5090604@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Karsten,

On 06/30/2011 07:30 AM, John Robinson wrote:
> On 30/06/2011 11:51, Karsten R=C3=B6mke wrote:
>> Hello,
>> I'm searching some hours / minutes to create a raid5 device with 4 d=
isks
>> and 1 spare:
>> I tried first with the opensuse tool but no success as I want, so I
>> tried mdadm
>>
>> Try:
>> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 --spare-devic=
es=3D1
>> /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
>>
>> leads to
>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>> md0 : active (auto-read-only) raid5 sdd5[5](S) sde5[4](S) sdc5[2]
>> sdb2[1] sda3[0]
>> 13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>>
>> 2 spares - I don't understand that.

Just to clarify for you, as your comment below suggests some confusion =
as to the role of a spare:

When the resync finished on this, if you had let it, you would have had=
 three drives' capacity, with parity interspersed, on four drives.  The=
 fifth drive would have been idle, but ready to replace any of the othe=
r four without intervention from you.

>> kspace9:~ # mdadm --create /dev/md0 --level=3D5 --raid-devices=3D4 /=
dev/sda3
>> /dev/sdb2 /dev/sdc5 /dev/sdd5
>> leads to
>> md0 : active (auto-read-only) raid5 sdd5[4](S) sdc5[2] sdb2[1] sda3[=
0]
>> 13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>>
>> 1 spare - but why - I expect 4 active disks and 1 spare
>>
>> kspace9:~ # mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /=
dev/sda3
>> /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
>> leads to
>> md0 : active (auto-read-only) raid5 sde5[5](S) sdd5[3] sdc5[2] sdb2[=
1]
>> sda3[0]
>> 18345728 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]

This will end up with four drives' capacity, with parity interspersed, =
on five drives.  No spare.

>> That's what I want, but I reached it more or less by random.
>> Where is my "think-error" (in german).

I hope this helps you decide which layout is the one you really want.  =
If you think you want the first layout, you should also consider raid6 =
(dual redundancy).  There's a performance penalty, but your data would =
be significantly safer.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
