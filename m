From: NeilBrown <neilb@suse.de>
Subject: Re: Data Offset
Date: Thu, 24 May 2012 15:20:38 +1000
Message-ID: <20120524152038.1d01b866@notabene.brown>
References: <20120510174210.GA2991@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WWEOhC65I8lXj0qDqpeEAO="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120510174210.GA2991@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WWEOhC65I8lXj0qDqpeEAO=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 19:42:10 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi,
>=20
> after the RAID-5 problem, I just realized that
> other RAIDs I have, including a multi RAID-6,
> have different data offset for each component.
>=20
> This seems to be quite of a problem, in case
> "Create" is used to recover an array.
>=20
> Obviouly, if a 4 disks RAID-5 has 2 disks with
> one offset and 2 with another, it will not be
> possible to re-create it (saving the data).

I certainly won't be easy.  Though if someone did find themselves in that
situation it might motivate me to enhance mdadm in some way to make it easi=
ly
fixable.

>=20
> Is there any way to fix/prevent such issue?
> Shouldn't "mdadm" make sure all offset are
> the same? Or try, at least...

I'm not sure.  Maybe...

With linux-3.5 and mdadm-3.3 (both unreleased) you will probably be able to
  mdadm --grow --data-offset=3D5M
and that will happen.  At least for RAID10.  Other levels might follow late=
r.

Should mdadm keep them always the same?  The reason that it doesn't is that=
 I
thought that you could change the data offset by removing each device and
adding it back as a spare with a new data_offset.  Maybe that isn't such a
good idea.

I suspect that I got a chorus of people all saying "please keep data_offset
consistent" - and particular if I received a patch which did that - then I
would probably change mdadm accordingly.

NeilBrown


>=20
> What I noticed is that, adding a disk later,
> might cause different offsets.
>=20
> Any idea?
>=20
> Thanks,
>=20
> bye,
>=20


--Sig_/WWEOhC65I8lXj0qDqpeEAO=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT73FJznsnt1WYoG5AQJv7A/8DsZTSdD2+gMzg7aRAVIW0/XRS247DAsa
xgd+wdG7bf+wxM1LqTx4x880V9TDy6ZvvA5/E6pnCYyyfT74ycXb8I5EMT7pbCba
INsIckKx5KRdJWWxMVq6APHLDe2FWc3EKLsu4zqVEDFP7xBXut+6H40C9qBJNZes
Sln1lb/J3MWE2jONYiXYGXgENPxrRUN/hIZTSkCF2d01v8rtR3BN0idbGgfCeN8r
rUmAJO0QQfDf5ddKTCjsFEdORo26OuMccFQm51myC27S9dIZkrM/3BoMDO1pWqwM
wo0IXdPUmCsNwdveZ5YTg7tfT1+R9LqrVqEstO7WsL9+DeYtRag7i31isdUEO9PQ
XJ+dY588NHwtAklAGCwO1p92+nlumL+7Br033fFFUJxxjlFuquD8hP1UwqT/Eo0J
vZRjb8uiqUn4uXAPfAT7pEJy+L/xHb73BVzQizwLGS8RFiEXK2EJ5SOZeDrfR9MU
oWNlwqwYN5l/q1cOAP9KJmI6UiAfRLUvj3i6rH5388I4fGkShp9JTpuZmcN1NfB+
RvP5dsAQPX+SPOfPC5Z0PxixubFegdJ8T+HnrKBzjFOPhZ9OhWVJJtaDqO2HE0yD
uBkTG+EAamZ0VvmTqZzdI+iHTfnYKscOoqiidlI2hh3MMo9ERNwxSqaDihQBy3dj
wSlGRcexJzI=
=MQAr
-----END PGP SIGNATURE-----

--Sig_/WWEOhC65I8lXj0qDqpeEAO=--
