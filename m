From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 17:15:12 +0100
Message-ID: <87r5ojon3j.fsf@frosties.localdomain>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
	<yq1bpfnga3l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1bpfnga3l.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Wed, 17 Feb 2010 10:23:10 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Kristleifur" =3D=3D Kristleifur Da=C3=B0ason <kristleifur@gmail=
=2Ecom> writes:
>
> Kristleifur> Starting on sector 64 feels conceptually "prettier" than
> Kristleifur> Sector 63, but I can't picture the case where it behaves
> Kristleifur> any different. Except perhaps when GRUB expects stuff to
> Kristleifur> begin at sector 63, making a mess if we're starting at
> Kristleifur> sector 64. Though it *should* work OK, of course.
>
> The alignment only matters if your underlying storage is using a bloc=
k
> size bigger than 512 bytes internally.  Common examples of that would=
 be
> one of the new SATA drives with 4KB physical blocks or a hardware RAI=
D
> device.

Or disks (flash, SSD, ...) with 64k erase block size.

Newer windows starts the first partition at 1M, which gives good
alignment in nearly every situation. Raids usualy have a chunk size
between 4k and 1M so they align too.

=46or grub(2) it can make a difference to start the first partition lat=
er
as it then has more space for its second stage.

MfG
        Goswin

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
