From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 02 Feb 2010 13:07:14 -0500
Message-ID: <4B6869D2.7040506@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com> <4B673A5D.2010901@tmr.com> <4B674860.7080604@redhat.com> <4B6758C7.9060301@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFD8066DBFFD6F9004F11064A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6758C7.9060301@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFD8066DBFFD6F9004F11064A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/01/2010 05:42 PM, Bill Davidsen wrote:

> In other words, it's not where you put it, it's where you *didn't* put
> it, that seems to be an
> invitation to put stuff just anywhere. Neil argues that they are not
> devices, I argue that
> they are PIDs. It's not as though it were a huge effort to move it afte=
r
> pivot root, it's a little code
> or script and in space which will be released.

On the pid files I see your point.  Not that it changes the problem, but
it does at least point out that more needs to be done and that the
current solution is incomplete.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigFD8066DBFFD6F9004F11064A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoadIACgkQg6WylM+/8ZSM9ACeNJlQ3d4vNn6Yu+qX7uaH3zan
GikAn0+YUXqZTYqFyD03feJ5k2+ewfk0
=oka3
-----END PGP SIGNATURE-----

--------------enigFD8066DBFFD6F9004F11064A--
