From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Tue, 23 Mar 2004 07:48:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040323064807.GA6815@devserv.devel.redhat.com>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com> <4058C089.9060603@adaptec.com> <200403172245.31842.bzolnier@elka.pw.edu.pl> <4058EBEC.8070309@adaptec.com> <1079788027.5225.4.camel@laptop.fenrus.com> <405E287E.3080706@adaptec.com> <1079946343.5296.5.camel@laptop.fenrus.com> <405F61C1.9090907@adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <405F61C1.9090907@adaptec.com>
To: Scott Long <scott_long@adaptec.com>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, "Gibbs, Justin" <justin_gibbs@adaptec.com>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 22, 2004 at 02:59:29PM -0700, Scott Long wrote:
> >I think that all the arguments for using DM are techinical arguments not
> >emotional ones. oh well.. you're free to write your code I'm free to not
> >use it in my kernels ;)
> 
> Ok, the technical arguments I've heard in favor of the DM approach is 
> that it reduces kernel bloat.  That fair, and I certainly agree with not
> putting the kitchen sink into the kernel.  Our position on EMD is that
> it's a special case because you want to reduce the number of failure
> modes, and that it doesn't contribute in a significant way to the kernel
> size. 

There are serveral dozen such formats as DDF, should those be put in too?
And then the next step is built in multipathing or stacking or .. or .... 
And pretty soon you're back at the EVMS 1.0 situation. I see the general 
kernel direction be to move such autodetection to early userland (there's 
a reason DM and not EVMS1.0 is in the kernel, afaics even the EVMS guys now 
agree that this was the right move); EMD is a step in the opposite direction.


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAX92nxULwo51rQBIRAok0AJ0ePgdjLl3qdy2n6Q4MkKSFSfOu+QCdGthm
I2smD2CyRHOwHpB9uZ0bkJA=
=qLIW
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
