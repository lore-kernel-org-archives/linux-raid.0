From: NeilBrown <neilb@suse.de>
Subject: Re: unable to assemble (mostly?) clean array
Date: Mon, 9 Dec 2013 12:33:05 +1100
Message-ID: <20131209123305.04e7257f@notabene.brown>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
	<52A5089D.3080109@websitemanagers.com.au>
	<CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
	<20131209120217.54dd3082@notabene.brown>
	<CACw0PsaCzZAKWeh9MxXK39Fpwh5wg-bjHHMY0-0djW+59Qf-jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OkM_dnv/LODC/P/IDEah_YE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACw0PsaCzZAKWeh9MxXK39Fpwh5wg-bjHHMY0-0djW+59Qf-jQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Hoover <ch@murgatroid.com>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/OkM_dnv/LODC/P/IDEah_YE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 17:08:19 -0800 Christopher Hoover <ch@murgatroid.com>
wrote:

> ch@snaggle:~$ sudo mdadm --assemble --verbose  --force /dev/md0  /dev/sd[=
defg]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 5.
> mdadm: ignoring /dev/sde1 as it reports /dev/sdd1 as failed
> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
> mdadm: no uptodate device for slot 0 of /dev/md0
> mdadm: no uptodate device for slot 1 of /dev/md0
> mdadm: no uptodate device for slot 2 of /dev/md0
> mdadm: no uptodate device for slot 3 of /dev/md0
> mdadm: added /dev/sdg1 to /dev/md0 as 5
> mdadm: added /dev/sdd1 to /dev/md0 as 4
> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
> start the array.
> ch@snaggle:~$

Thanks.

I recognise this bug now.  You are running mdadm-3.2.something - correct?
You need 3.3.
Just grab the latest:

 cd /tmp;git clone git://neil.brown.name/mdadm ; cd mdadm ; make ; ./mdadm =
 -Avf /dev/md0 /dev/sd[defg]1

NeilBrown


>=20
> On Sun, Dec 8, 2013 at 5:02 PM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 8 Dec 2013 16:32:22 -0800 Christopher Hoover <ch@murgatroid.com>
> > wrote:
> >
> >> yes, thanks, typo there.  that was done hastily for the e-mail.
> >>
> >> i had tried the right thing previously and here it is again.  still no=
 luck:
> >>
> >>
> >> ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1 | egrep 'Events|^/dev/sd'
> >> /dev/sdd1:
> >>          Events : 286024
> >> /dev/sde1:
> >>          Events : 286011
> >> /dev/sdf1:
> >>          Events : 286024
> >> /dev/sdg1:
> >>          Events : 286024
> >> ch@snaggle:~$ sudo mdadm --assemble --force /dev/md0  /dev/sd[dfg]1
> >> mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
> >> mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
> >> start the array.
> >> ch@snaggle:~$
> >
> > Please try listing *all* of the devices, and add "-v" for extra output.
> >
> > NeilBrown


--Sig_/OkM_dnv/LODC/P/IDEah_YE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqUd0Tnsnt1WYoG5AQJIrRAAgwigV8c1ARHOQCN1haMSNwU+yEuUJfm+
HZhcQ0zqcx3vVp+4ahby1WyJgd6kEeO6j5ewHTFNXBJKFoqQyYURkjVf7CRunPjS
fLFJ68u8UFN7dVO7FmNjPUgQqVCCcA47mM4Cq8KUZK8/Bq1U66Ek9xX3saZ14gkH
GlfRgrPLNVRaRqekbNKVAu1KXoAnJEJX3aqvz5e0eYMPYoaX1Jn599yiGT+nZ+tb
hRB6/3jYSDcp/HjtOF7tOAvZw5nuZUG66FWrdn9wZneZS4QrpWSkh28W+3/zI94B
gi9xYWHcb4nf4ag7D2x07zVHWBXbbk3vqJWYSvgIYTbQ9dsK39AZhpN7Ev6Q6XKB
ikvPFu/sTcsOs7A0AcAZa+pX3MAn+FIuHUdH1nJns20WcP6VmND270i8RvXmoAuV
187J3XJIkkq/6JriPunvrtelpw0ao/TudqBLPrY8bLWBqpIUOpW6PbIrVMcFTFFj
f2ovq1rqlq1YTuNS2Os1KMtgQ6rxKg3NyOXUB9J2eVsWm+Sef7oa8itThsmufoDr
fy4B2LFNeucruKSwCuSFP2XQW6YGmWKtGEwsBuXERtaAhSdoSO+iErINicx5cnlN
58Wdd9RU+D2uP0itCrH469GdXJf+mEsPJH3j8nWIkz/yuDKnilnQgDciz5q5HLqd
kRBk+a/vM1o=
=4ygM
-----END PGP SIGNATURE-----

--Sig_/OkM_dnv/LODC/P/IDEah_YE--
