From: NeilBrown <neilb@suse.de>
Subject: Re: PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
Date: Fri, 24 Apr 2015 11:55:11 +1000
Message-ID: <20150424115511.2bd1cde4@notabene.brown>
References: <55398462.1000202@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/32UPxLLIIHoNe69+k2XiY4S"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55398462.1000202@cox.net>
Sender: linux-raid-owner@vger.kernel.org
To: Charles Bertsch <cbertsch@cox.net>
Cc: linux-raid@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

--Sig_/32UPxLLIIHoNe69+k2XiY4S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Apr 2015 16:46:42 -0700 Charles Bertsch <cbertsch@cox.net> wrote:

> 1.  PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
>=20
> 2.  Description.  Using linux-3.18.5, linux-3.18.7, and linux-4.0 a=20
> two-drive jbod created using one 3TB drive and one 160GB drive will=20
> SOMETIMES hit a BUG call at linux-4.0/fs/buffer.c:3220

By "jbod" I assume you mean "linear array".

You say this happens without any filesystem on the array, yet the stack
traces clearly show ext2 in use.
Maybe some weird interaction is happening between the the filesystem and the
linear array.
But please confirm that the stack trace happened when there was no filesyst=
em
on the array you were testing, and report what filesystems you do have which
use ext2.

Is there any chance you could use "git bisect" to find out exactly which
commit introduced the problem?  That is the mostly likely path to a solutio=
n.

Thanks for the report,

NeilBrown



--Sig_/32UPxLLIIHoNe69+k2XiY4S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVTmifznsnt1WYoG5AQIVSg/9Fizq4P+O3+azdeCw/fBttQ0T6wU4La9u
uC1yjcUpPUne3n5MaRTsusRBoaM6fC2wEr83TRVqGnefR+Hopbmr7o79kFBkLlMZ
i41ZIypaC+a4PQQzwE4f+AMvltP5w+MvdLF61NgK4xGXOJRfOZ/WwDw8Oke3THnV
6iTsXvCCRCd8EtQXaVNpAm/xaig5u9o5tNvfZfoqx7XVWUU9E7N16/DL3jncp8Lp
I3tZyEpQ9YreEiWOlKDsfz58qJV1iTx4fBz8OiKclzmUJ9PAcZvPSNAImoez4+7w
p1kA+feCcCmSeeMwYBrC04pgyI0EyfutwAyUhOOvK+yNNlh9zhPCA7YspupT3RDI
sjwuqsEWPHR74iGsd+dD5Ta3xNGIVLxGrPyLJ07CwYRI+d5DCFdWid8b7B/mVMz3
/xauJDGE4MSM5ep+8c9Rn3RejEtuGIJJgsdWGW5YwzOqvE9nVs98pUOIyABW7Xkj
AW9MrPBAW6LKXQbif5OhoBf0ca7bKUnP7l6vKyCzq5BMQVyFQ3DRBsbYYoZyHeTv
BDeFP3tBuTYpp7D5Z6PvEAmjBqAxYQVUFh2tfXoJ00fVOsdezua4XBV3Rvdz975g
dvTgG1Enld7jj/vIhpsApmSlPPWzICOJGU+5ocrRgd6e92zGgJYoRYKNeCv6HPaF
tR+IcGabMW4=
=qYps
-----END PGP SIGNATURE-----

--Sig_/32UPxLLIIHoNe69+k2XiY4S--
