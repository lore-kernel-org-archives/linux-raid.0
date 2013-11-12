From: NeilBrown <neilb@suse.de>
Subject: Re: recommending RAID6 over RAID5 when doing mdadm --create
Date: Tue, 12 Nov 2013 13:52:43 +1100
Message-ID: <20131112135243.285834fa@notabene.brown>
References: <alpine.DEB.2.02.1311110841340.26054@uplift.swm.pp.se>
	<52809BC5.2010605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qVmXnpuxHfk8/V9y09M2d7Y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52809BC5.2010605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qVmXnpuxHfk8/V9y09M2d7Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Nov 2013 02:56:37 -0600 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 11/11/2013 1:44 AM, Mikael Abrahamsson wrote:
>=20
> > I believe this has been discussed before, but I would like to bring it
> > up again.
> >=20
> > I would like to see mdadm recommend RAID6 over RAID6 when using
> > component drives that are 500GB or larger and ask if the user is really
> > sure about using RAID5, plus a pointer to a webpage on the wiki
> > informing the user about the trouble with RAID5 on large volumes with
> > consumer or prosumer drives.
> >=20
> > I am willing to contribute text to the webpage being pointed to.
>=20
> Wikis change to regularly, too easily.  Networks can be down at times,
> often the worst times.  See Murphy's Law.
>=20
> It would be better to put this information in mdadm(8) and refer the
> user there.
>=20

.. or in md(4) maybe.

If anyone wants to run with this and send me a patch (for code and
documentation) I would be very likely to apply it.

NeilBrown

--Sig_/qVmXnpuxHfk8/V9y09M2d7Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoGX+znsnt1WYoG5AQLsnRAAmolTC6d1sokbDf+1ZYFMqZ4NN4IU6lDL
1sJtdnMykk6ko+DZkv7eZrQm2QcFnW++lrHi79WHWMI7iWBTcqf5kNDNiCDd/Zcw
pIqAtC91fx9NOyijksZoJr0NvFqcFmXSxAHBaNOvZGCwwCaMS/IrR0apIBfJ2yBb
kwcciS6iWrMbVDn4+FEZKJzlc+CAlJdE8B5nXRfmZRaZnCI8z+bM77IjslbWz3wu
0uu1lOAUKoWwaFzo1i80Z89kXgDtLZtizNy3hHv1WfhwNN+iBvOMxAIJxRepy6s4
bW3x6CIj18Nw/H35DO86zSVn85K8dhuemusgsUQUI27T7/woKshd3sBppJfFqMgs
GLofSbcbbvHzAiGei+9sgTCjGqzcpD7wLNXd26+tNZpX2HnodqC73BrDMY91OMD+
ulqA/XELHvlKixq3TnaluelxaoJenOjazIxr9psg/SMRw9GrsDCFki3CXw86RhRW
+2rlAffmayvSHnUqHtUMPWnx9MiW6rz2nf0hnFszWH2AyaJdQQBxfNDs9CaCSDAi
JiWazL5a//5bYBi3LwvjfZvOewousQAt3LtOgNE+YPMfMn7R5jdDpHP8mIR5nbf/
e8bdHrV5347fpVty/3FNa9nwQj8aZN0kdwShX+QvF/D1/DXVv3v2MTrPmFBrvly9
JiWbAyUu/YQ=
=1dys
-----END PGP SIGNATURE-----

--Sig_/qVmXnpuxHfk8/V9y09M2d7Y--
