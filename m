From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 15:29:06 -0700
Message-ID: <77A2CEA7-2C0F-4253-BCCC-A35C1B6F1A28@colorremedies.com>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51264E26.9050100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Stone <stone@heisl.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Feb 21, 2013, at 9:41 AM, Phil Turmel <philip@turmel.org> wrote:

>> This is my ouput from the badblocks
>=20
>> 1073006628
>> 1073006629
>> 1073006630
>> 1073006631
>> 1073006632
>> 1073006633
>> 1073006634
>> 1073006635
>> 1073006636
>> 1073006637
>> 1073006638
>> 1073006639
>=20
> These 12 are together.  (Three real sectors.)

> dd if=3D/dev/zero bs=3D1024 count=3D12 seek=3D1073006628 of=3D/dev/sd=
c1

Oh I get it. Yeah that works. In this case seek=3D isn't LBA but is a m=
ultiple of 2, same as the block size. NEVERMIND! Ignore the man behind =
the curtain=85.

Nevertheless if there's a backup, I'd nuke these drives with ATA Secure=
 Erase. And definitely schedule regular smart tests to keep an eye on t=
hem. It's a lot of bad sectors on one disk.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
