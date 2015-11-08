From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUET] on config fix for md
Date: Mon, 09 Nov 2015 09:15:27 +1100
Message-ID: <87si4grvcw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain


The following changes since commit 69234acee54407962a20bedf90ef9c96326994b5:

  Merge branch 'for-4.4' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2015-11-05 14:51:32 -0800)

are available in the git repository at:

  git://neil.brown.name/md tags/md/4.4-rc0-fix

for you to fetch changes up to 14f09e2f9b85076133b795a2d2615f635482de1b:

  raid5-cache: add crc32c Kconfig dependency (2015-11-09 09:09:52 +1100)

----------------------------------------------------------------
config fix for md

config dependency needed as md/raid5 now uses crc32c

----------------------------------------------------------------
Arnd Bergmann (1):
      raid5-cache: add crc32c Kconfig dependency

 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWP8l/AAoJEDnsnt1WYoG5/J0QAL14DC09ee4sJrozF6ODdlmQ
hRtyqVfnXKwDgDKo/LU14kXogk7cR0VnFJBIUCb8hEtlq6dgJfbY2mc1g24qpDBt
CfWHEP7996/sCpRy8oHBA9eIzc2ricIwFQ6iuFxe65jpVNVAFS0cjlSDhxaWB6oh
ApOLg9nsQ0uQ+LB/0MzvlpvAK1iYaROpCSrUHahHBiAHKGrfe8PcCsn5ZTjcFcNJ
V8hDEWK9rzI5hv9mxuoGHoVtmI85Ox7OW4IOmmqQnCOqQqOtINB4wVR6TwdHzWkV
9dqqEdM8EEeN/W3CMo+Pw8s+bgEodemoBVXOX8HFu4lZoDWup7iRqW5Uy9z5v9I0
JS7wTVpd5uhuHaCauDVP2hOytukPvWRhYrYuFWc23tZe6TI8YZKSqlXcfixYq3+q
rMDNNSvjztCk71GlJfOSBWxiVy+wQg3eFVk5kNA9R7jxJNhoiBidvBvp1qtGYJXT
6i0TiKfV2NWyMb3jZiunNbPELh2xmI6dUVE/zuH+dABk4xIuItACKnri5uOWiXrD
nzyVfWBONSdkD6AWRyYU+PJlTEiGRBk6UmY+d0YzafTjFl7euNu/OvRwpIPkP7JN
cU6K3HHswDq2C1dBkm+Y5mmMfAmmFDKLfmlv2Gj6BHMzUT4V/eIK3qiyZstktLgC
dAMoPvmH/XRD2ZNedVPK
=fOAK
-----END PGP SIGNATURE-----
--=-=-=--
