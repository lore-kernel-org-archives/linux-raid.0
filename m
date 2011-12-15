From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
Date: Fri, 16 Dec 2011 06:30:49 +1100
Message-ID: <20111216063049.6d6422eb@notabene.brown>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150712.21483.48715.stgit@gklab-128-013.igk.intel.com>
	<20111215150114.68ee8522@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A060FAC@IRSMSX101.ger.corp.intel.com>
	<20111215220743.1c072d0d@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0611F8@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2n4qffPOHMjdfatUfu.vUrB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A0611F8@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--Sig_/2n4qffPOHMjdfatUfu.vUrB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 15:29:50 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
> ... what do you think about adding '!' in condition 'if (uuid_set) {'
> It is like  your comment in code directs to.  With this change test looks=
 ok, but I can miss something this time also ;).

Yes, you are right.  I need a '!' in there.  Thanks!

NeilBrown

--Sig_/2n4qffPOHMjdfatUfu.vUrB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTupK6Tnsnt1WYoG5AQKSiA/9HA1nVvWigBftmTRzXUTNXeG8hyf/8l2Y
itAMwSSn1JQl0dtuLrONQLBy5S9oZjB10TAohlhNRO/VixbmLAy4pr4C4yP4WkWv
qoWsKWKsG80p3GHghu9gHElsuLy7NuLEW1b/pD8qEmuHHVWzmPmsReURMUHy/LYR
1FAU+/cOGNWaN018Vsn2cUNlhp5CbcT8jMxMKWGCOlBPVcpQGWXy1ip+vpIxbRNb
WbaoowpxO1cVadzljxMHH1F91EvmTvIICJ34kQHvN99T2h8nL21npjNeZX+AM9F9
aZHEvlwD9s9pz6SaCIq382XeWpx8fkRqqTM4Z/d40qD4AZ3MZw9m762RQDkUZ6qF
0DJ4RlawbBZowbXxXxcONdkjFCwGKJxOapDiXXjABkqRI/pKEK8+bCJvt/Fpz3i8
q54QxnIi5maoGqB0QlaSnwuelRx9P5r9J+KTzX6c4z6Be/OoCsfWvos+r3Cu2dan
Eb/Uc6Z2h1lRQEMXOvrsWO08yl8U8WN+gpYuCXMyupdgE/QqtUI12R9/4MDcEiZd
6iSCy7sGylUfobSAO+HUt7Esg8MaeUjDq32CvB+pPIr3z7UEkX3N876Ekkc7ywUc
T1nP4YcmQ+7z31hta3MWNgg7kbt5FhRy/gcZoVlm/+yi+ciLQVj4/ty6iDgPqm16
dUUU/gbSIFw=
=DUpf
-----END PGP SIGNATURE-----

--Sig_/2n4qffPOHMjdfatUfu.vUrB--
