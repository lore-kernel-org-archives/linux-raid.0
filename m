From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: ''force'' continutation of a rebuild?
Date: Thu, 15 Dec 2011 14:44:22 -0800
Message-ID: <20111215224422.GA3204@wombat.san-francisco.ca.us>
References: <3b2qr8xpq2.ln2@goaway.wombat.san-francisco.ca.us> <20111216075337.43b1e07c@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111216075337.43b1e07c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil!

On Fri, Dec 16, 2011 at 07:53:37AM +1100, NeilBrown wrote:
>=20
> Golly, you must be running an ancient kernel ... I fixed this bug at leas=
t 2
> days ago...  Though admittedly I haven't submitted the fix yet so maybe y=
ou
> have a good excuse :-)

I initially misread "2 days" as "2 years", and was slightly puzzled.
I do recall seeing the messages on the list, but obviously didn't pay
enough attention to them.  ;-)

> If you remove both spares:
>   mdadm /dev/md0 --remove /dev/sdo1 /dev/sdd1
>=20
> the rebuild should start.  You can then add them back again "--add".

Yep!  I feel slightly less stupid about posting now--I would not have
thought of that.  (Though ISTR that one of the pages I found did touch
on this bug (in a slightly different context), but I don't remember whether
it mentioned this particular option as a workaround; I sort of think
not.)

I think this workaround is perfectly acceptable, where I would not want
to go out and build the latest kernel just to fix it.  But if there were
a more critical fix to the kernel, what's the most consistent way to go
about that?  Would it make more sense to grab the source code from
ELrepo and apply patches?  Or would it be better to grab the latest
kernel tree, adapt the ELrepo .config, and hope for the best?  (On this
box, there is very little else running, so it should be robust to kernel
changes that break other items, as long as it keeps md working.)

> Send an email to linux-raid asking who broke what..  Oh wait, you did tha=
t.

:)

--keith


--=20
kkeller@wombat.san-francisco.ca.us


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk7qeEYACgkQhVcNCxZ5ID+rHwCcC3KRmoLMgMMF5saK03VS5si4
KrcAoJsQxAtR/FWAG4JQ0Y6ZX0g0FlkM
=cqnG
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
