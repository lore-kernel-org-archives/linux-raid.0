From: "Stern, Rick (Serviceguard Linux)" <rick.stern@hp.com>
Subject: RE: Question: array locking, possible?
Date: Thu, 9 Feb 2006 10:28:58 -0800
Message-ID: <1C4766A743ADF74FAEDF2AAD0679BAA20767917E@cacexc03.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Chris Osicki <Krzysztof.Osicki@swisscom.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is more interest, just not vocal.

May want to look at LVM2 and its ability to use tagging to control enab=
lement of VGs. This way it is not HW dependent.

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Chris Osicki
Sent: Thursday, February 09, 2006 2:26 AM
To: linux-raid@vger.kernel.org
Subject: Re: Question: array locking, possible?



It looks like we are the only two md users interested in such a
feature.
Not enough to get Neil's attention ;-)

Regards,
Chris

On Wed, 8 Feb 2006 21:45:33 +0100
Jure Pe=E8ar <pegasus@nerv.eu.org> wrote:

> On Wed, 8 Feb 2006 11:55:49 +0100
> Chris Osicki <osk@admin.swisscom-mobile.ch> wrote:
>=20
> >=20
> >=20
> > I was thinking about it, I have no idea how to do it on Linux if ev=
er possible.
> > I connect over fibre channel SAN, using QLogic QLA2312 HBAS, if it =
matters.
> >=20
> > Anyone any hints?
>=20
> I too am running a jbod with md raid between two machines. So far md =
never
> caused any kind of problems, altough I did have situations where both
> machines were syncing mirrors at once.
>=20
> If there's a little tool to reserve a disk via scsi, I'd like to know=
 about
> it too. Even a piece of code would be enough.
>=20
>=20
> --=20
>=20
> Jure Pe=E8ar
> http://jure.pecar.org/
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
