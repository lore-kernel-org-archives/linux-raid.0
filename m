From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] Avoid OOPS when reshaping raid1 to raid0
Date: Tue, 27 Mar 2012 14:35:39 +1100
Message-ID: <20120327143539.32cedf3c@notabene.brown>
References: <1332750685-31643-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2t8P7c8kPY2=sfpoBsm5BWd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332750685-31643-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2t8P7c8kPY2=sfpoBsm5BWd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Mar 2012 10:31:25 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> raid1 arrays do not have the notion of chunk size. Calculate the
> larges chunk sector size we can use to avoid a divide by zero OOPS
> when aligning the size of the new array to the chunk size.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks.
Applied with one change:

>  	/* Set new parameters */
>  	mddev->new_level =3D 0;
>  	mddev->new_layout =3D 0;
>  	mddev->new_chunk_sectors =3D 128; /* by default set chunk size to 64k */

I changed the above line to
	mddev->new_chunk_sectors =3D chunksect;

as that makes more sense.

Thanks,
NeilBrown


> +	mddev->chunk_sectors =3D chunksect;
>  	mddev->delta_disks =3D 1 - mddev->raid_disks;
>  	mddev->raid_disks =3D 1;
>  	/* make sure it will be not marked as dirty */


--Sig_/2t8P7c8kPY2=sfpoBsm5BWd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3E1iznsnt1WYoG5AQINdhAAs9QN/ZQzTkNkxaRKIJ8vNnQ5fHDnDQLU
/3DKviSdSt6qMTOLO5wZlC/FdXyzcgKI7Fe/WabhAAYnMxhkMTr26nHigVCUSCm9
HFbqpqpV364JlfGzjfzX30tWHl7dSZZVWzHkmGvjEkM6thc4nxm4Fwnvn/qunnoe
9jxVel4dRVEf6WS3tEOoZL5fZau4okGztZG9QEbIE/yc/Om9Q3l3H61lTXhNBmm6
SfxYGoP6MLseHsTTkMPu55W8y70ebDtIfJiQ11Z6iiWzo9OBw7fNPO495F963VQi
VdJVYUVsjtsej3LXOpgbK2MGw47J3p6XStx4anbRRfe1Mq4j5ak1HbbEUad63Ud/
w4fJaEII0AX/NvbcrlVdpb6Q5+qXzjjj5cuzqhQ9aUswRsMwgfPHFSJUJuMsSC4s
+F0d42aGK+e276ZhWZ2S03pF3ROci+CeQBlmqPkkt7NOKVqPkhZV7Yq5J9E2WNRR
vMeEx0fPvewRlR/+Z+LdEtj8OAkEog2XmVPym6vQPo+IqIXlUI+BZAYs6ge2+gMT
AMmm1gVk+/YEN3QzuWz7wrQ0SgIR4LfB4KOD52dcEzFsPj7nubzxFNjwIjPPtMFt
bOMBvvqF/lytm4+gxg9WH9ijJScQzW8+J8gr8zJ0mbMBkq+wA6icuBqU+zcVWxOZ
gh6Hq0m7lPw=
=9SgW
-----END PGP SIGNATURE-----

--Sig_/2t8P7c8kPY2=sfpoBsm5BWd--
