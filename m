From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Mon, 13 Feb 2017 20:32:43 +1100
Message-ID: <87a89q4ero.fsf@notabene.neil.brown.name>
References: <cover.1486485935.git.shli@fb.com> <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com> <87r336tw5l.fsf@notabene.neil.brown.name> <20170213073724.GA16666@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170213073724.GA16666@lst.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13 2017, Christoph Hellwig wrote:

> On Fri, Feb 10, 2017 at 05:08:54PM +1100, NeilBrown wrote:
>> I must say that I don't really like this approach.
>> Temporarily modifying ->bi_private and ->bi_end_io seems
>> .... intrusive.   I suspect it works, but I wonder if it is really
>> robust in the long term.
>>=20
>> How about a different approach..  Your main concern with my first patch
>> was that it called md_write_start() and md_write_end() much more often,
>> and these performed atomic ops on "global" variables, particular
>> writes_pending.
>>=20
>> We could change writes_pending to a per-cpu array which we only count
>> occasionally when needed.  As writes_pending is updated often and
>> checked rarely, a per-cpu array which is summed on demand seems
>> appropriate.
>
> FYI, I much prefer you original approach, it's much closer to how
> the rest of the block stack works.=20

I probably wasn't clear, but my intention was to stick with my original
approach, but make it more acceptable by removing the extra cost of
cache-line-bouncing that Shaohua correctly identified.
i.e. this patch was a preliminary to improve the original series.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlihfTsACgkQOeye3VZi
gblchw/9FvGF0UNqoOUJ50uEWWJ2NOLZBYtcKqtpg31MWFQsIQg2tdfJt962TqMv
lpIWd9u1vodZhVYDeCGdvl6giVbDJx0Nt3HBPF6c9JNfw9wL5tYUrgzOMdfWGBoR
HbGMwTGpjPXxqM2mgsaJp9MgchCPRXglfI9dvgKTbkx62uOM3WWkltO6i4+/thhl
USH4qXh+6COIROUDHARboyGW1Jzf5lDurMCImz5Yxn3ZE692qN0LGqlsOb0KfoCV
LTgBMxDqaYPIljJDzWDazSVDKMOWFQfy2kf2vEEsm8pwyi/nHULgoEDrr7V5U58N
MA0r8U7xrTXkvrn/8BPFX/Bsaj4/CxknqUkOaWbSotmyvEJMOVp3G/08kY/PIxJc
JgQosxvB1ukYx9ofwxOVlpea4stACkHZccT+vEUtGyao3iAxl96eRVQKYKKXw5VI
lXHsHNlIPGMWhMNlRfZYFb1PBNc20Kit76vQK0ca77IQsJ+KkkYXd0myf6FEfvBj
eFt9xFSleBeL00iUlhk7Axd9Gs2F9gTheINmTidQzBjfynvC2U2Muz7qAn4PKF+D
597OaWCaQsFUkzw3qQrKStYFu9jNjvdYKmXxz1j4KO6jU/z15yAPgWBI5kqBiSAZ
Ff+G0HDo0Ux23otxl10UHChGwCu2b57m4KN/c0yypC9VOhDlSmw=
=Diqu
-----END PGP SIGNATURE-----
--=-=-=--
