From: martin f krafft <madduck@madduck.net>
Subject: Re: removed disk && md-device
Date: Wed, 9 May 2007 15:14:50 +0200
Message-ID: <20070509131450.GA31985@lapse.madduck.net>
References: <200705091417.09033.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1133767769=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200705091417.09033.bs@q-leap.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org
List-Id: linux-raid.ids


--===============1133767769==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Bernd Schubert <bs@q-leap.de> [2007.05.09.1417 +0200]:
> Problem-1) When the disk fails, udev will remove it from /dev. Unfortunat=
ely=20
> this will make it impossible to remove the disk or its partitions=20
> from /dev/mdX device, since mdadm tries to read the device fail and will=
=20
> abort if this file is not there.

Please also see http://bugs.debian.org/416512. It would be nice if
you could keep 416512@bugs.debian.org on CC.

mdadm upstream knows of the problem. See the bug log.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
"i worked myself up from nothing to a state of extreme poverty."
                                                       -- groucho marx

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQclKIgvIgzMMSnURArbfAKCclm6ge5B1dUH92nwdRzh4plBimQCfWX5V
VqBIiEIRCA0G41ram3GBihM=
=0xlf
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--


--===============1133767769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
--===============1133767769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============1133767769==--
