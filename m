From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Reshape problems during double raid0 processing
Date: Mon, 30 Jan 2012 11:37:04 +1100
Message-ID: <20120130113704.00cd07c0@notabene.brown>
References: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/03bqFz33464qSydjJXlpCpZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

--Sig_/03bqFz33464qSydjJXlpCpZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2012 08:12:24 +0100 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> The following series fixes problems found during double raid0 container r=
eshape.
> 1. Second raid0 reshape doesn't start
> 2. Second raid0 array reshape is not finalized in metadata
>=20
> BR
> Adam
>=20
> ---
>=20
> Adam Kwolek (4):
>       FIX: Typo error in fprint command
>       FIX: mdmon check in reshape_container() can cause a problem
>       FIX: External metadata sometimes is not updated

Above 3 applied, thanks.

>       FIX: Takeover mdmon when grow is continued from command line

Not applied and discussed in separate email.


Thanks,
NeilBrown


>=20
>=20
>  Grow.c  |   11 ++++-------
>  mdadm.h |    1 +
>  util.c  |   53 ++++++++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 49 insertions(+), 16 deletions(-)
>=20


--Sig_/03bqFz33464qSydjJXlpCpZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTyXmMDnsnt1WYoG5AQLd5g//aU88JqHxTm8gFxuwFUlzWokeltBKPp8L
hLhlZ52qqg/Pae9/8zjhO57HWJoSPj5UNIq0sebjb7+UdhX+aKszf/eE7R75J7R4
AoeFX+tm21IHNt4V9DvZbgpJ7srq1xZQp7F4lIM+1Wf0Y+C+wqOb0lSsP7LKJ87L
OS4JLysCMnnS2jWBY7I7kXsIEtM4cvhfm/TxoSY+tVwyejM6HGu+rzhjiobNlEhi
Xz+dUtCgtHaOuh0ltKBCgV0sRq0ls1GNgxDQ/IXqpJbD4hMqzhePkrJAZLpVMwmX
OGZZb7fYlnqMv3fWqRRaD+JNUP4ir5MFgoYngmiVYBxaREIIjVgimV+kQWUKlmRz
GDIEsraFMdBBlnMDrZjLP6+/GyCBixx8dAjtZ1m+66xo7YgwmQ1ftyKLOBL91wvc
pWPBhxe7NwsTCA6SR21f5u7b5gdfv7Ah1Z0R9rQvgJVD0TacOrQgn4pEAE/ArUUH
YvyfLg0ig8k77R20DoXFf8RdstwhKniRqHHszhGbhyNkOEGy3CfGF5mmFu47A7aP
y3VEmT8EIqQ/Nwex2dNITBGUxWaYsfItydh05XTndfVl1RlbV6pjaSW2//WIHkhR
uK2Q2UHCdFR2BVkwHI1we0TfUzJa3mViRUPXAL41QensjOxYeUR5QNZuXWsPeWZh
1qpW02hDmC4=
=nDP2
-----END PGP SIGNATURE-----

--Sig_/03bqFz33464qSydjJXlpCpZ--
