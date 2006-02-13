From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: Question: array locking, possible?
Date: Mon, 13 Feb 2006 18:58:45 +0100
Message-ID: <20060213185845.595dde05@mwdsp001.swissptt.ch>
References: <1C4766A743ADF74FAEDF2AAD0679BAA2076D204C@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1C4766A743ADF74FAEDF2AAD0679BAA2076D204C@cacexc03.americas.cpqcorp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Rick

You must have missed my first posting, or maybe I was not clear enough.
We _are_ talking about the same thing.

Now we are already three or four thinking of it as a useful feature,
the pression on Neil is dramatically increasing ... ;-)

Regards,
Chris

On Mon, 13 Feb 2006 09:21:06 -0800
"Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com> wrote:

> I understand about HP-UX mirroring/LVM.
>=20
> I was a little too obtuse.
>=20
> LVM2 has a feature (not well advertised) that allows an VG to be tagg=
ed so it will not be activated by "system b" if it is already tagged as=
 being in use by "system a".  I was suggesting that a similar feature c=
ould be added to MD.  This way a MD array could be marked as "owned" an=
d, if so, mdadm would not activate it from another system.  This way al=
l of the MD control is still within mdadm.
>=20
> If Neil is interested, I'll try to dig up more info.
>=20
> Regards,
> Rick =20
>=20
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Chris Osicki
> Sent: Monday, February 13, 2006 9:13 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: Question: array locking, possible?
>=20
>=20
>=20
> Rick
>=20
> On HP-UX disk mirroring is done in LVM. I'm using md driver for
> mirroring and LVM on top of it.  Controlling access to my disks in LV=
M
> is just too late. I would have to assemble the array before I can act=
ivate
> VGs. If the array in question is being used on the other host nobody
> can guarantee that bad thing wont happen. And what I would like to
> prevent is: two hosts accessing (writing) an array.
> Thanks anyway for the hint.
>=20
> Regards,
> Chris
>=20
>=20
> On Thu, 9 Feb 2006 10:28:58 -0800
> "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com> wrote:
>=20
> > There is more interest, just not vocal.
> >=20
> > May want to look at LVM2 and its ability to use tagging to control =
enablement of VGs. This way it is not HW dependent.
> >=20
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vge=
r.kernel.org] On Behalf Of Chris Osicki
> > Sent: Thursday, February 09, 2006 2:26 AM
> > To: linux-raid@vger.kernel.org
> > Subject: Re: Question: array locking, possible?
> >=20
> >=20
> >=20
> > It looks like we are the only two md users interested in such a
> > feature.
> > Not enough to get Neil's attention ;-)
> >=20
> > Regards,
> > Chris
> >=20
> > On Wed, 8 Feb 2006 21:45:33 +0100
> > Jure Pe=E8ar <pegasus@nerv.eu.org> wrote:
> >=20
> > > On Wed, 8 Feb 2006 11:55:49 +0100
> > > Chris Osicki <osk@admin.swisscom-mobile.ch> wrote:
> > >=20
> > > >=20
> > > >=20
> > > > I was thinking about it, I have no idea how to do it on Linux i=
f ever possible.
> > > > I connect over fibre channel SAN, using QLogic QLA2312 HBAS, if=
 it matters.
> > > >=20
> > > > Anyone any hints?
> > >=20
> > > I too am running a jbod with md raid between two machines. So far=
 md never
> > > caused any kind of problems, altough I did have situations where =
both
> > > machines were syncing mirrors at once.
> > >=20
> > > If there's a little tool to reserve a disk via scsi, I'd like to =
know about
> > > it too. Even a piece of code would be enough.
> > >=20
> > >=20
> > > --=20
> > >=20
> > > Jure Pe=E8ar
> > > http://jure.pecar.org/
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> > >=20
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
