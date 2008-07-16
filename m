From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 10:17:12 +0200
Message-ID: <20080716081712.GA9365@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com> <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz> <20080716042336.GB7148@rap.rap.dk> <487D84B6.60908@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487D84B6.60908@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 16, 2008 at 05:18:46PM +1200, Richard Scobie wrote:
> Keld J=F8rn Simonsen wrote:
>=20
> >My understanding tho, is that the IO output and input figures are on
> >sequential IO. There are no figures on random IO,
>=20
> If you look at some results Justin posted:
>=20
> http://home.comcast.net/~jpiszcz/20080707/veliciraptors_with_x4.html
>=20
> The column "Random Create" shows performance for randomly creating,=20
> reading and deleting 16384 files sized between 16bytes and 1MB=20
> distributed randomly through 64 directories (this is the -n parameter=
=20
> and is shown in the "Num Files" column.)

Yes, but these are not random IO in the sense that I meant it, which wa=
s
unclear. These are specific system calls, delete, and seeks, with some =
IO=20
on the inodes and maybe releasing blocks to the empty block list.

I meant to say: There are no tests in bonnie++ that measures random
read and write thruput.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
