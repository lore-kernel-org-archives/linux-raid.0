From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm-3.2.5 coming soon :-(
Date: Fri, 18 May 2012 13:44:20 +1000
Message-ID: <20120518134420.4da16442@notabene.brown>
References: <20120503142201.649766de@notabene.brown>
	<20120515215020.76fd9c6f@notabene.brown>
	<4FB274B3.8040907@intel.com>
	<20120517154449.2eeb0512@notabene.brown>
	<679865E03F4C71419D9847EA3AACB163157E2858@IRSMSX102.ger.corp.intel.com>
	<679865E03F4C71419D9847EA3AACB163157E29EF@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iXYVOkcblSNarpuxjcYM+Nf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB163157E29EF@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Cc: "Naruszewicz, Maciej" <maciej.naruszewicz@intel.com>, linux RAID <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, Clint Byrum <clint@ubuntu.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Tomczak, Marcin" <marcin.tomczak@intel.com>
List-Id: linux-raid.ids

--Sig_/iXYVOkcblSNarpuxjcYM+Nf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 11:52:43 +0000 "Patelczyk, Maciej"
<maciej.patelczyk@intel.com> wrote:


> 'mkdir /run' solves it even without fix above.

Great.
So if you compile with -DMAP_DIR=3D/var/run or as appropriate for the distr=
o,
then it should work.

Thanks,
NeilBrown

--Sig_/iXYVOkcblSNarpuxjcYM+Nf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7XFlDnsnt1WYoG5AQI27g/9GnbTDTIimF00UMVtctruOn7UHO03LTJn
cafMoLQTtqUhMyTP3L3MpmZLgY6GfDuEn5eXfL1UStVGSp6pxDXEmTJtK8z+7mi8
isJa8fqZBt8zEtrQGM0Wex95n7pLnpxMHvneh43WfEUQj/WPeOM32ZVnXuHmlC4o
jdULthxgGBa4XhFNpqPpskDvbD2PXqjYvzHCoooh4aO4aqXR1GYa3No/4nn4UvMl
L11dXEpkFHQ1b/urOQxbVeG4kPZdCTOSOYXRagA3NHm0eSISFb3zoh3vAs8ECxm2
xfWgNSx0ccYcFh/ubvAyHMJnudrYRtP0rej34TlNv0HdaH80AWKy6224WkKVe6OO
fGS8XyS3KH9KTrIjbhMiKfYeYjmr5eRS2zmFRDsLiRSGboNWRW9dXN/p32eauUA8
PAQkfowk/JBKYOTapzPn5EGVVL703e5WIn3hBoHauv12A7hB2p4P1EUnKIDBHJT3
XqQKs23aXPV5jpV5GucnBVCfxYvVVcgOZRxgA8Wi5txUejMwDB48cUcc3NNValHP
TBYTzS/UIoDMNxmIcL/0Gtkuf01rpvTx0kby45BOnr5ZtHv642Wqt0w/JlJ20H+j
yHmp0f70oyjhhPsKr5HzD+Jjimx+HYycR/kgwsoS2JzIKxjOicWoU/EuTYEsDkYa
arKi09v+WWo=
=AlpR
-----END PGP SIGNATURE-----

--Sig_/iXYVOkcblSNarpuxjcYM+Nf--
