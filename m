From: Andy Smith <andy@lug.org.uk>
Subject: Re: confused Re: swap on RAID (was Re: swp - Re: ext3 journal on software raid)
Date: Fri, 7 Jan 2005 02:28:42 +0000
Message-ID: <20050107022842.GL99565@caffreys.strugglers.net>
References: <20050106093811.GB99565@caffreys.strugglers.net> <Pine.LNX.3.96.1050106171610.13564A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eBrISAf9+LvsIqzQ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050106171610.13564A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eBrISAf9+LvsIqzQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 06, 2005 at 05:31:48PM -0800, Alvin Oga wrote:
>=20
>=20
> On Thu, 6 Jan 2005, Andy Smith wrote:
>=20
> > On Wed, Jan 05, 2005 at 09:04:00PM -0800, Alvin Oga wrote:
> > > On Wed, 5 Jan 2005, Mike Hardy wrote:
> > >=20
> > > > There are those that think if they size the machine correctly, they=
=20
> > > > shouldn't need swap, and they're right.
> > >=20
> > > bingo
> >=20
> > Yet in an earlier reply you state that your machines have swap
> > configured.
> >=20
> > There is a difference between these two statements:
>=20
> since you're implying/saying i said those two statements=20
> below ( a and b ):

No I was not implying that you said either of them.  Why is this hard
to understand?  Look at Mike's response to me; he understood what I
was getting at perfectly.  I was only trying to point out to you
that what you've said isn't consistent with things you said in other
posts.

> you are one totally confused dude ... sorry to say ...

Look.   It is quite simple.

Mike above (which I leave quoted so you believe me) said:

        There are those that think if they size the machine
        correctly, they shouldn't need swap, and they're right.

To which *you* replied:

        bingo

*However* in an earlier mail in this thread you said that your
machines do have swap configured.  Mike has already clarified that
he meant that these people say that no swap needs to be configured.

So my point was that while you say "bingo" to Mike, you do not in
reality do as Mike describes.

> i never said either of those two statements ... that is yur words
> and you're understanding of some mixture of lots of comments

They were indeed my words and I never claimed otherwise.

> 	=3D=3D grep "under normal load" sent-mail raid =3D=3D
> 	( pick any set of words of your "quote" for grep )
>=20
>  	- it's not even in anybody comments posted, since i save
> 	all of my posts ( in sent-mail ) and not in anybody elses=20
> 	replies that is saved here
> 	( thus my comment ... you're confused .. )
>=20
> please refrain from making (re)quotes .. i didn't say so that
> i don't have to reply

I didn't attribute any words to you.  I quite clearly said
they were my interpretation.  A direct quote:

        There is a difference between these two statements:

                a) I need some amount of swap configured but don't
                expect a significant swap usage under normal load.

                b) I expect my server to always be using a
                significant amount of swap.

        I interpret your views as (a) but I interpret Mike's as
        "there are people who are saying that a correctly sized
        machine can have zero swap configured."

You now go on to say:

> i personally do not expect any system i'm involved with to use any
> swap and if it does, i'd be adding more memory, as soon as they
> complain its running too slow when xxx or yyy job is running
> 	- they have choices of what they want done about it

Which appears to me to be pretty much exactly what (a) above says.
So I'm at a loss to understand why you bothered to write this email
complaining about being misrepresented.

Now that we have in one email original unedited quotes of you saying
you agree with someone who suggests configuring no swap, and then
quotes of you saying you do configure swap, I hope you will now
concede my point that you are being inconsistent.  If you don't
agree, fine, I'm confident that what's been said speaks for itself
and don't feel like pursuing the matter further.  Especially if it's
going to result in you telling ME that I "must be an idiot" and am
"confused."

> and it is NOT the same thing ... "not using swap" vs not creating one

Yes, exactly my point from two emails ago.

> 	- i don't use swap and i rather the system not use it ...
> 	but i do create an itty bitty 250MB of swap partition=20
> 	even if there's is 2GB of system memory

So you do configure swap, this is now my point from 3 emails ago.

Why it has taken 3 *long* emails to get you to answer one simple question
and concede a blatant inconsistency in your argument is beyond me.

--eBrISAf9+LvsIqzQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB3fPaIJm2TL8VSQsRAn3VAKCINLmzG/AABhJm+VdPcJ4MCx2tCwCeNR6c
LDWa3Q1X7/l/1N+o+BVV7qo=
=xQEK
-----END PGP SIGNATURE-----

--eBrISAf9+LvsIqzQ--
