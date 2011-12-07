From: NeilBrown <neilb@suse.de>
Subject: Re: meta: should i chase this down?
Date: Wed, 7 Dec 2011 11:47:26 +1100
Message-ID: <20111207114726.2f3f3543@notabene.brown>
References: <42n2r8xe3k.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eYq6ePNeAgtz1BjcI443IWi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42n2r8xe3k.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eYq6ePNeAgtz1BjcI443IWi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Dec 2011 16:02:44 -0800 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

> Hi all,
>=20
> A little while back, I had a strange issue, where reshaping a RAID6 to
> add a disk, then performing significant write activity (in this case, an
> rsnapshot), would cause a kernel crash.  I only attempted this twice,
> and neglected to write down the kernel oops errors, but I saw a few
> calls that seemed to imply that the md driver might be involved.  (Doing
> the same write activity during a rebuild is fine, which is another
> reason I suspected the reshape code in the md driver.  If it's of
> interest, I'm using kernel 2.6.39-4.el5.elrepo from ELRepo on a CentOS
> 5.7 box.)  It's certainly possible that I have a hardware issue, but not
> being able to reliably replicate the issue outside a reshape complicates
> debugging.
>=20
> My question is, should I try to hunt down the actual source of this
> crash, and if so, what would be the best way to go about that?  I am
> decidedly not a kernel developer, and am not familiar with how to obtain
> debugging information in that environment.  I'm happy enough for this
> machine to suffer crashes, but I prefer not to work with the existing
> RAID6 if possible, and would want a more reliable way of collecting the
> kernel's debug output beyond writing it down on paper.  :)
>=20

I'm always happy to receive detailed crash reports.  However I cannot measu=
re
how much your time is worth, nor can I guarantee that what you find wont
already have been fixed (though 2.6.39 is quite recent and I don't recall a=
ny
recent kernel-crash-during-reshape bugs, not can I find any in a quick scan
through the logs).
So I cannot advise you on whether it is "worth the effort".  I would
appreciate it though.

The best way I have found to catch kernel messages is using netconsole.
See Documentation/networking/netconsole.txt

You need a wired network port and another machine on the same network that
can capture the messages.

You almost certainly need some disks to make the RAID6 out of.  You could t=
ry
loop-back devices over files but the timing is likely to be very different
and so the chance of reproducing the bug correspondingly small.

But if you do manage to get a crash message I would be very happy to
interpret it and work to fix the bug that causes it.

Thanks,
NeilBrown

--Sig_/eYq6ePNeAgtz1BjcI443IWi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTt63njnsnt1WYoG5AQJEzg//bRB3ArLux3BJbC1QNiaLaJ3u+t+5X8KK
fvrgfArcuYMjjYbfeiR4M8y8+0p8HI3+hX1NrgSaSNo+wcq7hbgreNp/05039pQ6
W0b54lB5Y6CC56bzbakwyjuSw7YFTcCW9JL79oRx1oEHtisxGJJhMKJy1iRRg0xJ
+NoPcOI8XxzIOLHpXLKGszh+IICRHNGmVdy0k3yix1VWuvZE3mC1cqqfNmyr8ipd
h+i3APa1d/e2EpICVwhzZm94Sf2MLxLwTmQYemvSJdrDXyKNgUIkDOuQbrHHmVaJ
X8O1peGlcmNyM5fbtUKXN10fOWKx4JrZXQdb03CqaiHamEYOiEXfc+Q9fllziATL
RZcoqJqx5rMGuYMIrA7BzxAKXHGVYkMIUAN7cwOqjPZ71qC2pOn1hxp4NyU2okYS
pQp75biempCKo+vH5K/CZU7i9SmwB4i3UITDYom8eKS35Ss96vww1NFZfD0BKkp1
zhCox/82xyZJK6KNzRa61WlYv0c+8Ct+aQIvFmc02iobMQk0KRr4quku08P4Euzd
joBTjfY31T5PNNGcJGeskIT3fxu/5flp/2rKhdm7Ra2DiZATk5bcO7XEnqukj4ZD
U21iEoK5Coj+Bsbq/AY3CJqd99ksIR2SESjqNMk2rtMuL55Zl3soo3Ee/hmFiUau
a/na2LJb+WI=
=bl7g
-----END PGP SIGNATURE-----

--Sig_/eYq6ePNeAgtz1BjcI443IWi--
