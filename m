From: NeilBrown <neilb@suse.de>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 21:22:57 +1000
Message-ID: <20120628212257.5ca8fb05@notabene.brown>
References: <4FE9BFC1.5070607@xunil.at>
	<20120628163205.2c6a1122@notabene.brown>
	<4FEC1CE7.5010709@xunil.at>
	<4FEC2071.8010504@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cKmtFtPkT7LlFoUUJ/PXGch"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEC2071.8010504@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cKmtFtPkT7LlFoUUJ/PXGch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 11:14:25 +0200 "Stefan G. Weichinger" <lists@xunil.at>
wrote:

> Am 28.06.2012 10:59, schrieb Stefan G. Weichinger:
>=20
> >> If you have a machine with the same arch at the NAS, you could
> >>
> >> git clone git://neil.brown.name/mdadm -b mdadm-2.6.5 cd mdadm make
> >> mdadm.static CWFLAGS=3D-Wall
> >>
> >> and then use the "mdadm.static" on the NAS.
> >=20
> > Ok, thanks. I could boot some ubuntu on my Atom-netbook .. or what?
> > Would it be enough to match the 64bit-environment, or would I have to
> > use something with the same kernel ... ?
>=20
> Update:
>=20
> compiled mdadm.static on a 32bit machine and could re-add the two
> partitions to the array! cool! thanks, Neil!
>=20
> ~500 mins to wait now.
>=20
> Do I have to fear read-errors as with RAID5 now?

If you get a read error, then that block in the new devices cannot be
recovered, so the recovery will abort.  But you have nothing to fear except
fear itself :-)

>=20
> I still don't fully understand if there are also 2 bits of
> parity-informations available in a degraded RAID6 array on 2 disks only.

In a 4-drive RAID6 like yours, each stripe contains 2 data blocks and 2
parity blocks (Called 'P' and 'Q').
When two devices are failed/missing, some stripes will have 2 data blocks a=
nd
no parity, some will have both parity blocks and no data (but can of course
compute the data blocks from the parity blocks). Some will have one of each.

Does that answer the question?

NeilBrown


>=20
> Thanks again so far, hoping the best now ;-)
>=20
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/cKmtFtPkT7LlFoUUJ/PXGch
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+w+kTnsnt1WYoG5AQLNpg/8CdA+V2BDn/5l/MDQKrvMOJ3+2k2LaH09
O0qEbLZAWKz9jANTro3AGB7/wPf/IeTd/ZHR67CfvISEbuitzvgoNcuSAU1im3Ro
JYg+/j6NRGPrzmeGQxVc5zoAwcGxq6KFQ9y9TZto0d4kkBXGvP2Sg43Ph2NwnbOs
Oi4fXtl/9H13nNG/uR52HvEU7pYAPjgNK1dkmd4N7H9jMoPeJEerrsa/4d2k3qkU
x7Zdckxt47S4rPd5fBwX8bnyCgRvIPx1de1qjz5NQDvTcLdMrEairbS8JxKms0BY
hocxQreecFgMqzGIdz691EftFaelGTXBGEfEM+tblRND8yca64eUdDx+fvp91KVq
RdtryIE2TZwr7tI5wPfw3L7RRwOGawjzmcf94eZF5OgINLTq8Wf7LLYAZKv2Z4oj
N7pY6At+6zBV6m61yGbpohZ3YzM0NZGA+4fH9whz/vgtpQM7cGJ9yROgEQs9EiO7
ORs9vSni7MorGG312b/qoSq50a7djbRdPmP+OMf8xFhJ3N0kp2T4OPy7lo/i7khK
ymBbTiypeupyBozyNiVUVhC1N66CHWnBq1nRkKKoodRRiQwfc4NLCvy/xS9d80g7
eP7mCHLCadQeKg4YSDxQsjZmoGYaSnAFNqGxinUM346h3Tp+GmrHeth0jU+iI0y0
4n8Bxm8jWt8=
=X3gW
-----END PGP SIGNATURE-----

--Sig_/cKmtFtPkT7LlFoUUJ/PXGch--
