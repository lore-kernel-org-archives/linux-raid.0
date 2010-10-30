From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: 3T drives and RAID
Date: Sat, 30 Oct 2010 04:21:16 -0500
Message-ID: <B8.A4.13137.093EBCC4@cdptpa-omtalb.mail.rr.com>
References: <20101030103312.7b5a2107@zealot>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101030103312.7b5a2107@zealot>
Sender: linux-raid-owner@vger.kernel.org
To: 'Johannes Truschnigg' <johannes@truschnigg.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Johannes Truschnigg
> Sent: Saturday, October 30, 2010 3:33 AM
> To: Leslie Rhorer
> Cc: linux-raid@vger.kernel.org
> Subject: Re: 3T drives and RAID
>=20
> Hi Leslie,
>=20
> Please note: I don't have any hands-on experience with drives over 2T=
B
> in size, but I'm interested in the subject as well, and so I will rep=
ly
> with what (I think) I know nonetheless ;)
>=20
> On Fri, 29 Oct 2010 22:36:27 -0500
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
>=20
> > 	WD has finally released a 3T drive employing 4K sectors and
> > Advanced Formatting.  I have some questions about Linux / RAID
> > compatibility.  The compatibility chart says using the drive with
> > Linux requires employing the included HBA.  Is the HBA really
> > required if the system will not be booting from the drive? =A0Why?
>=20
> I don't think that's really the case.

	I didn't see how it would be, myself.  I can understand how it would
be needed in order for the drive to be bootable, since the BIOS can't h=
andle
the drive, but I was scratching my head over why it might be required
otherwise.  I know the ECC and physical layout for drives with 4K secto=
rs is
quite different than that of legacy drive formats, but it seemed to me =
as
long as the OS can properly calculate the sector numbers, the controlle=
r
should be happy.

> The real troublemaker for
> common SOHO computer setups with drives that big are not the hardware=
 or
> the ATA protocol (there's theoretical support for drives as large as =
2
> PetaBytes since ATA-6, aka UDMA/100 for EIDE/PATA drives), but simply
> MBR partitions. So if your goal isn't booting off of an MBR partition
> that's as large as your whole drive (or larger than 2TB, for that
> matter), you shouldn't run in any problems. Using advanced partitioni=
ng
> schemes (like GPT) or LVM on GNU/Linux, for example, should be able t=
o
> deal with partition size above 2TB perfectly well.

	I won't be partitioning, at all.  The file system (XFS) is written
directly to the raw array, and the array is assembled from raw drives. =
 I
have relatively small (500G) drives for booting, partitioned into /, /b=
oot,
and swap, but the data is all kept on a single file system formatted on=
 a
simple RAID6 volume.

> > What is the minimum kernel version required? =A0I am wanting to use
> > these on a RAID6 array with no drive partitioning underneath the
> > array (raw disks) using md / mdadm. =A0I'm using a pair of PM based
> > eSATA RAID enclosures to house the drives, so if I need to replace =
my
> > adapters, the replacements will need to have eSATA ports (at least =
4
> > per card) compatible with PM enclosures, which the included HBAs do
> > not have.  I'm not sure if the little Sil3124 adapters I currently
> > have will fill the bill.  Performance is not a big issue.
>=20
> I don't think you'll run into problems with that kind of setup, eithe=
r.
> Support for SATA Port Multipliers are a matter of the controller and =
its
> driver (check libata docs if your combination is supported - if memor=
y
> serves, Sil3xxx _do_ support PMs), and as I said before, the ATA

	Yes, they do.  That's really not the question.  I know my Sil3124
adapters support PMs: I'm using them right now.

> standard - and therefore, compliant devices - should cope with drives=
 >
> 2TB quite well. Your enclosures presumably are dumb devices anyway,
> and don't contain any ICs or logic that would interfere with the data=
 on
> the link between the HBA's SATA port and your drives.

	Well, they have Port Multipliers, but the PMs should not care about
the drive format.  I didn't think the SATA controller would, eitehr, bu=
t I
wasn't certain.

> > 	In addition, I am going to need to add capacity to my existing
> > arrays well before I have the money to replace them completely with=
 3T
> > drives.  I'm going to need six 3T drives per array to completely
> > replace the 1T and 1.5T drives currently in use.  In the mean time,=
 I
> > could upgrade the existing arrays with 1T and 1.5T drives, but that
> > money would be more or less wasted when the drives are replaced in =
a
> > few months.  I would much rather buy a couple of 3T drives and move
> > them over to the new array when it gets built.  Will there be an
> > issue with attempting to add a 4K sector drive to a RAID6 array bui=
lt
> > out of 512 byte sectors?
>=20
> I don't think so, since you can treat "Advanced Format" drives as
> though as they were 512b sector drives, with the drawback of severly
> degraded write performance. With md's common values for chunk-size (6=
4k
> and more), you should have no problems like the hugely increased writ=
e
> penalty you get when incorrectly aligning your writes so they don't
> take care of sector boundaries. If you're not using partitions but
> whole drives as the building blocks of your array anyway, and your ch=
unk
> size is an integer multiple of the drives' 4k sector size, you should=
 be
> fine.

	Md will automatically treat the oddball drive as if it had .5K
sectors, or does one need to tell ma (or the kernel) to do so?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
