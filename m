From: NeilBrown <neilb@suse.com>
Subject: Re: RAID10 Write Performance
Date: Wed, 23 Dec 2015 13:20:49 +1100
Message-ID: <87wps529dq.fsf@notabene.neil.brown.name>
References: <CAHkw+LdtZY=d6kCtaTe5Uu8nNXOgF+yCAjJeHWJ2TrVAuNoDeA@mail.gmail.com> <CAHkw+LeVkGo8cOGMzQbq7sGtw5K9bc3CMOvurL0kjDf0ZWTfsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+LeVkGo8cOGMzQbq7sGtw5K9bc3CMOvurL0kjDf0ZWTfsA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 23 2015, Marc Smith wrote:

> Solved... appears it was the write-intent bitmap that caused the
> performance issues. I discovered if I left the test running longer
> than 60 seconds, the performance would eventually climb to where I'd
> expect it. I ran 'mdadm --grow --bitmap=none /dev/md0' and now random
> write performance is high/good/stable right off the bat.

Keeping a write-intent bitmap really is a good idea.
Using a larger bitmap chunk size can reduce the performance penalty and
preserve much of the value.  It is easy enough to experiment with
different sizes.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWegUBAAoJEDnsnt1WYoG5GCQP/1fG7hTXO1HH6DQ8VZf4ydyA
f2NcgdQk3d4WE4JTME5r20OddwJc5Vk/a49F5Muw3+0my0JNtQWNO/LrNLpIkmKZ
Q9xo6meazaPM09emlLBIamjIZOMqRr5Uy/n8rbECz4mLTSOX77Js04ZLwSomicMl
LuD/j60d2ncx6S5UZO8Q+1QGy+SpPcEKSxxKJmNTFWqe5VI0ROJkFMRkO6pKDWph
Xo5FMNVN8iLRzbZs0uyEbFyRuAkMCl05j4JTAmeYp87/rKXQqWJxE7mPipux18LD
+sVNsVOptsilQZQp6Ykh4Amry+o2mIKdZ8FE6ySuTTN91CTDy0YOMi2gQoIxoAGE
jnT+xEHbNFyH+Kv7y2rKGqDtUpfad4OVg2KLeWBTHDvUFnGlZRIeyJoDzipYHJz3
l4XiQ1pAIuSsq+lCrf+mHYJT9nRbFQql0t/KafsIFbs864W1HezPKbjgYE2qQIJW
4TBKXNR7D2bvGQpF8hk9bIfdjEs7bs1aiD/+mOhGOSO96zLH++L2aHdC2AFvSonw
ojPdw2kP9zW85am6Nc9j7KKDuDQmMveGETwb1iQWETJ82HPivl0APUi2CAr8PGwI
EfthU7KyIzPDzn+qK4hvm2xFwTouHPSM+3Z/BF7hhZ348jQkkDdnPYQSuALsTX3g
qetkLWsenYOAozHhMway
=q9B0
-----END PGP SIGNATURE-----
--=-=-=--
