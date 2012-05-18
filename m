From: NeilBrown <neilb@suse.de>
Subject: Re: Hot-replace for RAID5
Date: Fri, 18 May 2012 13:45:55 +1000
Message-ID: <20120518134555.3a9ce08b@notabene.brown>
References: <CAAOsTS=4+eqRJXVrw2OaYibgNTEaGxJx4x1PPN4iU49tUO9zOg@mail.gmail.com>
	<4FAB6758.5050109@hesbynett.no>
	<CAAOsTSm9RH1c6OzFdAGf8hSag35YBD5Y1SuH4Tq-4GXnWgJpAw@mail.gmail.com>
	<20120511105027.34e95833@notabene.brown>
	<4FB43977.8020607@volatilevoid.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j0q2A4Kp6S8+j5cc8c.z2N3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB43977.8020607@volatilevoid.net>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver@volatilevoid.net>
Cc: patrik@dsl.sk, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/j0q2A4Kp6S8+j5cc8c.z2N3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 May 2012 01:34:15 +0200 Oliver Martin <oliver@volatilevoid.net>
wrote:

> Hi Neil,
>=20
> Am 11.05.2012 02:50, schrieb NeilBrown:
> > Doing an in-place reshape with the new 3.3 code should work, though wit=
h a
> > softer "should" than above.  We will only know that it is "stable" when=
 enough
> > people (such as yourself) try it and report success.  If anything does =
go
> > wrong I would of course help you to put the array back together but I c=
an
> > never guarantee no data loss.  You wouldn't be the first to test the co=
de on
> > live data, but you would be the second that I have heard of.
>=20
> I guess I'll be taking 2nd place then. I just used it on three live=20
> raid6 arrays, and it worked perfectly.

3 arrays - so you are 2nd, 3rd, and 4th :-)

Thanks.  I often get failure reports and only more rarely get success
reports, so I value them all the more.

NeilBrown


>=20
> Thanks for your all your awesome work!
>=20
> Oliver
>=20
> PS: I wasn't subscribed to the list before, so I'm trying to reply to=20
> this via gmane. No idea if this preserves all the list headers - if I=20
> break the thread, that's probably the cause.


--Sig_/j0q2A4Kp6S8+j5cc8c.z2N3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7XF8znsnt1WYoG5AQI0zxAApdYWtlU2lo/900C8WetPF97Av0RXvi4E
1tNetwEeJXogSqjtoJ9gzPzRfk5lG6QiGf3o+XOOFBaz4XbG2br/KA3o+fzUi99V
jaEwc+EJ9Jf0hgn6MvpojqDqtJTkAYe6MFmL244/te0zyebBY/mf4X8y8Z/P4uyp
EBL2Ao8T1NRxZIhUNev0Y02dl/JIooPqG7l7JEcmvMjz7mi2MMRmPQXnpVGxGGm+
s9jSGcIHMzhsLVk4aSQFK3gvVfnEYk+MIOjGuNTbjtWYlLvUbcbkPpvUzK9bHz5O
xrLlFSvNdELzllsQep19UWG0P4jx6XEPc4QeD8kZjajUVaE3cVYtNa6L7yrKW6Zb
suI3v1fC1aJ2nJXfkhHauF54wrhzB2+CK2SFWJ2aSouTUEdDq1DuPjWNELmEm+Qu
g7q6OuzRE8vZl6m+Hf6qeawV1hdzv3QODriJFOi7IqCOaVAzYcz4suERMR7b7IRS
eByzzK9VnTP3q4W924XoTF6vynrg63nNtnxQJKWYhd20Jry/rCQFhUGXMYp8c7uY
+dyJurqyJT3w2oLEZmuJ/eJBGHouldvolp64fFCxSLzh6ObFlM6jNvtI56sLbrQU
9EGSMEkC4U6WoXMyxCbt9ydEHIFey7vT4qjW3lvyZu+xiGmPMO5pfLkso1bLsFnZ
d/zlE3nQUg4=
=IH3b
-----END PGP SIGNATURE-----

--Sig_/j0q2A4Kp6S8+j5cc8c.z2N3--
