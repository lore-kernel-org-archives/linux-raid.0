From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm error
Date: Wed, 18 Dec 2013 09:51:57 +1100
Message-ID: <20131218095157.7244c651@notabene.brown>
References: <52AF6915.7010806@epos-cat.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/I9lx5x2DoTRBnbt39p_iAH7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52AF6915.7010806@epos-cat.de>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Samer <michael.samer@epos-cat.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I9lx5x2DoTRBnbt39p_iAH7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Dec 2013 21:56:53 +0100 Michael Samer <michael.samer@epos-cat.de>
wrote:

> Hello Mr Brown
> you might remember helping me end of 2012 with an mdadm error=20
> (lost/inactive volume).
> This year I've been proactive in advertising your name to our yearly=20
> donation list. My collegue Lisa Braunert should already have contacted=20
> you and booked 250EUR at your account. Hope this was/is an adequate=20
> donation for the two very helpful mails :-)

??? Sorry, don't know what you are talking about.
I'm not really interested in receiving donations.  If you have spare money,
please give it to a local children's charity.

>=20
> Currently I've the a mdadm system here again with unmountable volume due=
=20
> to disk (timeout and badblocks) failures. I transfered the disk already=20
> to new HDs.
>=20
> Question: for this is a RAID5 the only redundant disk was lost to a=20
> timeout sometime in the past and the second (/dev/sdf) had tons of=20
> BadBlocks in the first and last 5MBs. I reconstructed the partition=20
> table (as all 8 disks are build the same way), but how could I glue the=20
> mdadm system together again. After that I'd start an integrity check of=20
> the mdadm volume and afterwards an fsck.
>=20
> I attach the "mdadm --examine /dev/sd*" so you might consider looking=20
> upon my problem

This is a very vague problem description.  I'm not really sure what you are
asking beyond "It doesn't work, please help"...

You mentioned RAID5 and there only seems be be one RAID5 in the mdadm
--examine output, on /dev/sd[aceh]3
It is an 8-disk RAID5, so 4 devices seem to be missing?
The "Update Time" is 21st April.  So this array has not been used for over 5
months???

I think you need to spell out in more detail what the problem is, what the
current state is, how it got that way, and what you hope to achieve.
Because at the moment I am lost.

NeilBrown

--Sig_/I9lx5x2DoTRBnbt39p_iAH7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUrDVjTnsnt1WYoG5AQIiCw/+O3bamEDX6Sfx3OvdbnFCzPPQxh/8STCa
MklIIR63Zo2F0DHCsHlpu8MYnGBEhbcB6PEMaOcH0Z1m3BpsukyL7XsdEHdZkx7A
4OvOcHtx+zvyRKx6SqUA9672Rm6731qZRJYUHl29d8nb8pcGmX+x6jB/iC/bavgx
bxBd5pYRkimSIS9uWw9UihUWwcrFauDebrQxx/923a8C7AcnRapb0Y8jytAFuuDp
6D0JM5CVptPX4t2+7DSIFTCiXTLk5ZBZ7KOfTQDlmANwOsH2hj83hskW5eCGYE2h
s+IoisSJEfL0minooe0nLieVCxNPrB4Va9NIh5+667fFiE/GfUXQktmuxu4J6S9q
j6bARbyoyqc4zutcIM4r8Q1kmSOHFIRaPiqc5jQW17tzfqzRjafgYbAcw6SCqL0y
pSPjlwfJLzu8wbtIwJyPiXrcAoZyf0ZDuGYvG+0haBluoBp8qqQGufoJW48AKUTF
fEN9fJktpYntA49OeT9563zjBkQmBUJ7qWSZ5pqC1lPo8CSL1wxZBn/m58f4apJw
nNZNbF7T5UPkw6QInGb66BZAqRwraEX5gay1Wj7tPrCd6oPwl5Mr8bfikOS/53Dz
ZI1o85tL2dUKyRZHQ0L1zUze0G3i7dNv0whsmE8c/yIKRaPjV44fFiHV8c/lf9q7
CNPYsTlYt+0=
=hKzb
-----END PGP SIGNATURE-----

--Sig_/I9lx5x2DoTRBnbt39p_iAH7--
