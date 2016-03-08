From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/8] mdadm static checker fixes
Date: Wed, 09 Mar 2016 09:55:08 +1100
Message-ID: <877fhclgvn.fsf@notabene.neil.brown.name>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Hi,
>
> I have been running mdadm through Coverity and fixed a number of
> issues that were raised in the scan. A couple of them were non issues
> related to conditions where we know for sure the kernel will not
> return strings longer than a given size, but there were also a number
> of potential memory leaks and buffer overflows.
>
> These patches are sitting in my pending queue. If you are on the CC
> list, would you mind having a look at the portions touching code you
> previously pushed wrote.
>
> Please hollor if you notice I did anything wrong, otherwise I'll push
> this set into git within the next couple of days.

All
  Reviewed-by: NeilBrown <neilb@suse.com>

The comments I have made are only possible enhancements, no problems
found.

I must confess that I was generally fairly careless about resource
leakage.  mdadm usually calls 'exit' fairly soon and that releases
everything.
But mdmon and "mdadm --monitor" at long-running so it can pay to be
careful.
And I'm very supportive of silencing warnings from tools that also
provide useful warnings.

Thanks!

NeilBrown

>
> Cheers,
> Jes
>
>
> Jes Sorensen (8):
>   Manage: Manage_add(): Fix memory leak
>   load_sys(): Add a buffer size argument
>   Grow: Grow_continue_command() remove dead code
>   Grow: Grow_addbitmap(): Add check to quiet down static code checkers
>   {platform,super}-intel: Fix two resource leaks
>   bitmap: Fix resource leak in bitmap_file_open()
>   Manage: Manage_subdevs() fix file descriptor leak
>   super1: Fix potential buffer overflows when copying cluster_name
>
>  Detail.c         |  2 +-
>  Grow.c           | 11 ++++++++---
>  Manage.c         |  8 ++++++--
>  bitmap.c         |  1 +
>  mdadm.h          |  2 +-
>  platform-intel.c |  7 ++++++-
>  super-intel.c    | 12 ++++++++----
>  super1.c         | 18 ++++++++++++------
>  sysfs.c          | 47 ++++++++++++++++++++++++-----------------------
>  9 files changed, 67 insertions(+), 41 deletions(-)
>
> --=20
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW31hMAAoJEDnsnt1WYoG5UdkP/iPCXh9CeDIbcg5oI90AQhAq
UtCbmQNyka3E4VxDPUUkjAq6FEAU/2BngOtUIrEbRzCcfdFeWUq2mfrmq18WpEc2
0WJK/EmxoMaa6IVa+c2nF5V5jAuIAEUdzsiitXOYQMEfZd8n1tVd5Inl1c7t1im7
Moyu7v4DZHODefsruTF2o5y8GFFzMCXz1vQsSfIFWGf8TeM0p6w8ItJcO78Cuz9e
ulLiU+1U1wlWQRyex2BDmczmgtaM59OrfLkRAaMf3ZO8nRkny8kH08w8dEf5R9Me
mdshr6RYRWe6fTVIiKIIAGw5inZIVe/CdjvipOJXZHRRJ3UeClXIDe31NsZ0AuLa
Elos1mBIFgjv2GLJ0DQ3d+keD66h4m1MYF5lUzXlfAyXMAn3u7gZU7w37+CoSyVH
y3+DKVoPDKxv8dY2dY9yaCzXDAolbgfN5DGQXk1z/9uYLi3uNJONON2pVfaI1B6n
52v7w+GQhTJDYocxT8MO31e2DIFx4wyyKMlMtBXtaTaPljRaaSsBrkyWwyWcLNx5
GJL2UMHWAbGzYf7Lsta86LaYSuX0++3ejHjZiGjq6G0emYEJwfmNUnOetOLvTgzr
fif3JrlmD2AxcmWWmZbp0JcLV6KAv12oJqxUsoXSM3GZeKeuLGnc/5zMXsXI52G1
3WF6WtfSzj0//pCxsfqJ
=xpXm
-----END PGP SIGNATURE-----
--=-=-=--
