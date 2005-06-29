From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 20:00:03 +0200
Message-ID: <20050629180003.GB6431@inara.maison.net>
References: <1120061430.21458.236.camel@volt> <42C2CEF0.7030108@h3c.com> <1120066268.21458.252.camel@volt> <20050629174943.GA6431@inara.maison.net> <1120067521.21458.261.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1120067521.21458.261.camel@volt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* John Rowe (rowe@excc.ex.ac.uk) [20050629 18:52]:

> None of it is very modern - it's put together from what we had
> lying around :-(

It is most likely that the controllers (and/or respective drivers)
are the source of your problem.  I'd say the controllers are
UDMA(66) only.

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
