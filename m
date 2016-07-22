From: NeilBrown <neilb@suse.com>
Subject: Re: How does md gurantee not miss to free an active stripe_head when md stops?
Date: Fri, 22 Jul 2016 11:15:47 +1000
Message-ID: <871t2m8occ.fsf@notabene.neil.brown.name>
References: <004e01d1e274$faa33a20$efe9ae60$@163.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004e01d1e274$faa33a20$efe9ae60$@163.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vaughan <cxt9401@163.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Jul 20 2016, Vaughan wrote:

> Hi Neil,
>
> I'm using v3.10 md code for develop. Recently I encounter a problem where an
> read IO usually returned from physical disk after md has been stopped.
> I reviewed the code and find when md stops, it unregister raid5d
> unconditionally and call shrink_stripes() to free only the *inactive*
> stripes.
> I know before stop, it uses O_EXCL open the md, but that won't stop others
> open it and send IO to it.
> So I think it's possible that some active stripes will be still running.

do_md_stop() calls sync_blockdev() which was supposed to wait for all
outstanding IO.  It probably doesn't wait for reads though, only writes.


>
> And I also found
> commit 5aa61f427e4979be733e4847b9199ff9cc48a47e
> Author: NeilBrown <neilb@suse.de>
> Date:   Mon Dec 15 12:56:57 2014 +1100
>     md: split detach operation out from ->stop.
>
> add calling a quiesce before unregister raid5d in __md_stop, which not
> exists there before.
> Does this fix the hole when md stop?

Why don't you try it and see?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXkXPDAAoJEDnsnt1WYoG5JqoQALypV5kLAGYHQfX4zzHuZkDK
pO2+YCbzt1GYVM3gKBHqVuvLyrwpaCZsl/bN023Prf5bOb3n7RjlsGrhBeEpq58T
gd6jt8b5l04+QMQ26VFckOo/o+SxLNqUeOOymB2xfhtCiBLDpGS5P/uIQClIznR0
jbYfGaIftLjx7HK5pKOPfBULm/j7PesLYsDKxlgX/K/h4zkUyaEJcLrOgZc6ABTU
QGzflYgMR4XM05qOFVIIaD1s6mK3HeuP76Q6uW0z3HYvHseT+aSLmp7eeRFjou/8
MfHMOTGxSFNeg/6mVqHqFIJVvunJsrKdHkF/eXxKuzQyEyG9+AayoYjpsAlrdotl
pp09QFzY582gGTLzEKgForseWYQ7QX5cJO7nM5FV8mWpQjAr6B9SjVa4ab924pTh
AyaQzOhNakPF8pFy0ayjOR3lXNVgria951b2HMdLFZp2XiVdAdFY6yGC9JWy5aOS
CSVHOXWX6w58JM8sguxJk+85rT5HG1baf85UF70OX7lGN5caWs4s8KfFDW4lckj0
Mx7qsee9tfzRQu3p80camRb+pINI0LdWuD/gyTycG8Fi46ZJlzIm9X79iIGSEYtB
d1sI/inWu2+XevtK+TioJGsUCvyefS1byb8ziI1WkZ3aeBn05MqlmqP1gaVCzAYL
uYcX64UibRqUIMeTtPu/
=8Kk+
-----END PGP SIGNATURE-----
--=-=-=--
