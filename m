From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-3.1.1 segfaults when mdadm -G -Z
Date: Mon, 1 Feb 2010 09:17:25 +1100
Message-ID: <20100201091725.2023091c@notabene.brown>
References: <4B49C47A.9060800@mejor.pl>
	<4B49DA75.8090404@matfyz.cz>
	<4B49DBFA.1090508@mejor.pl>
	<20100130095611.GC15471@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100130095611.GC15471@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Marcin =?UTF-8?B?TWlyb3PFgmF3?= <marcin@mejor.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Jan 2010 10:56:11 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Sun, Jan 10, 2010 at 02:54:02PM +0100, Marcin Miros=C5=82aw wrote:
> >W dniu 2010-01-10 14:47, Zdenek Behan pisze:
> >>        -Z, --array-size=3D
> >>               This is only meaningful with --grow and its effect i=
s=20
> >> not  per=E2=80=90
> >>               sistent:  when  the  array  is  stopped an restarted=
 the
> >> default
> >>               array size will be restored.
> >
> >Yes, i missed it.
> >
> >> You didn't supply any argument to -Z at all, or to be precise, you
> >> supplied /dev/md6 as the argument, whereas you should have put in =
the
> >> array size.
> >>=20
> >> Also, another thing I have noticed lately is, that _some_ short op=
tions
> >> seem to be somehow oddly broken on my system and not accepting
> >> arguments, even if they are supposed to be. If the segfault persis=
ts
> >> after using the correct syntax, try using the long opts instead. I=
 was
> >> planning to dig more into this bug myself, so I might just kick se=
lf to
> >> do it now.
> >
> >long option, with suplied array size works correctly, so indeed prob=
lem
> >is in short option.
> >Thank you!
> >Regards.
>=20
> attached patch fixes it.

Applied, thanks.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
