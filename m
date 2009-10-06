From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 19:50:25 -0500
Message-ID: <20091006005026746.OZOR12917@cdptpa-omta04.mail.rr.com>
References: <c268e4660910051141r125e943csa91dad2ede6d41f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660910051141r125e943csa91dad2ede6d41f5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > necessary, whether the "drive" is a single physical disk or an arra=
y.
>=20
> I did not know that. I always assumed that for physical disks you
> needed a partition of some sort so the filesystem doesn't stomp all
> over the boot sector (where used).

	If the boot sector is not used, though, and there is no swap on the
drive, then partitioning is not absolutely required.  If the MBR is use=
d,
then indeed one must make sure the file system doesn't stomp on it.

> That said I think I'll stick to
> partitioning my boot drive. Feels safer somehow.

	Oh, I agree, without question.  I'm a big fan of a small boot drive
with 3 or 4 partitions and one or more arrays with no partitions at all=
=2E

> >> The filesystem still needs a partition/volume but that can created
> >> either by partitioning /dev/mdX *or* creating a logical volume in =
LVM.
> >
> > =A0 =A0 =A0 =A0It doesn't need a partition, just a block device. =A0=
That device
> can
> > be a partition on a disk, a whole disk, or an array.
>=20
> I forgot you can do that with mdX. It's been a while since I've made
> filesystems (other then boot drives) without LVM.

	Yep.  Sure can.  I've used LVM, and for some applications it's
great.  Indeed, as I mentioned, adfas might be well served with LVM vol=
umes
on each machine.  It certainly would provide great performance, althoug=
h as
I also mentioned, I don't think drive performance is really his problem=
, per
se.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
