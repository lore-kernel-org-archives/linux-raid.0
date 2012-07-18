From: NeilBrown <neilb@suse.de>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Wed, 18 Jul 2012 21:15:37 +1000
Message-ID: <20120718211537.516b574f@notabene.brown>
References: <17025a94-1999-4619-b23d-7460946c2f85@zmail15.collab.prod.int.phx2.redhat.com>
	<a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5beFG_lWh1gHj8ra3DZOv1e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5beFG_lWh1gHj8ra3DZOv1e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jul 2012 07:01:48 -0400 (EDT) Jaromir Capik <jcapik@redhat.com>
wrote:

> Hello.
>=20
> I'd like to ask you to implement the following ...
>=20
> The current RAID1 solution is not robust enough to protect the data
> against random data corruptions. Such corruptions usually happen
> when an unreadable sector is found by the drive's electronics
> and when the drive's trying to reallocate the sector to the spare area.
> There's no guarantee that the reallocated data will always match
> the original stored data since the drive sometimes can't read the data
> correctly even with several retries. That unfortunately completely masks
> the issue, because the sector can be read by the OS without problems
> even if it doesn't contain correct data.

If a drive ever lets you read incorrect data rather than giving you an error
indication, then the drive is broken by design.  Don't use drives that do
that.

>     Would it be possible
> to implement chunk checksums to avoid such data corruptions?

No.

NeilBrown


> If a corrupted chunk is encountered, it would be taken from the second
> drive and immediately synced back. This would have a small performance
> and capacity impact (1 sector per chunk to minimize performance impact
> caused by unaligned granularity =3D 0.78% of the capacity with 64k chunks=
).
>=20
> Please, let me know if you find my request reasonable or not.
>=20
> Thanks in advance.
>=20
> Regards,
> Jaromir.
>=20
> --
> Jaromir Capik
> Red Hat Czech, s.r.o.
> Software Engineer / BaseOS
>=20
> Email: jcapik@redhat.com
> Web: www.cz.redhat.com
> Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
> IC: 27690016=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/5beFG_lWh1gHj8ra3DZOv1e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAaa2Tnsnt1WYoG5AQK+IBAAnkgKoKHGxXyWJJELRUGAwlPxe1rA5cKu
gG22bAXFTEUi3DnhYZv/2IkuFRlPH9Ghqk6H/RVrOwLyzmZX7UxaStSVw5IkOxT+
aMfpfRd9AMLb0p+uKFUi8WnZxjo0y0/NnBs3nfjrkupLSyEqDZPi+nge/2JrKSgJ
r0YnrYPBx9h3iI1+o3E8uQQUcCDYtfHfFMILboxFkoEJxjkTdT/aS8DhN6q040sU
Jc+bgvP0iaGNuAvIx+jrMC4LkoEMCE4bs6Lywm2x0Q0/+YHnnaMzGiBR6uqFHtOe
+t8T6aSHLrlRIX9710/YbTg+ZvSXGKrZG2SafIV7mo+Tqy/eN4cjDVOj6taaQC+p
kC/F4KVWw0TWwpePREE9vyZMmQpARji6xOiNsAt8fAr2pOJk/R7cUpFZugkm9eGj
miTavZlOKqf9T6lME1JiRsDMr3ytpCcv3yg3BvbrZzHIDycoOBFi0npMW6h1MKr1
9Dw+ISD5e4Pu8XBXYBrVMN+3w7RzD6zC1D2sz+OVYAoeUt/NqDXkXUwXK9oc3DE3
dHhvFGKE7DkpQ12Tog6SUbPLUnNTLNsX7cFKYg0mfWnTUMIYj7Ce8OuaT7QO86Y4
6iYLCMnUuK72mlbHQno8BDIprRAoeugOn6AtmVYORBST2JnFdMatb/hDs60VNPPm
tFSxkOSeqzE=
=rUMN
-----END PGP SIGNATURE-----

--Sig_/5beFG_lWh1gHj8ra3DZOv1e--
