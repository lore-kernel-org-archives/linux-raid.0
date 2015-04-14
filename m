From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Tue, 14 Apr 2015 08:32:00 -0400
Message-ID: <552D08C0.1010106@turmel.org>
References: <D150B36B.8EE37%marchesseau@gmail.com> <552B0B58.8050102@turmel.org> <D15148A7.3B83B%marchesseau@gmail.com> <552BA12C.3010506@turmel.org> <D1517793.3D82D%marchesseau@gmail.com> <D151DEA1.8EEA1%marchesseau@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D151DEA1.8EEA1%marchesseau@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas MARCHESSEAU <marchesseau@gmail.com>, linux-raid@vger.kernel.org
Cc: Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

Good morning Thomas,

On 04/13/2015 03:29 PM, Thomas MARCHESSEAU wrote:

> Mdadm =E2=80=94-assemble =E2=80=94- force /dev/md1 /dev/sdb =E2=80=A6=
etc=E2=80=A6 /dev/sdh
> And i=E2=80=99ve got a good feedback from de system :
> Mdadm : forcing event count in /dev/sdg from 21954 to 21958
> Mdadm : forcing event count in /dev/sdh from  21954 to 21958
> Mdadm : clearing FAULTY flag for device 5 in /dev/md1 fo dev/sdg
> Mdadm : clearing FAULTY flag for device 6 in /dev/md1 fo dev/sdh
> Mdadm : making array /dev/md1 as =E2=80=98clean=E2=80=99
> Mdadm :/dev/md1 has bee started  with 7 drives
>=20
> =E2=80=94> looks pretty good !
>=20
> Mounting drive , and all seem ok .
> 1 / i=E2=80=99m now BACKUPING the most important stuff .
> 2 / i=E2=80=99ll backup all data
>=20
> -> this will probably require 2 days

Very good to hear this.

> what=E2=80=99s your advice for next step ?
> - remove all md and rewrite a config ?
> - move to raid6 ( is there a way to convert RAID5 to 6 ) (
> http://ewams.net/?date=3D2013/05/02&view=3DConverting_RAID5_to_RAID6_=
in_mdadm
> )=20

Yes, just --add a spare device to the array, then --grow --level=3D6 to
start a live reshape.

> - re install a fresh clean system ?

Not necessary.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
