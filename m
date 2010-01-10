From: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>
Subject: Re: mdadm-3.1.1 segfaults when mdadm -G -Z
Date: Sun, 10 Jan 2010 14:54:02 +0100
Message-ID: <4B49DBFA.1090508@mejor.pl>
References: <4B49C47A.9060800@mejor.pl> <4B49DA75.8090404@matfyz.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B49DA75.8090404@matfyz.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 2010-01-10 14:47, Zdenek Behan pisze:
>        -Z, --array-size=3D
>               This is only meaningful with --grow and its effect is=20
> not  per=E2=80=90
>               sistent:  when  the  array  is  stopped an restarted th=
e
> default
>               array size will be restored.

Yes, i missed it.

> You didn't supply any argument to -Z at all, or to be precise, you
> supplied /dev/md6 as the argument, whereas you should have put in the
> array size.
>=20
> Also, another thing I have noticed lately is, that _some_ short optio=
ns
> seem to be somehow oddly broken on my system and not accepting
> arguments, even if they are supposed to be. If the segfault persists
> after using the correct syntax, try using the long opts instead. I wa=
s
> planning to dig more into this bug myself, so I might just kick self =
to
> do it now.

long option, with suplied array size works correctly, so indeed problem
is in short option.
Thank you!
Regards.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
