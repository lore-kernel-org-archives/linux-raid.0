From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/13] Add missing handling of malloc() failure
Date: Thu, 27 Oct 2011 15:49:26 +1100
Message-ID: <20111027154926.4d5e8fef@notabene.brown>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qDTjhgz.Q_Gav378DX2yOfX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qDTjhgz.Q_Gav378DX2yOfX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 17:30:13 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> I cam across a couple of these last week while I was chasing the
> assemble problem of IMSM raids, so I started going through the code to
> fix up some more of these.
>=20
> This is just low hanging fruit, and there is more to be done, but at
> least it's a few fixes.

Hi,

 I'm not at all sure this sort of thing is worth it.
 There is no guarantee that the memory is actually there when malloc returns
 non-NULL.  You might only get a page mapped when you access the memory, and
 equally the failure could happen at that time.

 If there is something genuinely useful that can be done when malloc fails,
 the it might make sense, but just printing a message an exiting seems
 pointless.

 If we were to go that route, I would probably want to use a #define to
 replace everything with a wrapper (xmalloc??) that printed a message and
 failed.

 Do you have a strong reason to add these checks?

Thanks,
NeilBrown


>=20
> Cheers,
> Jes
>=20
>=20
> Jes Sorensen (13):
>   count_active() catch malloc() failure
>   Catch malloc() failures
>   Try to catch malloc() failures in Assemble.c
>   Attempt to catch malloc() failure in Detail.c
>   Handle malloc() failure in Examine.c
>   Handle malloc() errors in Manage.c
>   Fix malloc() failure handling in Monitor.c
>   Handle malloc() failures in devline()
>   Fix malloc handling in dlink.c
>   Handle malloc() failure in Grow.c
>   Handle malloc() failure in mdopen.c
>   Handle malloc() failure in mdstat.c
>   Catch malloc() failure
>=20
>  Assemble.c    |   37 ++++++++++++++++++++-
>  Detail.c      |   22 +++++++++++++
>  Examine.c     |    5 +++
>  Grow.c        |    7 ++++
>  Incremental.c |    4 ++
>  Manage.c      |   13 ++++++-
>  Monitor.c     |    7 ++++
>  config.c      |   99 ++++++++++++++++++++++++++++++++++++++++++---------=
------
>  dlink.c       |    6 ++-
>  mdopen.c      |    6 +++
>  mdstat.c      |    5 +++
>  policy.c      |    5 +++
>  util.c        |   19 +++++++++--
>  13 files changed, 200 insertions(+), 35 deletions(-)
>=20


--Sig_/qDTjhgz.Q_Gav378DX2yOfX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqji1znsnt1WYoG5AQIhvg/+M3TMJwz3k+QIAWxhk3CHwR/4EIZSOD4P
LwLvEdcsyFYtxK02fY9gfWXJYE5elKP3mlrtAQGE6AALtR6FfEFuBnPA5o7mDztB
pokjol+MgkP9hU2OMGAlGLySDfVdBnH7a0KAPT95VNqih7jVpVTgQcVSaVDhL3sr
zNv22ccvX5+YTyYiFpGMmYSjgc23Ikft6DV0QiBkWrW0nH/yWn6fiPhAjMujhy79
yG4BoTvZwHR2T6JOzk2IcGtYq5OplJLeXSYoet6Ydmao1KAAGsCEoCxk59fhJ6iX
5AmFU27gcCABmWb069SpEFNrepX3xAjc1cYGLJiuv/NHBBzM2gET5LdtcDzYCKN1
hfXzaMqagdO4E9bAXUZK8YANYLriPyQwfBPGQffwsLhIWGeXHmm4PuyyB+aOkGDE
UlDCgiaAQ8MU3GMEM51hkaf7GFdgSR05eRDeZN/RttS3Rp0prKtJvpm6FI1NuGhL
mWltmyDS3yCvMxnV0Hn9kWho+S3cdvVqfwwBgCzeES6GkmZjkymCf6AAo0iofGjJ
5niWf4jxHbRowZn2xrU3ra8y5+I1O5tvuXK5wdNXXg4FnQN0j5yBndK61KbWhpl+
MQAzh3wiskX/tnXYCXrhFDL1HX2j2zX7EOsgk+vdQV5MPyh3z3oykOsIo+a81Hq3
jJkOq/MnQDY=
=icCa
-----END PGP SIGNATURE-----

--Sig_/qDTjhgz.Q_Gav378DX2yOfX--
