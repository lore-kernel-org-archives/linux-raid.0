From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on
 shutdown.
Date: Sun, 22 Apr 2012 06:42:03 +1000
Message-ID: <20120422064203.65eee938@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
	<20120419195740.6e35ea02@notabene.brown>
	<CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
	<20120420220151.623df648@notabene.brown>
	<CACVpCE6UZvBia2VwRMaFhJJuB2quvKKQc1byLFRP4YPTE8LHSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jq43zBgAU8aNagtembpYUMN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVpCE6UZvBia2VwRMaFhJJuB2quvKKQc1byLFRP4YPTE8LHSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Pawe=C5=82?= Brodacki <pawel.brodacki@googlemail.com>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Jq43zBgAU8aNagtembpYUMN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Apr 2012 17:18:58 +0200 Pawe=C5=82 Brodacki
<pawel.brodacki@googlemail.com> wrote:

> W dniu 20 kwietnia 2012 14:01 u=C5=BCytkownik NeilBrown <neilb@suse.de> n=
apisa=C5=82:
> > On Fri, 20 Apr 2012 13:30:39 +0200 Pawe=C5=82 Brodacki
> > <pawel.brodacki@googlemail.com> wrote:
> >>
> >> The way I read the message agrees with Alexander's perception. My
> >> impression from reading the commit message is, that normal shutdown
> >> may result in unclean array, which I would perceive as a regression.
> >
> > I don't think you'll find the word "normal" in the original message :-)
> >
> Neil, I respect you and admire your work and all, but I think you are
> having good time with us and this commit message, aren't you? :)

"For what, we ask, is life - without a touch of poetry in it".

Maybe not an entirely relevant quote, but it is the first that came to mind.

"What's life without whimsy?"

Would be a slightly more modern quote.

Can you place them without google's help?

>=20
> >>
> >> I would really appreciate clear statement, whether this behaviour
> >> (writeback during shutdown, with possibility of poweroff/reboot while
> >> array is dirty) can or cannot occur during normal shutdown process.
> >
> > Define "normal".
> > If you kill any processes that could generate write-out, and then do a
> > 'sync', then everything should be fine.
> >
> I think "normal shutdown" can be defined for the purpose of this
> discussion as whatever /sbin/shutdown does.
>=20
> If I run /sbin/shutdown -h now, it is a normal shutdown. If I do fancy
> stuff echoing cute strings and integers into various parts of /proc
> and /sys, push magic buttons and/or pull cables at random, it' is not
> a normal shutdown.
>=20
> > I suspend a "normal" shutdown sequence does this.
> >
> > NeilBrown
> >
>=20
> I smell a hint here.
>=20
> man shutdown:
> "shutdown arranges for the system to be brought down in a safe way."
> Define safe...
>=20
> Neil, could you point us to a bug report which inspired you to write
> this patch? My google fu failed me and I was able to find just one bug
> entry from before 2 yerars, and even that hit is of dubious relevance.
>=20
> Pretty please with sugar on top?
>=20

https://bugzilla.novell.com/show_bug.cgi?id=3D713148

But that is against our "enterprise" product so is not globally visible :-(

But it gave me some search-term hints so:

http://lists.debian.org/debian-kernel/2011/05/msg00264.html

http://www.issociate.de/board/post/491554/Kernel_BUG.html

http://www.gossamer-threads.com/lists/xen/devel/174884?do=3Dpost_view_threa=
ded

https://lkml.org/lkml/2008/11/24/414
http://comments.gmane.org/gmane.linux.raid/20710

The important elements are:
 1/ you see "md: stopping all devices".  This means that "reboot" has=20
   really started.  This is printed by mds reboot notifier.

 2/ A stack trace showing something submitting IO.
   In the first link it is bdi_writeback_task
   In the second it is kjournald

This pattern can only happen on an unclean shutdown.

NeilBrown


--Sig_/Jq43zBgAU8aNagtembpYUMN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5Mbmznsnt1WYoG5AQJbtxAAibJkOAlt8FZmgcxPD2r8LwVpiP2ouEie
fX6CiQGEHj2BRlGDbPYlh1ZEmx6SjVJNfJvPrtjmIfgIW2XcFqxes6VIpGz983R6
VjAhfG+Tm4jrnmBPM6R3fc5jmm5NcY4FuM8bUS1U2VhBrBYS3VcAwZDvbr1cOmcC
kOZafGIqr9zWtc5ETivu2fnaEmGCX+qPQNakVO625hFlgwoB6J66ZRJTLgUuJ/PT
cEFYSGzAv8jX+qLQ2b88PpxFJvl9/3N0lGVqVKhspaduUem1pbOO7MyQGTNgTI05
+RCcC2PLuYX2hWmaTyguSO2qfA3ivRSjpXZ3HiH6fv3abn8kLBjEm/0qnwxVkNWz
ND1014Z8TQ2Hb7hvWEnn1DqgWGiTcI9Klql/4vx7pHUfkGZbka21yXDyvjPM2Q7p
ZA8A1ciTG5RBMryP09oGY2jRLqj3SzjmMNsyN+3+KBvDebM/A00X8Z+5rJdybvNk
I0OEkk+rpGQbNgyoJUgIvSerM3d375/r7OeyOJDVgs3y3zewPGf45m5ybfNum/aO
DcpyRFeIbwLja6f6Cgjosts+Wzhcm5O1JmPoBE+Dt9Jona2JMmnME2tKAJTr/uJg
M3ZELb22rEesCE5YKh/YSCYVSDjEurGpv0noyYv5AO71zog9JbKtxwosyp8yj+9L
x9zVJ5OSl1Y=
=YHxg
-----END PGP SIGNATURE-----

--Sig_/Jq43zBgAU8aNagtembpYUMN--
