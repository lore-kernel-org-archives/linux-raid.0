From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Did I make a mistake?
Date: Fri, 20 May 2011 10:16:43 +0600
Message-ID: <20110520101643.37dffc49@natsu>
References: <D8.84.03893.CB5D5DD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Kct_YYhNTD/PwnKTC+ppiBf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D8.84.03893.CB5D5DD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Kct_YYhNTD/PwnKTC+ppiBf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 May 2011 21:45:23 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> 	OK, I may have made an error, and I want to make sure before this
> goes any further.  Yesterday I created a RAID6 volume with eight 3TB
> members, on the same machine containing an older RAID6 array built of
> fourteen 1G members.  Based upon my reading here and some level of
> experience with larger stripe sizes, I decided to create the array with a
> chunk size of 4096K.

4096K is an absurdly large chunk for such RAID5/RAID6 array, I wanted to re=
fer
some benchmarks, but couldn't even find any that would test such a huge chu=
nk,
largest they test is 1024 or 2048, where the write performance already drops
off very sharply, e.g. see:

http://blog.jamponi.net/2008/07/raid56-and-10-benchmarks-on-26255_10.html
http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-benchmark=
s.html

While the read performance does seem to not suffer or even increase at
higher chunk size, the best read/write combination performance seems to be
achieved at 64...256K chunk for RAID5/6.

If you decide to persist with the current configuration, make sure you
increase stripe_cache_size by a lot (and btw raising it if you have the
RAM to spare is a good idea in any case).

--=20
With respect,
Roman

--Sig_/Kct_YYhNTD/PwnKTC+ppiBf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3V6ysACgkQTLKSvz+PZwgYKwCfUVTNDxqab1wLUvCUXWddWP7y
JMMAnjTW6P4/oqGMJTwyK/SwDZ4qoYAt
=eALL
-----END PGP SIGNATURE-----

--Sig_/Kct_YYhNTD/PwnKTC+ppiBf--
