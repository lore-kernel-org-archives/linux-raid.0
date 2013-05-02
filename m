From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm monitor sometimes doesn't send events.
Date: Thu, 2 May 2013 20:30:44 +1000
Message-ID: <20130502203044.01fd6755@notabene.brown>
References: <517E34E9.3050602@open-e.com>
	<20130430114806.0f687c0f@notabene.brown>
	<51822532.2010500@open-e.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u7fM8SdWAYMQLY/g56jpu5P"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51822532.2010500@open-e.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?UTF-8?Q?Buba=C5=82a?= <arkadiusz.bubala@open-e.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/u7fM8SdWAYMQLY/g56jpu5P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 02 May 2013 10:34:58 +0200 Arkadiusz Buba=C5=82a
<arkadiusz.bubala@open-e.com> wrote:

> On 30.04.2013 03:48, NeilBrown wrote:
> > On Mon, 29 Apr 2013 10:52:57 +0200 Arkadiusz Buba=C5=82a
> > <arkadiusz.bubala@open-e.com>  wrote:
> >
> >   =20
> >> Hello,
> >> We've got a problem that sometimes mdadm monitor doesn't send events.
> >> Actions are as follows:
> >>
> >> start:
> >> create new RAID 5 array
> >> wait until it's rebuilding
> >> stop created array
> >> go to start
> >>
> >> Only first time we get "NewArray" event then when new array is created
> >> only "RebuildStarted" event appears. After our analysis we found out
> >> that when we stop an array we get "DeviceDisapeared" event and when we
> >> create a new array we get "RebuildFinished" and then "RebuildStarted"
> >> event. Sometimes those two events don't show up.
> >>     =20
> > The missing NewArray messages was fixed in June last year by
> > commit 0f760384ebc92d81a988c1501e4a493ef064ad66
> >
> > You are using a very old mdadm.  Maybe you should try 3.2.6
> >
> > I'm less sure about the RebuildStarted/RebuildFinished oddities but the=
re is
> > a good chance they are fixed is the latest release too.
> >
> > NeilBrown
> >
> >   =20
> Thank you,
> I'm testing this on 3.2.6 and it seems to work well. Events don't=20
> dissapear. We thought that lack of "NewArray" event may be intended.
>=20
> Could you answer these questions, please:
>=20
> Do we need to restart mdadm monitor when new disk is added to the system=
=20
> (hotplug)?

No.

>=20
> Do we need to generate config file in such situation or running mdadm=20
> with option --scan is sufficient?
>=20

--scan should be sufficient.

NeilBrown

--Sig_/u7fM8SdWAYMQLY/g56jpu5P
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYJAVDnsnt1WYoG5AQKxKQ//e8dy9k1qwq+xoxQoarRAdfHVEPcRNUtx
ZLuzCPIUk9w7JI8hmEEFaCKFfQ+JDrrOw3IBk11H4SHotGM52qan8kk5Esz3RSRU
iYagnPZv/GDUFaeh4LqL/tjb3lOyLPpL1gfvaOjntxnvxNNcfIwU88hh1qIg9O6b
jl1vMfFTmAm5wzcZcJPTTKdAuFH0zfPmkePCFBC8a8/CTVOtjJgooud7WTpMhPMk
1eRl4Z/MOKzJLNnJdwfRNPFh7DBfMKWH5kc/nXnUWJe2mCcq83aSDP3kFr2MhWHn
cXoTBL7Z89NawnO7lcILwXqXnDfCsUk8aNSXRMwJ8uw4hUAL9IBZu179cpe3xilQ
0Yi1kUScuGhKOxQxU2rt9gQdRgsjabh7kPNG65/vK44blyM0F07J/Nb3NuQlKd1Z
tEx2ooidOjlyJv6+I4eTeNToeZRKmWesT1rstlmMK+8Ddguzr0aEJfF51glDa1TW
LyPVqPd8voscQqGahpIax9vYGf4Mj1x5ySJqk3l2B3QMHuoGO3ah/9lco/ERnCGU
oNCMTecAkNtJMvnt5IzNj+LCIQp/XiJd863dIF7FeLI0SjzRtjYhgEWMJkODnvRU
QG+tMtl2x8Jr4x8sbFSrfVw1sErGz+XlvggVr8EKv538Llq31qix7d/yHpADQTIN
b53QrBFQ0IQ=
=HRlA
-----END PGP SIGNATURE-----

--Sig_/u7fM8SdWAYMQLY/g56jpu5P--
