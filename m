From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 00/11] Memory/resource leaks and unchecked return fixes
Date: Tue, 1 Nov 2011 14:57:15 +1100
Message-ID: <20111101145715.2229e964@notabene.brown>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/25NpGkBnf0F3QAZKZrJI8mz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/25NpGkBnf0F3QAZKZrJI8mz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 15:02:28 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> This is another pile of patches to fixup memory leaks and buffer
> overflows found in the coverity run.=20

Thanks Jes,
  I have applied all of these.

NeilBrown



>=20
> Cheers,
> Jes
>=20
>=20
> Jes Sorensen (11):
>   Fix memory leaks in reshape_array()
>   Fix memory leak
>   Fix memory leak
>   Fix memory leak of 'st3' in array_try_spare()
>   partition_try_spare() use closedir() to release DIR * returned by
>     opendir()
>   Fix memory leak
>   Add missing return in case of trying to grow sub-array
>   Avoid memory leak
>   policy_add(): Add missing va_end()
>   Write_rules(): Avoid stack corruption if using extremely long udev
>     pathname
>   mdmon(): Error out if failing to connect to victim monitor
>=20
>  Assemble.c    |    1 +
>  Detail.c      |    1 +
>  Grow.c        |   16 ++++++++++++++--
>  Incremental.c |    6 +++++-
>  mdmon.c       |    8 +++++++-
>  policy.c      |    4 +++-
>  super-gpt.c   |    4 +++-
>  super-intel.c |    1 +
>  8 files changed, 35 insertions(+), 6 deletions(-)
>=20


--Sig_/25NpGkBnf0F3QAZKZrJI8mz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq9uGznsnt1WYoG5AQI8Hg/9HPkNGec/KaE8+tOuqugFTsgA74WD03MC
Szn5nemQw8HdcYgYu/+u6StRUaty4tXYDuEmx9ARPC+oYLJEFrR3CfpbjKb/etvt
YyZErUHpJXoDYEFvPmjEK9+0Jdaw2lkxpq9+/xVkH5Dt7+nPcE06FCDJQb/OgRHQ
usPWcwtrLDbHXw7r9iqYyg3J5qwklRTxIndrD1if3uXQabsIopwqGq4Z4z8dgDpi
yHaNzDbiMvVTf6yFHeRmDylvgzatEoFOxcuI/iGm1hZc1lkbvxs94FG0h2jqcBiF
++YHKlPjdK/0yRREGUILPVHlWeBYyrWdywEFvCxTpObJimVdeNc04aYppllKcJke
87c0wcRnI3Ld1YL49P/bwqy914II0olMTnRPLoy1bWjv/SonJ56cFfQBLan8remm
+jZ2guB8Civxx7XBhn7pFB6E/gbQFAV9XAy6C9qNndoTOcNU8ROae9G0ORtosLef
1JSmEFShcSz8tN3gzfXYqGPtG3r3SWox6+RC3aq1aP9AuGYq2HlVKl/qXHZzc7mk
3T0mSpmz60PvriSYi0g6eXmTqIzl0qIKImQR8TtUIEeXJfTMygn2sucBUDq1kEh1
iA+z41WOSL7SZPIQOeAUV1XNVG+LnSquE2vfDEAiKPN6vjutboSas6rX04ZsPhhm
N8UQZwi+zm8=
=I77k
-----END PGP SIGNATURE-----

--Sig_/25NpGkBnf0F3QAZKZrJI8mz--
