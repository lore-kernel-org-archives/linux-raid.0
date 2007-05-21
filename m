From: thunder7@xs4all.nl
Subject: Re: not resyncing after power cut.
Date: Mon, 21 May 2007 22:03:25 +0200
Message-ID: <20070521200324.GB21027@amd64.of.nowhere>
References: <215ff4410705210808g779ba32dhee018f0bd81382d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <215ff4410705210808g779ba32dhee018f0bd81382d8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Fanning <christopher.fanning@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46rom: Chris Fanning <christopher.fanning@gmail.com>
Date: Mon, May 21, 2007 at 05:08:47PM +0200
> Hi,
>=20
> I've got a couple of doubts.
>=20
> Since more than a year ago I setup mdadm raid1 on new instalations
> (thanks for your work).
> On the older machines, mdadm -D shows them in a dirty state. I know
> that this is/was as expected. If there is a power cut, the machine
> boots and a dirty array is resynced, =BFright?
>=20
> On newer installations, mdadm -D shows arrays in a clean state. I had
> always thought that this was ok becuase I'd read somewhere that the
> term 'dirty' was causing confusion and it got changed.
> So, state: clean, is what I should expect?
>=20
If the newer machines have bitmaps on, the resync is generally faster
than finishing booting - so when you can log in, the array is clean
again.

Do they use bitmaps?

Kind regards,
Jurriaan
--=20
Look - either dualism sucks, or it doesn't.
Debian (Unstable) GNU/Linux 2.6.21-mm2 2x4021 bogomips load load 3.73
the Jack Vance Integral Edition: http://www.integralarchive.org
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
