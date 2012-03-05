From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Mon, 05 Mar 2012 11:31:54 +0000
Message-ID: <4F54A42A.4020903@anonymous.org.uk>
References: <4F4C9A11.9060302@profihost.ag> <4F4F4B1D.4050000@redhat.com> <4F4F4EB3.6030909@profihost.ag> <4F4F519E.7040206@redhat.com> <4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk> <4F509402.8070503@profihost.ag> <4F50ABA3.1070603@anonymous.org.uk> <4F50C7DC.3000700@profihost.ag> <20120302163236.3555fec1296cbe30d8d37972@bbaw.de> <4F547038.7060009@profihost.ag> <4F54899A.4040301@anonymous.org.uk> <20120305111402.e63fee5b49046ed146cb9dcc@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120305111402.e63fee5b49046ed146cb9dcc@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TGFycyBUw6R1YmVy?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2012 10:14, Lars T=C3=A4uber wrote:
> Hi John,
>
> Am Mon, 05 Mar 2012 09:38:34 +0000
> John Robinson<john.robinson@anonymous.org.uk>  schrieb:
>> On 05/03/2012 07:50, Stefan Priebe - Profihost AG wrote:
>>> Am 02.03.2012 16:32, schrieb Lars T=C3=A4uber:
>>>> Hi Stefan,
>>>>
>>>> the metadata versions 1.0 and 1.1 and 1.2 are the same but for the
>>>> position of the metadata on disk. Simply use metadata version 1.0 =
and
>>>> everything works as with 0.9.
>>>>
>>>> Grub does to read partition tables inside raid devices.
>>
>> Sure it does, but that's not the point.
>
> that's new to me. This is true for grub2 only?
> You mean if Stefan would have used an old fashioned partition table i=
nside a
> Linux SW-RAID with metadata 1.2, grub would have booted like normal?

Yes, both grub2 and grub legacy (0.97) read partition tables. Only grub=
2=20
can really read inside RAID arrays - any metadata, any RAID level -=20
while grub legacy can only read the first drive of RAID-1 with 0.90 or=20
1.0 metadata, and that only because they look like bare drives/partitio=
ns.

>>>> Because a raid1 with metadata 1.0 or 0.9 looks like a plain disk t=
o grub
>>>> it can read a partition table like there was no raid array.
>>
>> For the fourth time, no.
>>
>> Because a RAID1 with metadata 0.9 or 1.0 looks like a plain disc to =
the
>> BIOS, it can read a partition table like there was no RAID array, an=
d
>> therefore the BIOS can load GRUB.
>
> This might be true for UEFI firmware but for the plain old BIOS too?
> I thought the BIOS isn't interested in partitions at all.

That's true, but it is interested in the MBR, sector zero of the drive=20
it's booting from, which is also where the partition table lives, so fo=
r=20
plain old BIOS you have to put the stage 1 boot loader there, which can=
=20
only happen with metadata 0.90 and 1.0 if you use whole-drive arrays.

With plain old BIOS, grub legacy and grub2 also depend on the next 31K=20
of the disc, up to sector 62, being unused, as traditionally the first=20
partition starts at sector 63. (More recent fdisk make it 1023.5K,=20
sector 2047 and sector 2048 respectively). This means you have to have =
a=20
partition table, and though the plain old BIOS doesn't use it, grub=20
does, to find the /boot or / partition to load a kernel from. With grub=
=20
legacy, it has to be an MBR partition table, not one buried inside an=20
array with metadata 1.1 or 1.2.

I suppose you could possibly contrive to have no MBR partition table fo=
r=20
grub2, but you'd still need that space on the drive for the stage 1.5=20
code, which isn't available with a whole-drive metadata 1.2 array=20
(because its metadata starts 4K into the drive, leaving 3.5K after the=20
stage 1 on the MBR), so you do effectively need an MBR partition table=20
to reserve the space.

But you're right, plain old BIOS don't use the MBR partition table, jus=
t=20
the MBR. I was fashioning my sentence after yours, so sorry for any=20
confusion. My point - that it's the BIOS that has to be able to read th=
e=20
array like it was a bare drive, rather than grub - remains.

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
