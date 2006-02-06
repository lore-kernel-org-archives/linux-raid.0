From: David Liontooth <liontooth@cogweb.net>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs running
Date: Mon, 06 Feb 2006 08:45:41 -0800
Message-ID: <43E77D35.1040905@cogweb.net>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com> <43E68D62.4080704@cogweb.net> <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mattias Wadenstein wrote:

> On Sun, 5 Feb 2006, David Liontooth wrote:
>
>> In designing an archival system, we're trying to find data on when i=
t
>> pays to power or spin the drives down versus keeping them running.
>
> Hitachi claims "5 years (Surface temperature of HDA is 45=B0C or less=
)
> Life of the drive does not change in the case that the drive is used
> intermittently." for their ultrastar 10K300 drives. I suspect that th=
e
> best estimates you're going to get is from the manufacturers, if you
> can find the right documents (OEM specifications, not marketing blurb=
s).

"Intermittent" may assume the drive is powered on and in regular use an=
d
may simply be a claim that spindle drive components are designed to fai=
l
simultaneously with disk platter and head motor components.=20

Konstantin's observation that "disk die about evenly from 3 causes: no
spinning (dead spindle motor power electronics), heads do not move (dea=
d
head motor power electronics), or spontaneusly developing bad sectors
(disk platter contamination?)" is consistent with a rational goal of
manufacturing components with similar lifetimes under normal use.=20

> For their deskstar (sata/pata) drives I didn't find life time
> estimates beyond 50000 start-stop-cycles.

If components are in fact manufactured to fail simultaneously under
normal use (including a dozen or two start-stop cycles a day), then
taking the drive off-line for more than a few hours should
unproblematically extend its life.

Appreciate all the good advice and references. While we have to rely on
specifications rather than actual long-term tests, this should still
move us in the right direction. One of the problems with creating a
digital archive is that the technology has no archival history. We know
acid-free paper lasts millennia; how long do modern hard drives last in
cold storage?  To some people's horror, we now know home-made CDs last =
a
couple of years.

Dave






-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
