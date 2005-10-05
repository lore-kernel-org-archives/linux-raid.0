From: Andy Smith <andy@lug.org.uk>
Subject: Re: Checking the sanity of SATA disks
Date: Wed, 5 Oct 2005 11:08:03 +0000
Message-ID: <20051005110803.GW6594@strugglers.net>
References: <20051004142913.GK6594@strugglers.net> <1128447152.17447.69.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V60jbYOS58+JZmBV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1128447152.17447.69.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--V60jbYOS58+JZmBV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 04, 2005 at 10:32:32AM -0700, Dan Stromberg wrote:
> You may be better off using smart, but if you want to go through all the
> blocks in a device without making your load skyrocket, I have two
> solutions for you:

Thanks Dan.  As it happens it rapidly became clear there was some
major problem with this machine as even normal tasks sent the load
through the roof once they did any significant IO.  I rebooted it
and now the drives all report 4 times the throughput from "hdparm
-t" as they did before.  Something I need to investigate.

Your "slowdown" tool looks useful though and I will no doubt use it
in tandem with dd now, as I don't particularly need those dds to be
fast.

Thanks to others who took the time to reply also.

--V60jbYOS58+JZmBV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDQ7QTIJm2TL8VSQsRAm7AAJ9OmdILYCFuVetbxpgTP5NkUnIT7gCeIMhf
3GfDrUETyU0yPhsqy26QjzU=
=EK5p
-----END PGP SIGNATURE-----

--V60jbYOS58+JZmBV--
