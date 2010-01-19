From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 19 Jan 2010 12:51:52 -0500
Message-ID: <4B55F138.7060008@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig77A5D77DB1F2BDF7CEDD1500"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100119110930.107ca42e@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig77A5D77DB1F2BDF7CEDD1500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/18/2010 05:09 PM, Neil Brown wrote:
> On Mon, 11 Jan 2010 15:38:11 -0500
> Doug Ledford <dledford@redhat.com> wrote:
>=20
>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>=20
> I really really don't like this.
> I wasn't very keen on allowing the map file to be found in /dev,
> but this it just too ugly.

I've had to rewrite my response to this a few times :-/

So, let's be clear: you are objecting to these non device special files
being located under /dev.  Not necessarily *where* they are under /dev,
just that they are under /dev at all.  That's what I get from your
statement above.

First with devfs, then later with udev, the old unix tradition of only
device special files under /dev is truly dead.  And it should be.  The
files we are creating are needed prior to / filesystem bring up, and
they are needed simply in order to fully populate /dev.  In fact, an
argument can be made that a new tradition, that files related to the
creation and maintenance of device special files belong under /dev with
the files they relate to, has been created.  And this new tradition
makes sense and is elegant on the basis that it requires only one
read/write filesystem mount point during device special file population.
 It also makes sense that this new tradition would supersede the old
tradition on the basis that the old tradition was created prior to the
advent of hot plug and the need to have any read/write data just to
populate your device special files.  The old tradition didn't have the
flexibility to deal with modern hot plug architectures, the new
tradition fixes that, and does so as elegantly as possible.

That being the case, the big player in the game, udev, is following the
new tradition by creating an entire tree of non device special files
under /dev/.udev and using that to store the information it needs.  And
here mdadm/mdmon are, the small players in the device bring up game that
only have minor bit parts compared to udev, holding up progress and
playing the recalcitrant old fart.  Sorry Neil, but the war has already
been decided and this is a dead battle.  Files related to device special
file bring up belong under /dev along with the files we are creating.
Your claim that these changes are ugly are misplaced and based upon
adherence to a dead tradition that has been replaced by a more sensible
tradition.  Maybe you don't like where they are under /dev, but the fact
that they are under /dev is definitely the right thing to do and is not
in the least bit ugly.

> I understand there is a problem here, but I don't like this approach to=
 a
> solution.  I'll give it more though when I get home from LCA2010 and se=
e
> what I can come up with.

Feel free to come up with something different.  But, if your solution
involves maintaining an additional read/write mount area in deference to
a long dead unix tradition, I'm just going to shake my head and patch
your solution away to something sane.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig77A5D77DB1F2BDF7CEDD1500
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktV8TgACgkQg6WylM+/8ZQlKgCeP6EAR2T9VbOmfi0YFtBBPEz4
mR4AniSCblejzY+qf9J3wC3Rvr0IZ8Xp
=I1nu
-----END PGP SIGNATURE-----

--------------enig77A5D77DB1F2BDF7CEDD1500--
