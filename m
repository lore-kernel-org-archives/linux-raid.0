From: NeilBrown <neilb@suse.de>
Subject: Re: [PULL REQUEST] two md updates for 3.3
Date: Thu, 29 Mar 2012 10:31:42 +1100
Message-ID: <20120329103142.7d76adb7@notabene.brown>
References: <20120209121613.3392fb87@notabene.brown>
	<CAGRgLy7Dq9g8Bj2_vWu5iYk9gboZ42nyswQNX4g6ziWMDou1Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X=zVErtIvcDPjaJ0e03/3Bs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7Dq9g8Bj2_vWu5iYk9gboZ42nyswQNX4g6ziWMDou1Eg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids

--Sig_/X=zVErtIvcDPjaJ0e03/3Bs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 15:33:51 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> aren't those resync fixes the ones we had a long discussion about?

I don't remember... they came up more recently, but maybe they relate to an
earlier discussion.

> Do you think those could be backported to 3.2 (which is picked by
> Ubuntu Precise)?

I don't object - feel free to forward them to stable@vger.kernel.org

NeilBrown

>=20
> Thanks,
>   Alex.
>=20
>=20
> On Thu, Feb 9, 2012 at 3:16 AM, NeilBrown <neilb@suse.de> wrote:
> >
> > Hi Linus,
> >
> > The following changes since commit 307729c8bc5b5a41361af8af95906eee7552=
acb1:
> >
> > =A0md/raid1: perform bad-block tests for WriteMostly devices too. (2012=
-01-11 08:35:17 +1100)
> >
> > are available in the git repository at:
> >
> > =A0git://neil.brown.name/md/ md-3.3-fixes
> >
> > for you to fetch changes up to db91ff55bdf06736b849afc1b1fce5763bbb8d5d:
> >
> > =A0md: two small fixes to handling interrupt resync. (2012-02-07 12:01:=
51 +1100)
> >
> > ----------------------------------------------------------------
> > (from the branch description for md-scratch local branch)
> >
> > for-linus
> > Some simple md-related fixes.
> >
> > 1/ two small fixes to ensure we handle an interrupted resync properly.
> > 2/ avoid loading the bitmap multiple times in dm-raid
> >
> > ----------------------------------------------------------------
> > Jonathan Brassow (1):
> > =A0 =A0 =A0Prevent DM RAID from loading bitmap twice.
> >
> > NeilBrown (1):
> > =A0 =A0 =A0md: two small fixes to handling interrupt resync.
> >
> > =A0drivers/md/dm-raid.c | =A0 12 +++++++++---
> > =A0drivers/md/md.c =A0 =A0 =A0| =A0 =A05 +++--
> > =A02 files changed, 12 insertions(+), 5 deletions(-)
> >
> >
> > Thanks,
> > NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/X=zVErtIvcDPjaJ0e03/3Bs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3OfXjnsnt1WYoG5AQLrow/6AtUNW+zBcB5i4L7J7Csx2OlqlpIkYECD
+KC/VuIZqly+wLZDG2UvrsmN47yUAe3gHimPQIMTKA/6cRarQqCsXTls3Xe6d5ex
9H76iFQDs2Gyjh4/HD25uyPGG5Frv3PxZePtpbBQ5Ss+blyV6c1uC9LwAIebIwlj
7w1aMXP/vC/GkdkoqpzMERUWpSCi1qAZm7ZtldpSCEYbL47dYIICelqUr9QA7jvD
vPid2vXmxMOwIFtJ1HOdWC75Degz7n7BLT98qYepkk1i/IQWKknNDi6pMFjOv0fX
7SrIm/41dAsSGWKFdIvHtZ4+ectWBV5m8mQSJpS6qGua0Fl8DkWcbyaQMs2wQ0c8
c/Nmj6Lb/FT7tgON40ZPo5mCL3mbhH5VayWWLprOfE1UHQvVbOf6jZ6SDZLeBWAX
w9QnGMtq08vQB8nd4WLigYvLFuu0w1w+U6xNspurS+Dk09U7bSO5Bi7xmI/IH9Kt
wBOssSW3VY9eoJUy//6ZsiPkaq5qfQd00Q/UAO8gxNX2EhoYLs9zBnu5wVPvk1mg
VJ229XOkFEGnz/3IGMFLyLNGOhlL5iImFsqFFEks6pxYYfg9GBCj/i+dcBfN+S65
Ip7nTyCOxA9mRVRH6u+ME+TR3er2OBIDpvD8nkc5o5hrnEslQWbAKxjnTtHLmNk9
WpmtXxUr8ck=
=q6GI
-----END PGP SIGNATURE-----

--Sig_/X=zVErtIvcDPjaJ0e03/3Bs--
