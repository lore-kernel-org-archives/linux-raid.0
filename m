From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Problem with Dualboot on a LSI 9271-8i Controller
Date: Tue, 08 Oct 2013 20:54:04 +0200
Message-ID: <525454CC.2010704@arcor.de>
References: <4461728.ofzB8jD5W8@techz.gjn.prv> <52534304.8010606@hardwarefreak.com> <1692827.Iklf2kLWDY@techz.gjn.prv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1692827.Iklf2kLWDY@techz.gjn.prv>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=22G=FCnther_J=2E_Niederwimmer=22?= <gjn@gjn.priv.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/08/2013 08:39 AM, G=FCnther J. Niederwimmer wrote:
> Am Montag, 7. Oktober 2013, 18:25:56 schrieb Stan Hoeppner:
>> On 10/7/2013 6:58 AM, G=FCnther J. Niederwimmer wrote:
>>> The System is a Asus W9D WS with a LSI Raid Controller.
>>
>> ...
>>
>>> 2 x Raid1 SSD's with 256GB
>>>
>>> On the first Raid1 is windows installed (UEFI) and on the second Ra=
id1 is
>>> Linux (oSUSE) installed (UEFI)
>>>
>>> When I install the system and make the 1. REBOOT all is correct oSU=
SE is
>>> booting again, all works correct.
>>>
>>> But after a shutdown only windows is booting again, oSUSE tell me
>>>
>>> Initrd is loading but it is hang.
>>>
>>> Sometime 1-3 Days oSUSE is booting?
>>
>> ...
>>
>>> This is always on different Systems with the same LSI Controller.
>>
>> Does this mean you have multiple computers all identical, all with t=
his
>> controller, all dual booting Windows and Linux?  This is a strange
>> setup.  Why do you do this?
>=20
> NO ;)
>=20
> This is the system from a friend an I change only the Motherboard for=
 Tests
>=20
>=20
>>> Have I configure the Raid Controller wrong, or is this Controller b=
roken,
>>> or have Grun2-efi Problem with this Controller ....
>>
>> Would you find it surprising that LSI never considered this $600
>> Enterprise 8 port RAID controller would be used in a dual boot
>> workstation role, with 4 SSDs in two RAID1 sets?
>>
>> My guess is that this is a Grub2 issue and it's having trouble seein=
g
>> both disk devices as enumerated by the UEFI implementation.
>>
>> What happens when you create a 4 SSD RAID10 and partition the result=
ing
>> single disk device into two equal halves, one partition for SuSE and=
 one
>> for Windows?  With everything on one disk device this should work mu=
ch
>> more reliably.
>=20
> But why it is booting same times (?) and only stop booting on a shutd=
own ?

I suppose with "shutdown" you mean "power off"? Does this happen if you
shut down from Linux, Windows, or both? What if you reset the system
again after the shutdown? What if you do a warm reboot from Windows?
What exactly are the messages you see in the failure case?

To me this looks like a problem either in the BIOS or in the Option ROM
of the LSI controller. Sometimes the BIOS has difficulties with booting
from a secondary disk (although that *should* be history in the times o=
f
UEFI). As Stan suggested, a setup with two partitions on a single RAID
volume may be easier to handle for the BIOS. I might also be interestin=
g
to swap the OSes (Windows on 2nd drive, Linux on the 1st).

It could also be a GRUB2 problem, but GRUB2 essentially just reads
blocks from the disk using UEFI calls, there's really not a lot it can
mess up.

Martin

>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
