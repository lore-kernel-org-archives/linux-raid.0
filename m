From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 19:49:43 +0200
Message-ID: <20050629174943.GA6431@inara.maison.net>
References: <1120061430.21458.236.camel@volt> <42C2CEF0.7030108@h3c.com> <1120066268.21458.252.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1120066268.21458.252.camel@volt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* John Rowe (rowe@excc.ex.ac.uk) [20050629 18:31]:

> Timing buffered disk reads:  64 MB in  3.13 seconds =3D 20.45 MB/sec
> Timing buffered disk reads:  64 MB in  3.85 seconds =3D 16.62 MB/sec
> Timing buffered disk reads:  64 MB in  4.31 seconds =3D 14.85 MB/sec
> Timing buffered disk reads:  64 MB in  4.79 seconds =3D 13.36 MB/sec
> Timing buffered disk reads:  64 MB in  2.73 seconds =3D 23.44 MB/sec
> Timing buffered disk reads:  64 MB in  2.72 seconds =3D 23.53 MB/sec

These are very low values.  A modern 250G drive should exceed
50MB/sec.  What kind of IDE controller do you use?

Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=C3=A9ter     /       \       /       \     Peter.Kelemen@cer=
n.ch
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
