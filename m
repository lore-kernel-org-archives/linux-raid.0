From: Chris Osicki <Krzysztof.Osicki@swisscom.com>
Subject: Re: Question: array locking, possible?
Date: Thu, 9 Feb 2006 11:25:54 +0100
Message-ID: <20060209112554.20f43b24@mwdsp001.swissptt.ch>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
	<43E8F455.2020800@steeleye.com>
	<20060208115549.2c771ecb@mwdsp001.swissptt.ch>
	<20060208214533.39653804.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060208214533.39653804.pegasus@nerv.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



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
