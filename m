From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Thu, 08 Oct 2015 15:16:41 +1100
Message-ID: <87bnca6lli.fsf@notabene.neil.brown.name>
References: <cover.1443973492.git.shli@fb.com> <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com> <87pp0q6s1i.fsf@notabene.neil.brown.name> <20151008031644.GA3063621@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151008031644.GA3063621@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Shaohua Li <shli@fb.com> writes:
>>=20
>> Neither of these chunks should be needed.
>> ->raid_disk of an active devices is only set to -1 if ->hot_remove_disk
>> succeeds.
>> You have make ->hot_remove_disk fail for Journal devices, so ->raid_disk
>> will be >=3D 0.
>
> I agree the raid5_remove_disk part is superficial, I fixed in an updated
> patch. I still didn't get the point what can prevent a journal disk is
> removed. Currently the raid_disk is always -1 for journal disk. If it
> should be >=3D0, what value it should be? We give journal disk a special
> role '0xfffd' currently.

Oh, are we leaving the ->raid_disk at -1 for the journal?  I hadn't
noticed that.  I don't feel comfortable it.  Too much code assumes that
<0 means "not in use".

Probably set it to 0, and add a check to setup_conf(), and adjust the
check in run().  md_update_sb() probably need to be careful of journals
too (to not change ->recovery_offset).
I wonder what 'slot_show' should report for the journal.... maybe
"journal"??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWFe4pAAoJEDnsnt1WYoG5oi4QAKLRJEaCSVLIKpt4ItOq8VuP
/VZl0SVJTS8d4+6mqzwBL6wWJ+37a62XPyVRd/a/fGsdu7OrL7fs65QJEiAYf7X/
PFwlfcxunR/J7BWOs56WLYK2MXRdTYulrNTjr8qNveyc3R4hrml+xba/ApwXIZRY
nF9XqzKDAWqpw4ZAOmQgSwDU5+pSTeuhaMnsxnlRKCtW215GyonjfhR0uqSu51MP
yLwoAEg9OgEFs3YlVbURjkaWwTgTbmC7ZWHZ2OyuJN4vRMUpE2SYwdeuZNP9083q
OLxAH2hsI7dDsNNqNGkIxce7AgY+MMfn+mZX+bJs1YghFq9ohsPdVTMUG6nA01Fs
WsWAbZqPSBFFBtTWtDailTYVS0xV4yTlZpHaYq/VxPeiP6d6KgxAddKd02CqP6Q+
53VXFJjl/DA7T1PwnYqN8vE0fVE3b4HessBXUsB6UZB40n+VPU62Wf4oUGFdTs06
DcPcSMY/Obz/+61eK73W6gYcaEFOTc2RGZtnmCtm6fPbJ9HSLviXqwrZVSIbZdIC
oF57sFBsxoZHPQSCsqc4uN0IIJPv/0NgI4PPdQlqOIK5WKwWeo7UheKsjXeBiCEA
jLjrzdzXkifREvrB2rQC2wI0kmdo5Fnc/AqR95vnpJGYjRg+kGJVvYVj7hXw9pbm
V9Kk5W5AnqvyraStDoIw
=FuF2
-----END PGP SIGNATURE-----
--=-=-=--
