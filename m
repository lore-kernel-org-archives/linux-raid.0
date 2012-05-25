From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Is "container" more efficient in terms of I/O op. numbers
 ...
Date: Fri, 25 May 2012 12:23:52 +1000
Message-ID: <20120525122352.07d186c2@notabene.brown>
References: <CA+sTkh55N8YKL5R-a70U9jYrj17hAdLbSoKPy-Xuz2-2S5_P0g@mail.gmail.com>
	<20120525101424.3cb40eb2@notabene.brown>
	<CA+sTkh68eo6by40uPYm7r+xVLLFRKvwSZYJji8x75cqW7JjJ9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YonUOi2wXjXVDpLgzulN_AS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh68eo6by40uPYm7r+xVLLFRKvwSZYJji8x75cqW7JjJ9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YonUOi2wXjXVDpLgzulN_AS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 25 May 2012 09:52:52 +0800 Igor Podlesny <for.poige+linux@gmail.com>
wrote:

> On 25 May 2012 08:14, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 24 May 2012 23:30:54 +0800 Igor Podlesny <for.poige+linux@gmail=
.com>
> > wrote:
> >
> >> =C2=A0 =C2=A0... then several "stand-alone" RAIDs on the same HDDs? --=
 Say, when
> >> using write intent bitmaps.
> >>
> >
> > I'm not sure you question exactly makes sense, but the answer would be =
"no"
> > if it did :-)
>=20
>    Well, due to disks seeks are expensive, hot data locality is
> preferable and valuable thing, isn't it?
>    And it makes sense not only for WIB, but other frequent metadata
> updates, doesn't it?
>=20

Thank you for fleshing out your question a bit.  It is always useful to sta=
te
your assumptions where asking a question as it makes it easier to understand
and answer the question.

The general metadata isn't updated very often - not often enough to justify
any particular concern for where it is placed.  For a 'reshape' it can be
updated more often, but that is an unusual situation.

bitmap metadata certainly can be updated often, but there is no container
format currently supported which makes use of write-intent bitmaps, so
thinking about containers for bitmaps is not relevant.

If it were, it would make sense to keep the bitmap close to the data that it
described, so having a container arrangement would not be better than
individual arrays.  It maybe be worse depending on the particular details.

Does that make sense?

NeilBrown

--Sig_/YonUOi2wXjXVDpLgzulN_AS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT77tODnsnt1WYoG5AQIi6xAAj4+4tuhKs2BoLeFgoBFHHWojJIPS4eaT
hVnNi8gP7jJ1ho3RmdOPH7HZmgG6/be36mwIqeJLIkKcnWwi4Go/vYJb/SqcyPlK
rl6aNpxdLMdV66wRYr7LWH4QnbVmirEdsTzFU702IhXN9w7lFNtKpT6gyU5eZg80
QDia2feooiCBgNZq0BhvJtVcQ7/1PO/bUZF80QMnZXy1raz7xgQxcUGNsXWRo/2A
RZIQEijBGNrUxsLNdrtwekPFggPFRkA3Jhf7prHqWVNj1KR/+n7DU+YtlmAUqCqv
G3FyS6gi6ktmmMs/T63sjFFe24eV+kp43IxIGw636AkFIXko1CU9AR0vMKDaGRl5
lEbgNpLfwJ9BNXDNQs9we+t77w/e40mL72Lwib70BHN2icl+BxuirG2//lLFFbE/
dIRT5M10tAevxpPQDkyZgAQf/xRg3MvLbflMeC3PUrkPezyRpYFIMSjcIWJcU7sa
cr3IeaUtd6VVzOmGIg6sOf5qMPu01XHpW8wuqcHolEuYiawEUzX4Ul89dCCfgAui
npt9SoXUwZHAY+DRqNY2Bo1b+rdkJ/KWmZmzUlqSC0jiFvaMltCUdcR4ESRq3bQ9
Z3LUH17iOlc99V0XGugzQhgPMvuEabdY9adIwCdGiMZlgF/rs9A1yszCSURbryhW
+sPevS7YtWU=
=6rC+
-----END PGP SIGNATURE-----

--Sig_/YonUOi2wXjXVDpLgzulN_AS--
