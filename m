From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: fix resize of array component size to > 32bits
Date: Wed, 29 Oct 2014 11:05:03 +1100
Message-ID: <20141029110503.7400e4a7@notabene.brown>
References: <1414198502-10167-1-git-send-email-jmaggard10@gmail.com>
	<20141029091957.1c4cdeae@notabene.brown>
	<CAKgsxVQJp7C0_y9ZENG_ZpaSk9Zi0Aa1cf0-qwRFcHx1HB5v0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0mV4Jl98tOSIMz/TEpTNanN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKgsxVQJp7C0_y9ZENG_ZpaSk9Zi0Aa1cf0-qwRFcHx1HB5v0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0mV4Jl98tOSIMz/TEpTNanN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2014 16:47:06 -0700 Justin Maggard <jmaggard10@gmail.com>
wrote:

> On Tue, Oct 28, 2014 at 3:19 PM, NeilBrown <neilb@suse.de> wrote:
> > On Fri, 24 Oct 2014 17:55:02 -0700 Justin Maggard <jmaggard10@gmail.com>
> > wrote:
> >
> >> If the request --size to --grow an array to is larger
> >> than 32bits, then mdadm may make the wrong choice and
> >> use ioctl instead of setting component_size via sysfs
> >> and the change is ignored.
> >
> > Can you explain exactly why the  current code is not sufficient?  When =
does
> > it fail?
> > If you include the explanation in a re-submission of the patch, and I am
> > convinced, then I will gladly apply your patch.
> >
>=20
> To be honest, I can't figure out how the current comparison would have
> ever worked at all. To illustrate, here's a simple test program:
> -----
> $ ./test 0xfffffffff
> cast comparison did not detect truncation
> bit comparison detected truncation
>=20
> $ cat test.c
> #include <stdio.h>
> #include <stdlib.h>
> #include <stdint.h>
>=20
> int main(int argc, char **argv)
> {
> unsigned long long ssize =3D strtoull(argv[1], NULL, 0);
> int asize;
>=20
> asize =3D ssize;
> if (asize !=3D (signed)ssize)
> printf("cast comparison detected truncation\n");
> else
> printf("cast comparison did not detect truncation \n");
> if (ssize & ~INT32_MAX)
> printf("bit comparison detected truncation\n");
> else
> printf("bit comparison did not detect truncation \n");
>=20
> return 0;
> }
> -----
>=20
> I plugged lots of numbers in there, and I was never able to get the
> current cast comparison to see a difference.
>=20
> I ran into the issue by trying to grow the component size of a RAID
> array from 1TB to 3TB, and it wouldn't work if I specified the size;
> only using "max" worked.
>=20
> I'm happy to re-submit if you'd like; I just thought it was a pretty
> straightforward bug.  I guess what I'm saying is, I don't understand
> why there *should* be a difference between assigning a unsigned long
> long to an int variable, and casting that unsigned long long to a
> signed type.  But
>=20
> -Justin
>=20
> > Thanks,
> > NeilBrown
> >
> >>
> >> Instead of using casts to check for a 32-bit overflow,
> >> just check for set bits outside of INT32_MAX.
> >> ---
> >>  Grow.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/Grow.c b/Grow.c
> >> index a9c8589..a614102 100644
> >> --- a/Grow.c
> >> +++ b/Grow.c
> >> @@ -1818,7 +1818,7 @@ int Grow_reshape(char *devname, int fd,
> >>               if (s->size =3D=3D MAX_SIZE)
> >>                       s->size =3D 0;
> >>               array.size =3D s->size;
> >> -             if (array.size !=3D (signed)s->size) {
> >> +             if (s->size & ~INT32_MAX) {
> >>                       /* got truncated to 32bit, write to
> >>                        * component_size instead
> >>                        */
> >


Thanks.
Looks like I broke it in July.

http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D4e9a3dd16d656b=
269f5602624ac4f7109a571368

I probably should have made it
    if (s->size !=3D (signed long long)s->size)

I've applied your patch.

Thanks,
NeilBrown

--Sig_/0mV4Jl98tOSIMz/TEpTNanN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFAvLznsnt1WYoG5AQIJwg/+KOfqHxykpKYdpKxEvb9p5LSINEStmfmG
fGxHQwAI7kwLiRw93qF/7XTxcXrwaq94hoSM7klVfpf2xnl9LK+/BjePPRbhCtFu
pWkko4MfBQbq/z4V52oygc0X0SJxi8ytWcZp6gCLpLNSZq3QwKjMn5zlWkaPe6QW
SI/ZjP4bY/w5PJ/qeZA/wX8qiLykquMLkRqxK+enad6tjMSw/0nDMQhVhfT0Jvnp
u2bNDQmmJefrbL+NDEEYNYEN/vRjOctic2sjhDEx1FQNxbk5caCtEVPOPR4Papso
uEYYM+CLcFVlREUn5gAvTLoru4jps0GxnpcvppfKUBvDYPAYDipuWVXMPRJIif5o
KwL3P1ISYXWbQetS6XEtZBgqPznsqnUqcFSi4zSxe+JXNG0vtO3a4MQa1ZX7BzIV
BnbbFKo1m0T3W3FiWXAo3WwLQwXfLZzqAWrm7f3L7aa/69pNAgThqsPz3bkjvKqa
mo2yRKQnIsf5B/vMtuCikjJDf53WZ76tmBLQ0XrZaZyYbRrHBDQA56lRgN+zuuHE
fBWJ6fPQzLWdGQEPaARu3a5Vxk81Q8LqKXJ+duVp8O7ee4PvSET7VgAxlUStfpK+
99gnCvjFgCLUAIsykWqOTupHTAP3EsKI4KURts3awfrb4NGYSDjG712GY8wsxsGF
4MXgyiqA1Nw=
=1Nkx
-----END PGP SIGNATURE-----

--Sig_/0mV4Jl98tOSIMz/TEpTNanN--
