From: Roman Mamedov <rm@romanrm.net>
Subject: Re: stripe_cache_active always 0
Date: Thu, 7 Jan 2016 22:52:43 +0500
Message-ID: <20160107225243.74f5549b@natsu>
References: <568DD6E6.6070107@websitemanagers.com.au>
	<F7761B9B1D11B64BBB666019E9378117FE848B@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OJvT8_gJgVL8YOkBw6ihlud"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FE848B@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/OJvT8_gJgVL8YOkBw6ihlud
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Jan 2016 16:34:36 +0000
Robert Kierski <rkierski@cray.com> wrote:

> As far as adjusting stripe_cache_size... The stripe cache is dynamically =
allocated.  It won't save any RAM by decreasing stripe_cache_size.

Since when?

# echo 512 > /sys/devices/virtual/block/md0/md/stripe_cache_size
# free
             total       used       free     shared    buffers     cached
Mem:      16159912   15672696     487216      12588         52   14484708
-/+ buffers/cache:    1187936   14971976
Swap:            0          0          0

# echo 32768 > /sys/devices/virtual/block/md0/md/stripe_cache_size
# free
             total       used       free     shared    buffers     cached
Mem:      16159912   15957880     202032      12588         52   14214952
-/+ buffers/cache:    1742876   14417036
Swap:            0          0          0

You can see that's not the case (on kernel 4.3.3 with four-member RAID5);

And it's quite easy to rapidly hit OOM issues on high-member-count arrays by
setting stripe_cache_size to larger values (not realizing that this is *in
pages* not kilobytes or sectors, and *per disk*).

As for the original question, try checking stripe_cache_active e.g. once
per second during heavy write load to the filesystem.

--=20
With respect,
Roman

--Sig_/OJvT8_gJgVL8YOkBw6ihlud
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaOpesACgkQTLKSvz+PZwhXSgCfQKpODDROd3pNm1EEBd9cbAMt
wbEAmwQ9Hlm0kt5aAgOyHlAuS074hRKZ
=fv5C
-----END PGP SIGNATURE-----

--Sig_/OJvT8_gJgVL8YOkBw6ihlud--
