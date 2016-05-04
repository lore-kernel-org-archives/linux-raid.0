From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/2] Check node nums for cluster raid
Date: Wed, 4 May 2016 11:19:17 -0400
Message-ID: <305eaf9b-1275-f9b9-dae4-1be8f21ed98c@redhat.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
 <wrfjinytx3fv.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nocaWNuDXGJFnBH0pmIELvRPea4X0cPDU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjinytx3fv.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@redhat.com>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nocaWNuDXGJFnBH0pmIELvRPea4X0cPDU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/04/2016 11:12 AM, Jes Sorensen wrote:
> Guoqing Jiang <gqjiang@suse.com> writes:
>> For cluster raid, we do need at least two nodes for it,
>> the two patches add the checks before create and change
>> bitmap.
>>
>> Thanks,
>> Guoqing   =20
>>
>> Guoqing Jiang (2):
>>   Create: check the node nums when create clustered raid
>>   super1: don't update node nums if it is not more than 1
>>
>>  Create.c | 7 ++++++-
>>  super1.c | 5 +++++
>>  2 files changed, 11 insertions(+), 1 deletion(-)
>=20
> Hi Guoqing,
>=20
> I am a little confused on this one - albeit I haven't looked at it in
> detail. Why should it not be possible to start a cluster with one node?=

> In theory you should be able to do that, and then add nodes later?

Not typically.  A single node of a cluster is likely the odd man out, so
starting it and allowing changes to the underlying device has a high
potential of creating split brain issues.  For that reason, most cluster
setups require some minimum (usually 2) for a quorum before they will
start.  Otherwise, given a three node cluster, you could end up with
three separate live filesystems and the need to merge changes between
them to bring the cluster back into sync.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--nocaWNuDXGJFnBH0pmIELvRPea4X0cPDU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXKhL1AAoJELgmozMOVy/dxZkP/1+Dma0jfe4Iup5ml2WhH652
cTu5RCPjRuG1ZskHW/p8/4ngCY/i/hJJWOM27l1WDqZ674pgs+CZFQcqq9mX9cWw
CeExVr9UBWbYvB7BsLiDwepXBS+MD8wgwLaLE4kMLhL3nvxlg2Xe2c5nCfgTeC3b
kMH9e5w0Yaw088qRpN8Y8MTMpAOqUf1AOySxt+p85GuFUr83XrMnviVxyyy+Q8sZ
Ldl3tOvut5oW2L+RumrXMxwiA1lLRRYNPk1jBNJPhopGhogkt0OeP2ygnPH3yFn+
WE5BcdkbywcgmNFtTcdvfAZ/89mhu84RWVXTb+OywNca57lc8cWt1EkFXdNHe2bL
S6Eyb4pzM2RUe+2ustC7JzuvoKiUTskZ9n66HWt6BjDlKC0FtU7e8557bQ/OQYUb
N/b005ZT0eHNM6U9aPlfIYX1mfFb8+SVL10yQ6ZRTj6p8b4alqB6vM0rQDlI47AV
fWzi24fD3yBWKDxmKBjKcJIS2ejjCwu7JUXaGXvqEEp1kUvFlTLUCl0B14cmcY0m
M7ukSvrCqKE56B3O3jYwQiSuW5oVgt0tRMEqq0zk61acVY631W7o3T6QBhSf32Yc
79OsWGaHLNH4t0VQQ33UBNH7LdUXvbVp+D8eTJpSSD5yHH6kInGUKsCAI9FBM5zL
97GNUIJFjti6H67GI4b6
=ufy/
-----END PGP SIGNATURE-----

--nocaWNuDXGJFnBH0pmIELvRPea4X0cPDU--
