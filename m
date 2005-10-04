From: Andy Smith <andy@lug.org.uk>
Subject: Checking the sanity of SATA disks
Date: Tue, 4 Oct 2005 14:29:13 +0000
Message-ID: <20051004142913.GK6594@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hyTYhATX2oHzpZim"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--hyTYhATX2oHzpZim
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I have a home fileserver with 4 SATA disks in a RAID 5.  As I am
sure you are aware, SATA devices in Linux currently cannot be
queried for SMART info, so I can't do SMART health checks of these
devices.

Also there is still the tendency for Linux Software RAID to kick
devices out of the array as soon as there is any error on them.

I really don't want to be in the situation where a drive dies, I fit
a new one, and during the resync another device is kicked out
because of spontaneously finding a bad sector.

I tried simply doing a

        dd if=/dev/sd[abcd] of=/dev/null

To check each disk in a very unsubtle fashion, but it drives the
load average on the machine way way up (like to 20+) and makes it
very unresponsive (wait several minutes for a keypress to be
acknowledged), even if I run it under nice -n 19.

I don't notice any performance problems on this server during normal
day to day use, and while it's not particularly beefy it is an AMD
Sempron 1.8GHz so I am surprised that simply reading from one disk
causes these performance issues.

I know this isn't right, so has anyone got any advice in the way of
tracking down which part of the system is at fault, possibly
off-list if it's too offtopic?

Thanks,
Andy

--hyTYhATX2oHzpZim
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDQpG5IJm2TL8VSQsRAosWAJ94UUP0BBLkbDBRldfubNZm/19vVQCcDA7X
zhd6jg/eB9S8XWomV8JiS68=
=q0D3
-----END PGP SIGNATURE-----

--hyTYhATX2oHzpZim--
