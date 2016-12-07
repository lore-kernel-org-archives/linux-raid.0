From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Wed, 07 Dec 2016 11:32:09 +1100
Message-ID: <87fum04m0m.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> This series of patches implements the Partial Parity Log for RAID5 arrays. The
> purpose of this feature is closing the RAID Write Hole. It is a solution
> alternative to the existing raid5-cache, but the implementation is based on it
> and reuses some of the code by introducing support for interchangeable
> policies. This allows decoupling policy from mechanism and not adding more
> boilerplate code in raid5.c.
>
> The issue addressed by PPL is, that on a dirty shutdown, parity for a
> particular stripe may be inconsistent with data on other member disks. In
> degraded state, there is no way to recalculate parity, because one of the disks
> is missing. PPL addresses this issue and allows recalculating the parity. It
> stores only enough data needed for recovering from RWH and is not a true
> journal, like the raid5-cache implementation. It does not protect from losing
> in-flight data.
>
> PPL is a distributed log - data is stored on all RAID member drives in the
> metadata area. It does not need a dedicated journaling drive. Performance is
> reduced by up to 30%-40% but it scales with the number of drives in the array
> and the journaling drive does not become a bottleneck.

I would expect to see as description of what a PPL actually is and how
it works here... but there is none.

The change-log for patch 06 has a tiny bit more information which is
just enough to be able to start trying to understand the code, but it
isn't much.
And none of this description gets into the code, or into the
Documentation/.  This makes it hard to review and hard to maintain.

Remember: if you want people to review you code, it is in your interest
to make it easy.  That means give lots of details.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHWIoACgkQOeye3VZi
gbl8VQ/+O91/iwmBC4PSCUhV+DMitUoxB7TORhag7djnT/sNEv7PRdhVKPP2OJ0q
oUEHA2p7R9Ta3kJf4xFl9LJQkWGC+MWVtkCAi4q7FC0v7pOlLbGPTmRZFJt9rTWa
pbGdqKUfZ4gqclH1fQzzwBPXEmS58QiQz8m95ZnIDZjm0GUj6qAtizLRM60seG6N
RxYXeCN2JmU5mDvuw+on6QE1kHst7lvjyqMXy8qc/6T4P015BGMUj3rAkfxbBlmd
m/y9Au1LScLyJgfvAtracCBqEW46WRSYSGT4d5WZ42OiyrI9Xe3rCqfUtnHC5AuB
hnzCn7mqOKLGAK4c4/W5yV3jSbiw3fLO7CBnY4B2E7ERg3zNZokkFagZvLrEwz4G
CtUqOxO0BLBXbc+KOtwN9D6Y5qm5+rFkgNB1EO00d6yZRUhhUgmS7Azmu97E0nRI
7LGUtvC53z2WRg1D+zmmkPjExWRVSTmWr0iL8AzPnd9GH6Z0g+6Y1JFQkVaLerxo
jTuLJ3cjhSTVomTbOKqmrXeVMKwmp3v6knJV6KTxSly+jZ2s0MZdi99/qq1nEsFB
y+dIm4U0PY8oIKUiayAeKy6+rD620xJfGgw9Wny8cDrtqwpb0XPCkR6xncZxyhJR
6vpFMNQurAM2R8CObpqCYdEq4bD9BgM7ghMDfz56QD+zP4fqoeo=
=JBgA
-----END PGP SIGNATURE-----
--=-=-=--
