From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: A few remaining questions about installing to RAID-10
Date: Mon, 5 Oct 2009 13:13:05 -0500
Message-ID: <20091005181306574.NWBS26368@cdptpa-omta03.mail.rr.com>
References: <c268e4660910050849mc4bba01ifbb1a57caf59c41a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660910050849mc4bba01ifbb1a57caf59c41a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > WAT?! =A0How can I mount an unpartitioned/unformatted array? =A0Thi=
s is more
> direct than using a filesystem, although there would be no journallin=
g,
> right? =A0If I were to mount my small disk for / and the unpartitione=
d array
> as /home for example.
>=20
> What's he's saying is that RAID and LVM do not need partitions to wor=
k
> properly. You can create a raid array on the raw(unpartitioned)
> /dev/sdX devices and then create a LVM volume group using a physical
> volume(PV) on a raw(unpartitioned) /dev/mdX (RAID) device.

	True, but it is simpler than that.  Partitions are not needed in
general unless one needs to create a separate task space on a single dr=
ive
volume.  If one has no swap space, then it is entirely possible to run =
a
Linux system with no partitions at all.  The file system can be created=
 on a
raw disk, and as long as the MBR is good and the boot loader can read t=
he
file system, you're good.  Note I don't genrally recommend running with=
out a
swap space, and going to extra trouble just to prevent partitioning is =
not
very productive, but there is no reason to partition a drive if it is n=
ot
necessary, whether the "drive" is a single physical disk or an array.

> The filesystem still needs a partition/volume but that can created
> either by partitioning /dev/mdX *or* creating a logical volume in LVM=
=2E

	It doesn't need a partition, just a block device.  That device can
be a partition on a disk, a whole disk, or an array.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
