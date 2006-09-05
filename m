From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: Re: Care and feeding of RAID?
Date: Tue, 5 Sep 2006 15:14:54 +0200
Message-ID: <20060905131454.GA28548@scavenger.homeip.net>
References: <44FD722C.7050608@waldoware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FD722C.7050608@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.09.2006 08:48:44, Paul Waldo wrote:
> Hi all,
>=20
> I have a RAID6 array and I wondering about care and feeding instructions =
:-)
>=20
> Here is what I currently do:
>    - daily incremental and weekly full backups to a separate machine
>    - run smartd tests (short once a day, long once a week)
>    - check the raid for bad blocks every week
>=20
> What else can I do make sure the array keeps humming?  Thanks in advance!

The mdadm man-page has information about running mdadm from cron to check
for 'unusual' activity.
You may want to consider that. I run it as daemon, personally.

Greetings,
	Benjamin
--=20
#!/bin/sh #!/bin/bash #!/bin/tcsh #!/bin/csh #!/bin/kiss #!/bin/ksh
#!/bin/pdksh #!/usr/bin/perl #!/usr/bin/python #!/bin/zsh #!/bin/ash

Feel at home? Got some of them? Want to show some magic?

	http://shellscripts.org

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFE/XhNr0OTeImXvg8RAmw6AJ0XfJULt4LCZMwKl/YUYDOBZn6F2gCeKnra
lUbmR0G85FGpXD9zDEqIwMU=
=37l+
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
