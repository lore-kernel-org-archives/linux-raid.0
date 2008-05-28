From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Wed, 28 May 2008 19:57:52 +0100
Message-ID: <20080528195752.0cdcbc6d@core>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens =?UTF-8?B?QsOkY2ttYW4=?= <jens.backman@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, 28 May 2008 18:34:00 +0200
"Jens B=C3=A4ckman" <jens.backman@gmail.com> wrote:

> On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.=
com> wrote:
> > Results:
> >
> > http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> > http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>=20
> Either the RAID 1 read speed must be wrong, or something is odd in th=
e
> Linux implementation. There's six drives that can be used for reading
> at the same time, as they contain the very same data. 63MB/s
> sequential looks like what you would get from a single drive.

Which is fairly typical of a cheap desktop PC where the limitation is t=
he
memory and PCI bridge as much as the drive.

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
