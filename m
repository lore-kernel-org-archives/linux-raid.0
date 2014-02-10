From: Michael Prokop <mika@debian.org>
Subject: Bug#737951: mdadm: udev rules files ignores raid=noautodetect kernel parameter
Date: Mon, 10 Feb 2014 16:53:05 +0100
Message-ID: <2014-02-10T16-46-44@devnull.michael-prokop.at>
References: <2014-02-07T08-14-24@devnull.michael-prokop.at>
 <52F48D0E.80905@msgid.tls.msk.ru>
Reply-To: Michael Prokop <mika@debian.org>, 737951@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/Dpz40iF3jpiHxF"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.737951.B737951.139204759631916@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <52F48D0E.80905@msgid.tls.msk.ru>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: 737951@bugs.debian.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--2/Dpz40iF3jpiHxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

thanks for the fast reply, Michael

* Michael Tokarev [Fri Feb 07, 2014 at 11:36:46AM +0400]:
> 07.02.2014 11:21, Michael Prokop wrote:

> > It would be nice if there would be some way (maybe just checking for
> > raid=noautodetect in /proc/cmdline?) to disable auto assembly
> > without having to manually delete/override the udev file.

> I don't think that using raid=noautodetect is a good way of doing
> this.  It is for the really obsolete in-kernel array assembly, and
> it is described as such in the documentation you quoted above.

Right

[...]
> None of these parameters, at my point of view, should be considered
> after pre-boot is done and we're in the main system.  If you're
> talking about main udev rules of mdadm, I disagree, there should
> be entirely separate option, if at all.

> What is your usage case?  What are you trying to achieve?
[...]

My goal is to support booting a live system (like http://grml.org/)
in a way which *prevents* auto assembling under all circumstances.
This is relevant e.g. for data rescue and forensics tasks.

regards,
-mika-

--2/Dpz40iF3jpiHxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAlL49eEACgkQ2N9T+zficuhJBQCfZCI2dyaIkiTcO+eiQNAMr8kT
eZwAnidRtiRkX7AyDck+e8xOJLVn5m0q
=LhMS
-----END PGP SIGNATURE-----

--2/Dpz40iF3jpiHxF--
