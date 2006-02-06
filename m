From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs running
Date: Mon, 6 Feb 2006 18:12:49 +0100
Message-ID: <fd8d0180602060912q6181d52bs@mail.gmail.com>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
	 <43E68D62.4080704@cogweb.net>
	 <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
	 <43E77D35.1040905@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E77D35.1040905@cogweb.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2006/2/6, David Liontooth <liontooth@cogweb.net>:
> Mattias Wadenstein wrote:
>
> > On Sun, 5 Feb 2006, David Liontooth wrote:
> > For their deskstar (sata/pata) drives I didn't find life time
> > estimates beyond 50000 start-stop-cycles.
>
> If components are in fact manufactured to fail simultaneously under
> normal use (including a dozen or two start-stop cycles a day), then
> taking the drive off-line for more than a few hours should
> unproblematically extend its life.
>
IMHO, a single start-stop cycle is more costy in terms of lifetime
than a couple of hours spinning. As far as I know, on actual disks
(especially 7200 and 10k rpm ones), spinup is a really critical and
life-consuming action ; spindle motor is heavily used, much more than
it will be when spin speed is stable. On our actual storage design,
disks are never stopped (sorry for Earth...), because it doesn't worth
spinning down for less than a couple of days.
However, temperature has a real impact on heads, (incl. head motors),
because of material dilatation on overheat. So cooling your drives is
a major issue.

> how long do modern hard drives last in cold storage?
Demagnetation ?
A couple of years back in time, there were some tools to read and then
rewrite floppy contents to remagnet the floppy content. I guess it
shall be the same for the drive : periodically re-read and re-write
each and every sector of the drive to grant a good magnetation of the
surface.
I would not give more than 100 years for a drive to lose all its
content by demagnetation... Anyway, in 100 years, no computer will
have the controllers to plug a sata nor a scsi :-p.
I guess a long-living system should not stay cool, and
re-activate/check its content periodically...

> we now know home-made CDs last a couple of years.
I thought it was said to be at least a century... But with the
enormous cost reduction operated in this area, it's no surprise the
lifetime decreased so much.
