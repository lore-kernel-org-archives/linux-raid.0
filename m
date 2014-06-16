From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Mon, 16 Jun 2014 16:13:08 -0400
Message-ID: <539F4FD4.9070504@turmel.org>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com> <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com> <539EFF1C.3000009@turmel.org> <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TnVubyBNYWdhbGjDo2Vz?= <nunomagalhaes@eu.ipp.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/16/2014 12:14 PM, Nuno Magalh=C3=A3es wrote:
> Thanks for the tips.

> Back to a previous question (assuming i have the drives sorted out fi=
rst):
>=20
> If i create a RAID10 with 3 1TB drives, with --layout=3Df2, would thi=
s
> give me 2TB of space +1TB redundancy? Is this a 1E?
> Using: mdadm --create /dev/md0 --verbose --chunk=3D128 --level=3D10
> --layout=3Df2 --raid-devices=3D3 /dev/sd[abd]1

No, you'll have 1.5T of available space mirrored by halves.

> If so, what would be the difference to a RAID5:
> mdadm --create /dev/md0 --verbose --chunk=3D512 --level=3D5
> --raid-devices=3D3 /dev/sd[abd]1
>=20
> Besides one having redundancy and the other having parity; and that
> RAID5 must compute parity (is that really so horrendously slow
> nowadays?).

You can't fit the redundancy for 2T of data into 1T without some form o=
f
parity raid.

> Other than tiobench, any other benchmarking tools you guys recommend?
> (I've decided to just go slow and test every layer out before moving
> to the next, i.e. 1st RAID, LVM, FSs, Xen, apps.)

I'll leave that one for others. . .  Just don't expect dd to be very us=
eful.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
