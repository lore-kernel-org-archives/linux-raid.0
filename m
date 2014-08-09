From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or
 directory
Date: Sat, 9 Aug 2014 18:23:16 +1000
Message-ID: <20140809182316.0c16ac48@notabene.brown>
References: <53E54AC5.4010904@megasoft.be>
	<20140809104915.05b8da17@notabene.brown>
	<53E5D329.4040004@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/angGQhOZKLTrn+VE3uf1pgw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53E5D329.4040004@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/angGQhOZKLTrn+VE3uf1pgw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 09 Aug 2014 09:52:09 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

> Doesn't work since sdb has been ejected. Strace below.
>=20
> package manager: mdadm 3.3-r2
> #mdadm -V: mdadm - v3.3 - 3rd September 2013
>=20
> Just tried 3.3-r3 and 3.2.6-r1 same issue.
> (There are no older in the package manager to try fast.)
>=20
> #strace mdadm /dev/md126 -r /dev/sdb2

I note that you put "/dev/sdb2" on the end of the line.


> > How about
> >    mdadm /dev/md127 -r sdb2

I note that I just put "sdb2" on the end of the line.  Perhaps I should have
been explicit and say 'not "/dev/sdb2", just "sdb2"'.  It does make a
difference.

NeilBrown


--Sig_/angGQhOZKLTrn+VE3uf1pgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+XadTnsnt1WYoG5AQIv0hAAg1y1AKDrfrljILVPUG+LyQH3sDpsSsuG
4EPhfSMWPnyfNFpghKCMRbVHA7fRDsTQAIrtbnNRKhxlaroloyPtuUY/uhRLEvmh
LkwEgmSt/btOa5o+VXGum9nNFi/SBa8eCpdQ0ZjokX7KMB1CYz1+mdQT8uUsmRDU
qJ7dppP5FXoEPolkaUDyPEvLQWiL/+l/y9ZvX4i+GZLvoCI0TqL731hBwmwMfeRL
NxN0cGXstaDuFyFhe9S5xGuBjKE/w8XmzyIHQ1Roho9h5PruunhO4Ng+J86FnhMZ
i15now8eVlcnE3qITjvR1ECE8b9vnZYitony0n53x/cVrp73K+95MeBIOtBHGVVB
MLIzH2pts8Q0NgnCMOmKvKvMEbSu/MYIhNDuoYSUHaq6bFJ57J/qEGtyiB+VUOzD
H6oDySvWow3KgjVTCq0tKtpUUtWfC2fy9naS4x74N2oJMHqAJme2jlZsD2m9cr0k
diyVI4TFDWK3MTMpeQzZ/1ZGBEze+6ZrKTmKlxxxsSoYl8GV9XLY5RQNR5S5YWPL
GRrVTr/rcEn+G5X/u0FFVjB8RnjkILosfog/rEsj3YaENdPLiT1K2DsS+V+z0O1z
nHxWNlGqyIFikp4zQVPbRE6v2Zv0dIcWAFz3KJvVAzKWhHjrGc1AuMoEfW7oikcH
CNqCAQjvYqI=
=qmE8
-----END PGP SIGNATURE-----

--Sig_/angGQhOZKLTrn+VE3uf1pgw--
