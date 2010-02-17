From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 10:23:10 -0500
Message-ID: <yq1bpfnga3l.fsf@sermon.lab.mkp.net>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
	("Kristleifur =?utf-8?Q?Da=C3=B0ason=22's?= message of "Wed, 17 Feb 2010
 15:13:46 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?utf-8?Q?Da=C3=B0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Kristleifur" =3D=3D Kristleifur Da=C3=B0ason <kristleifur@gmail.=
com> writes:

Kristleifur> Starting on sector 64 feels conceptually "prettier" than
Kristleifur> Sector 63, but I can't picture the case where it behaves
Kristleifur> any different. Except perhaps when GRUB expects stuff to
Kristleifur> begin at sector 63, making a mess if we're starting at
Kristleifur> sector 64. Though it *should* work OK, of course.

The alignment only matters if your underlying storage is using a block
size bigger than 512 bytes internally.  Common examples of that would b=
e
one of the new SATA drives with 4KB physical blocks or a hardware RAID
device.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
