From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 3 Oct 2011 15:29:08 +0100
Message-ID: <CADNH=7HHBaieZMj=a8s45reEwBLKqBVaZFgnVnB_gcX0p4nS-w@mail.gmail.com>
References: <4E89B81D.5000800@yazzy.org>
	<CADNH=7E9n-uj-xNPq-DuYgfJ+Js9b4bWn_QyeDJ8O+ka4GjLiQ@mail.gmail.com>
	<4E89BF73.8020604@yazzy.org>
	<CADNH=7HXvqFVLZQQ7Yrq0STmiZGDVPCMsqv4t9yMRSiFS934XA@mail.gmail.com>
	<4E89C445.1080406@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89C445.1080406@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 October 2011 15:18, Marcin M. Jessa <lists@yazzy.org> wrote:
> On 10/3/11 4:03 PM, Mathias Bur=C3=A9n wrote:
>>
>> On 3 October 2011 14:58, Marcin M. Jessa<lists@yazzy.org> =C2=A0wrot=
e:
>>>
>>> On 10/3/11 3:39 PM, Mathias Bur=C3=A9n wrote:
>>>
>>>> I would run badblocks on the md0 device. (increase number of block=
s to
>>>> check at a time until you use all your available RAM)
>>>> After that I'd run dd.
>>>
>>> Any particular options you would give to dd ?
>>>
>>>> I would also check the SMART data on all
>>>> drives
>>>
>>> What's strange SMART always says all the drives are healthy.
>>> All of failures started with dmesg saying:
>>> =C2=A0exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>> =C2=A0ata9.00: failed command: FLUSH CACHE EXT
>>> =C2=A0ata9.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>> =C2=A0res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> =C2=A0ata9.00: status: { DRDY }
>>>
>>> That "exception Emask" part pointed me to misc threads where people
>>> mentioned bugs in the Linux kernel.
>>>
>>> A reboot would somehow reset the drives and they would always be wo=
rking
>>> fine again and I could always resync the array until the next time =
when a
>>> drive would get kicked off.
>>>
>>>> and the health of the controller.
>>>
>>> How can I run a check on that within Linux?
>>>
>>>
>>>
>>> --
>>>
>>> Marcin M. Jessa
>>>
>>
>> Can you post the smartctl -a -T permissive (etc) output on a pastebi=
n
>> somewhere, for all HDDs?
>
> http://pastebin.com/Tw1ha9hK
>
>>
>> What controller are you using?
>
> I believe it's a AMD=C2=AE SB850 chipset
> The drives are connected to the SATA3 ports on the motherboard.
> I'm not using the built in HW RAID.
> The motherboard: http://www.msi.com/product/mb/870A-G54.html
>
>
>
>
>
> --
>
> Marcin M. Jessa
>

=46rom what I can tell the HDDs themselves seem to be healthy. Perhaps
using the latest kernel is a step in the right direction?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
