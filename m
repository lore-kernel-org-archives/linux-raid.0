From: Andy Smith <andy@lug.org.uk>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 21:01:22 +0000
Message-ID: <20050318210122.GK82728@caffreys.strugglers.net>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mqp/jWTyA3e+I98c"
Content-Disposition: inline
In-Reply-To: <d1fd9v$7h6$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mqp/jWTyA3e+I98c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 18, 2005 at 09:24:05PM +0100, Mario Holbe wrote:
> There is no such thing like "the right data" from a block device's
> point of view. Both mirrors have "right data", since both got written
> independently. Thus, somebody has to choose one mirror being the
> "more right" one. This, of course, is in administrators hands.
> However, if somebody did so, exactly the sync you described above
> (union of the mapped data areas) must happen.

When would it ever be acceptable to throw away the "losing" node's
data?  Seems like in the majority of cases it would be better to
focus on never getting into the position where two nodes in a
cluster end up with inconsistent but legitimate data.  Unless I am
missing something here...

--mqp/jWTyA3e+I98c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFCO0GiIJm2TL8VSQsRAizjAJwOHIqZT+/mV9My53tAhCqYHOKe/gCeJl7M
7xZSbmNp4mb64LdjHTxR2uo=
=AAUl
-----END PGP SIGNATURE-----

--mqp/jWTyA3e+I98c--
