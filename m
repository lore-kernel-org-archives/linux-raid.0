From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies
Date: Wed, 20 Aug 2014 19:19:15 +1000
Message-ID: <20140820191915.088eaa12@notabene.brown>
References: <fb820ed5-44e5-4596-b8d4-956027be204a@EXCHANGE.collogia.de>
	<20140820133658.1e8f1fb9@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735863EE95@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yD54en2.tTliJEhN_6Qp0rB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735863EE95@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/yD54en2.tTliJEhN_6Qp0rB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Aug 2014 08:13:27 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> > Von: NeilBrown [neilb@suse.de]
> > Gesendet: Mittwoch, 20. August 2014 05:36
> > An: Markus Stockhausen
> > Cc: linux-raid@vger.kernel.org
> > Betreff: Re: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies
> > ...
> > For future reference:
> >  - put "md" at the start of the subject line. e.g. "md/raid5:"
> >  - use "git show --format=3Demail" or some other incantation which
> >    avoids  indenting the description.  Also avoid the "commit"
> >    line.  Author: and Date: are redundant but I don't think they
> >    are actually hurting.
> >  - Be sure to include a Signed-off-by: line.  Find and read the DCO
> >    (Developer's Certificate of Origin) to know what that means.
> >    This patch is sufficiently trivial that I won't insist, but it is a =
good
> >    habit to get into (git commit --amend --sign --no-edit)
>=20
> Hi Neil,
>=20
> Good to know. Adapted my generator scripts for that. Do you want me to=20
> resend the RMW patches that way?

Probably -  I definitely want the s-o-b.  Wait 'til I've had a change to ha=
ve
a look though.

Thanks,
NeilBrown

--Sig_/yD54en2.tTliJEhN_6Qp0rB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/RoEznsnt1WYoG5AQK2Vg/+MYH4d6M7F4feJZUQyYebjpOBFQ6A1dbh
/xh6steeYZi/Qpf0UD9qGjA8M6zIusLIWV+20zVHkPZycXNjZ5KJrkIF8KUWyT7l
IAI+7DcHNNHWE5kxHgBfc2gCZ9HIfqSBns3iR8Ri1kLcY6NEAkBC0HzIGw4npkwv
M8Flxk3pkiMdHsP6Fr5bgwehQy9qxWnxiCfU2H0Ex1K1mUgWOuSJWvH0d9S6ga9f
+dCD9TUd/t3E3RC6MRPpY0TupIlRQvt6HiI4vu14zEKNPaEK48KoSFrVtoW8MvHV
8Xi/cOXaAP57pnHsqoXcVxgImTW8yRwWH9g5NDGq9C5qvquevZcjF4aEuS+TB26y
+iooIItMKPXBLszoEfIcjySh2p+kurpBqZhPyq248zRuhmMFheVFzuDwQ+fe5OmO
4QRZsEi5EyOXRiW6BeMSPeGb7RC78AxGkwX03AqNqB5cLdy4i4UDKGVlDby2Q+S9
JJuBPMLj+ahQm8w+3+LQVg8bQso+oRe4Dafqz+iHy6KnGoHi4T6EOdfTb0Fytc2M
eujcbIKCqDTp4+4FJcMDf98ZoUqSazCHN+YoFSGk/MAZCNZmRSL93f2qW1//F3qn
cRYUmnin8VzHhD4J0x09tr0jWGipxLJgXjCC1TFkGAJwUW1a0HDN/i/itW4o+353
TrGydZMPWnU=
=4sbu
-----END PGP SIGNATURE-----

--Sig_/yD54en2.tTliJEhN_6Qp0rB--
