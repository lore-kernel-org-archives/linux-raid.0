From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10 failure(s)
Date: Tue, 15 Feb 2011 10:20:07 +1100
Message-ID: <20110215102007.0851f3b8@notabene.brown>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
	<AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
	<20110215094802.44d99c58@notabene.brown>
	<AANLkTimk-Z2EqaOFM87zgQEvBPE6H0wS9_acp83Gc4+5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimk-Z2EqaOFM87zgQEvBPE6H0wS9_acp83Gc4+5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <grimm26@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 17:08:45 -0600 Mark Keisler <grimm26@gmail.com> wro=
te:

> On Mon, Feb 14, 2011 at 4:48 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 14 Feb 2011 14:33:03 -0600 Mark Keisler <grimm26@gmail.com>=
 wrote:
> >
> >> Sorry for the double-post on the original.
> >> I realize that I also left out the fact that I rebooted since driv=
e 0
> >> also reported a fault and mdadm won't start the array at all. =A0I=
'm not
> >> sure how to tell which members were the in two RAID0 groups. =A0I =
would
> >> think that if I have a RAID0 pair left from the RAID10, I should b=
e
> >> able to recover somehow. =A0Not sure if that was drive 0 and 2, 1 =
and 3
> >> or 0 and 1, 2 and 3.
> >>
> >> Anyway, the drives do still show the correct array UUID when queri=
ed
> >> with mdadm -E, but they disagree about the state of the array:
> >> # mdadm -E /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 | grep 'Array S=
tate'
> >> =A0 =A0Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
> >> =A0 =A0Array State : .AAA ('A' =3D=3D active, '.' =3D=3D missing)
> >> =A0 =A0Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)
> >> =A0 =A0Array State : ..AA ('A' =3D=3D active, '.' =3D=3D missing)
> >>
> >> sdc still shows a recovery offset, too:
> >>
> >> /dev/sdb1:
> >> =A0 =A0 Data Offset : 2048 sectors
> >> =A0 =A0Super Offset : 8 sectors
> >> /dev/sdc1:
> >> =A0 =A0 Data Offset : 2048 sectors
> >> =A0 =A0Super Offset : 8 sectors
> >> Recovery Offset : 2 sectors
> >> /dev/sdd1:
> >> =A0 =A0 Data Offset : 2048 sectors
> >> =A0 =A0Super Offset : 8 sectors
> >> /dev/sde1:
> >> =A0 =A0 Data Offset : 2048 sectors
> >> =A0 =A0Super Offset : 8 sectors
> >>
> >> I did some searching on the "READ FPDMA QUEUED" error message that=
 my
> >> drive was reporting and have found that there seems to be a
> >> correlation between that and having AHCI (NCQ in particular) enabl=
ed.
> >> I've now set my BIOS back to Native IDE (which was the default any=
way)
> >> instead of AHCI for the SATA setting. =A0I'm hoping that was the i=
ssue.
> >>
> >> Still wondering if there is some magic to be done to get at my dat=
a again :)
> >
> > No need for magic here .. but you better stand back, as
> > =A0I'm going to try ... Science.
> > (or is that Engineering...)
> >
> > =A0mdadm -S /dev/md0
> > =A0mdadm -C /dev/md0 -l10 -n4 -c256 missing /dev/sdc1 /dev/sdd1 /de=
v/sde1
> > =A0mdadm --wait /dev/md0
> > =A0mdadm /dev/md0 --add /dev/sdb1
> >
> > (but be really sure that the devices really are working before you =
try this).
> >
> > BTW, for a near=3D2, Raid-disks=3D4 arrangement, the first and seco=
nd devices
> > contain the same data, and the third and fourth devices also contai=
ner the
> > same data as each other (but obviously different to the first and s=
econd).
> >
> > NeilBrown
> >
> >
> Ah, that's the kind of info that I was looking for.  So, the third an=
d
> fourth disks are a complete RAID0 set and the entire RAID10 should be
> able to rebuild from them if I replace the first two disks with new
> ones (hence being sure the devices are working)?  Or I need to hope
> the originals will hold up to a rebuild?

No.

third and fourth are like a RAID1 set, not a RAID0 set.

=46irst and second are a RAID1 pair.  Third and fourth are a RAID1 pair=
=2E

=46irst and third
first and fourth
second and third
second and fourth

can each be seen as a RAID0 pair which container all of the data.

NeilBrown



>=20
> Thanks for the info, Neil, and all your work in FOSS :)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
