From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm monitor sometimes doesn't send events.
Date: Tue, 30 Apr 2013 11:48:06 +1000
Message-ID: <20130430114806.0f687c0f@notabene.brown>
References: <517E34E9.3050602@open-e.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/amjJJV_9NvJ_PiyTvU4Fq1R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517E34E9.3050602@open-e.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?UTF-8?Q?Buba=C5=82a?= <arkadiusz.bubala@open-e.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/amjJJV_9NvJ_PiyTvU4Fq1R
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Apr 2013 10:52:57 +0200 Arkadiusz Buba=C5=82a
<arkadiusz.bubala@open-e.com> wrote:

> Hello,
> We've got a problem that sometimes mdadm monitor doesn't send events.=20
> Actions are as follows:
>=20
> start:
> create new RAID 5 array
> wait until it's rebuilding
> stop created array
> go to start
>=20
> Only first time we get "NewArray" event then when new array is created=20
> only "RebuildStarted" event appears. After our analysis we found out=20
> that when we stop an array we get "DeviceDisapeared" event and when we=20
> create a new array we get "RebuildFinished" and then "RebuildStarted"=20
> event. Sometimes those two events don't show up.

The missing NewArray messages was fixed in June last year by
commit 0f760384ebc92d81a988c1501e4a493ef064ad66

You are using a very old mdadm.  Maybe you should try 3.2.6

I'm less sure about the RebuildStarted/RebuildFinished oddities but there is
a good chance they are fixed is the latest release too.

NeilBrown


> The problem is in mdstat_read function:
>=20
> else if (ent->percent =3D=3D -1 && w[0] >=3D '0' && w[0] <=3D '9' && w[l-=
1] =3D=3D=20
> '%') {
>      ent->percent =3D atoi(w);
> }
>=20
> atoi(w) sometimes returns 0 instead -1. It causes that mse->percent =3D 0=
 in:
>=20
>              if (mse &&
>                  mse->percent =3D=3D -1 &&
>                  st->percent >=3D 0)
>                  alert("RebuildFinished", dev, NULL, mailaddr, mailfrom,=
=20
> alert_cmd, dosyslog);
>=20
> and above conditions aren't met. Then in:
>=20
>              if (mse)
>                  st->percent =3D mse->percent;
>=20
> st->percent becomes 0 and next conditions where "RebuildStarted" event=20
> should be sent also aren't met:
>              if (mse &&
>                  st->percent =3D=3D -1 &&
>                  mse->percent >=3D 0)
>                  alert("RebuildStarted", dev, NULL, mailaddr, mailfrom,=20
> alert_cmd, dosyslog);
>=20
> Probably it is fine because rebuild already started and this is what=20
> monitor reads from /proc/mdstat. Shouldn't it return "NewArray" event=20
> instead those two "RebuildFinished" and "RebuildStarted" in this situatio=
n?
>=20
> We use mdadm version 2.5.6 and monitor runs as a daemon with 10s=20
> interval and scan option.
>=20
> Do we need to restart mdadm monitor when new disk is added to the system=
=20
> (hotplug)? Do we need to generate config file in such situation or=20
> running mdadm with option --scan is sufficient?
>=20


--Sig_/amjJJV_9NvJ_PiyTvU4Fq1R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUX8i1jnsnt1WYoG5AQI75A/9H+XQSHopBwHECBXvFJo929g/4Zkkxg0Y
WU9/rtKqh/lNr/gUvHEFngoSn0nOckBDGpOin/XDBnqcFeDBeR67CV9g0VMGlNCk
sE3nYJK8KZSDvzkWf+ixJJKHZOl8tviFTn/BhVFGi/AaR15s8GBrVdzklbGolVq9
a3WSZCOTKe1dLJmtdG3fGrImiYCXOylMaWnd8aLl+uIXH3g/cYyiM90VYI6n3QcD
0/LFesUhBqtpyl1hTid+tm5Mm+ingEXXWdQqlIOQfxpcecvl58EsD5gmWCjAiVyS
8ek5N2aZBtI+VGJx8FTFwefL3P5qGAp7gGcQvz0WqbGzVQu4Z6XP4Wi4YcscgPB9
ZDXXFPNMo5oD8FAxCghlVaBu2mOd4imrH7Gp7AbzLF8OdW+qzYGulsGAZHSZTCJW
b9y1RItlBWrEltr0pRDHQqO544rQjBAkj3Xq4GhZg+SMvjs3aX0D8oQ0lwQOw2NJ
TkCRPKW1V284Rc9ifNpyQRcjtNP8oR7BmxczKUSdD2fWXVcq1PTRG6rXrZVTDMHs
BkapbXh61RvCXMxhrUiy8RjzNR1aw4BqCnkMQo+AxhqJPGF82hsGyL9qPq66jKqQ
g5nN9UfA8YhGjxyKMxlxKPtOmyCOUuPakOrZbCyvYLNINlcomZ+FAX0NsShh3Cje
KGYYpvM9Z0o=
=ljSX
-----END PGP SIGNATURE-----

--Sig_/amjJJV_9NvJ_PiyTvU4Fq1R--
