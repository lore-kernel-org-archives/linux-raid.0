From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 6/8] md/r5cache: sysfs entry r5c_state
Date: Wed, 19 Oct 2016 13:19:30 +1100
Message-ID: <87lgxlxeq5.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-7-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-7-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Oct 13 2016, Song Liu wrote:

> r5c_state have 4 states:
> * no-cache;
> * write-through (write journal only);
> * write-back (w/ write cache);
> * cache-broken (journal missing or Faulty)

I don't like this.

We already have a mechanism for removing a failed device from
an array: write 'remove' to the 'state' file in the relevant dev-*
subdirectory.
You can also use that file to tell if the journal has failed.

Please call the file something a little more obvious that 'r5c_state',
maybe 'journal_mode', and use it only to switch between write-through
and write-back.
If there is no journal, then either remove the file, or have writes fail
and reads return something obvious ... maybe ENODEV.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYBtgyAAoJEDnsnt1WYoG5GuMP/3XC4tuRvJa21mOjrPUUaB27
MkZ5RWPNuEfHUWbNYAOgPcDYTb/mxs616d6H1fCrJn5i0hACmEZQ9iiKpMxWPPZN
W2QkoVfuAoysd/OpluOBSA1zDVMfILd22G1IIkriGQaS5LrtippMYS74lQHBHYCQ
pZ7+efbJToquRDc4ph++wKJ8iB+59jFHzHFNAeSXx+HqE7DrIgHLchPHo+ItcET/
1h7YD02MDyHaTEesFUf0TtmYlfN52IW3Wha6R6lLFwHuQiZjwzM9PIyUJisPiINF
1qHd4Evk9Q/kXde51jRfWN9+I8LCaia3eY543AYL0mWGa5ND31yM9TRnkHTneq++
rys4g0rjD5y5cgcqKwMHzMAmFp39CDlrA07GVJBqDD7Bv2vStn3uYZJqVrHoN91J
3qFx5+Tv1USO9psZLxHAJIeTJYF0wBft7MLigjbWIJEhjUpjAGLblni0GYag2523
kIS33+GKRqBefTE3fSsRNaQuzesBwsifYbx3IlNu8wFVDKDSegQU6IqyZCMkn6Tg
nEUNWyVFk8uuWwZrrp6nF/zrX+1aSI+6vhAW2hzAJba1LdtlNfKn+SVa04iJW7r6
sSzCg8E4Xhusr5jBkMpPFYIl2Zmu+Fj9BJYrLSB663St1o42cQNAKeGxpy9Abrdx
muqJcQX/rk/K5A9nFAdQ
=QMYP
-----END PGP SIGNATURE-----
--=-=-=--
