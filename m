From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 10:33:54 +0100
Message-ID: <4F509402.8070503@profihost.ag>
References: <4F4C9A11.9060302@profihost.ag>	<4F4F4B1D.4050000@redhat.com>	<4F4F4EB3.6030909@profihost.ag>	<4F4F519E.7040206@redhat.com>	<4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5091BF.1000102@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 02.03.2012 10:24, schrieb John Robinson:
> On 02/03/2012 09:11, Stefan Priebe - Profihost AG wrote:
>> Am 02.03.2012 10:06, schrieb Lars T=C3=A4uber:
>>>> Correct that's why i've also tried to install it on sda / sdb but =
then
>>>> grub complains about not finding any partition table.
>>>
>>> do you have a partition table inside the raid?
>>> This will not work I expect. The kernel might find the partition
>>> table but
>>> grub?
>>>
>>> Or do you have no partition table at all and a filesystem directly =
on
>>> the
>>> raid device?
>>
>> No partition table on sda / sdb. Partition table is on md127. This
>> scenario works fine with metadata 0.9. And as far as i understand it
>> should work with 1.2 too.
>=20
> No, I don't think it should - 1.2's metadata is offset 4K into the
> component devices and the data starts later, at 1M or so. That means
> that the BIOS can't find the partition table where it expects to. Usi=
ng
> 1.0, which has its data right at the beginning and metadata at the en=
d,
> might work if 0.90 does. It's still not 100% because a UEFI BIOS isn'=
t
> going to find the backup GPT partition table where it ought to.

Maybe i'm wrong here. But shouldn't this get handled by the raid1x
module of grub? So grub installs at the bootsector of sda / sdb and the=
n
reads the correct data? Like it does with 0.9 metadata?

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
