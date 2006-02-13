From: "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com>
Subject: RE: Question: array locking, possible?
Date: Mon, 13 Feb 2006 09:21:06 -0800
Message-ID: <1C4766A743ADF74FAEDF2AAD0679BAA2076D204C@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Chris Osicki <osk@admin.swisscom-mobile.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand about HP-UX mirroring/LVM.

I was a little too obtuse.

LVM2 has a feature (not well advertised) that allows an VG to be tagged=
 so it will not be activated by "system b" if it is already tagged as b=
eing in use by "system a".  I was suggesting that a similar feature cou=
ld be added to MD.  This way a MD array could be marked as "owned" and,=
 if so, mdadm would not activate it from another system.  This way all =
of the MD control is still within mdadm.

If Neil is interested, I'll try to dig up more info.

Regards,
Rick =20

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Chris Osicki
Sent: Monday, February 13, 2006 9:13 AM
To: linux-raid@vger.kernel.org
Subject: Re: Question: array locking, possible?



Rick

On HP-UX disk mirroring is done in LVM. I'm using md driver for
mirroring and LVM on top of it.  Controlling access to my disks in LVM
is just too late. I would have to assemble the array before I can activ=
ate
VGs. If the array in question is being used on the other host nobody
can guarantee that bad thing wont happen. And what I would like to
prevent is: two hosts accessing (writing) an array.
Thanks anyway for the hint.

Regards,
Chris


On Thu, 9 Feb 2006 10:28:58 -0800
"Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com> wrote:

> There is more interest, just not vocal.
>=20
> May want to look at LVM2 and its ability to use tagging to control en=
ablement of VGs. This way it is not HW dependent.
>=20
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Chris Osicki
> Sent: Thursday, February 09, 2006 2:26 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: Question: array locking, possible?
>=20
>=20
>=20
> It looks like we are the only two md users interested in such a
> feature.
> Not enough to get Neil's attention ;-)
>=20
> Regards,
> Chris
>=20
> On Wed, 8 Feb 2006 21:45:33 +0100
> Jure Pe=E8ar <pegasus@nerv.eu.org> wrote:
>=20
> > On Wed, 8 Feb 2006 11:55:49 +0100
> > Chris Osicki <osk@admin.swisscom-mobile.ch> wrote:
> >=20
> > >=20
> > >=20
> > > I was thinking about it, I have no idea how to do it on Linux if =
ever possible.
> > > I connect over fibre channel SAN, using QLogic QLA2312 HBAS, if i=
t matters.
> > >=20
> > > Anyone any hints?
> >=20
> > I too am running a jbod with md raid between two machines. So far m=
d never
> > caused any kind of problems, altough I did have situations where bo=
th
> > machines were syncing mirrors at once.
> >=20
> > If there's a little tool to reserve a disk via scsi, I'd like to kn=
ow about
> > it too. Even a piece of code would be enough.
> >=20
> >=20
> > --=20
> >=20
> > Jure Pe=E8ar
> > http://jure.pecar.org/
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
