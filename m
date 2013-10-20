From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Mon, 21 Oct 2013 10:59:45 +1100
Message-ID: <20131021105945.780d5800@notabene.brown>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>
	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>
	<5234CA6A.3070305@arcor.de>
	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>
	<52373A19.7000105@arcor.de>
	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>
	<523C8EF9.60809@arcor.de>
	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com>
	<CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
	<52409E62.3090105@arcor.de>
	<CAC9WiBigzwNFV2FSU+tWS969fh+6G6ikQcrDqDyW0CbiaOuLkQ@mail.gmail.com>
	<CAC9WiBje39ij9RLEqe8aha3FGn_LirxzQezXx-s5+J-HqUpwug@mail.gmail.com>
	<524C6711.3090805@arcor.de>
	<20131016155711.715678e7@notabene.brown>
	<CAC9WiBiwSHTC6o2sXwjqyy78B07VCgkdJG5PpHGyYu8bNV4JvA@mail.gmail.com>
	<20131017215827.6a85d2bc@notabene.brown>
	<5262E9C5.1050200@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rFqKRtrI=tGidMgBuoSRqzA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5262E9C5.1050200@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/rFqKRtrI=tGidMgBuoSRqzA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Oct 2013 22:21:25 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> >> Martin started addressing this in another new thread whose subject is
> >> "RFC: incremental container assembly when sequence numbers don't
> >> match"
> >>
> >>
> > Ah yes, thanks.  I had a quick look and it seems to make sense, but it
> > deserves more thorough consideration.
> > I'll get on to that sometime soon.
>=20
>=20
> Good that you're back. I was starting to get nervous :-)

(still hoping someone else will put their hand up to maintain md though....)

>=20
> Wrt the sequence number issue: One thing that I need to understand
> better is how native MD deals with this kind of thing. Containers have
> one additional complexity: one set of meta data for several subarrays.

With native MD is it is fairly simple - that 'one additional complexity' do=
es
make a real difference.

 - Before the array is running, you can add any device.
 - When the array is started, anything older than the newest device is
   discarded (with the understanding that a bitmap broadens the "age"
   of the newest device, so that oldish devices can still be included).
 - If the array is started but readonly, the missing devices of the same age
   as the newest device can be added (I think).
 - After the array is read-write, devices can only be added if there is a
   bitmap, and they must be in the age range of the bitmap.


>=20
> IMO one thing I think we need is cleaner semantics for compare_super().
> The return to distinguish at least the cases
>=20
>   0 - OK
>   1 - fatal incompatibility
>   2 - nonfatal, new disk has "older" meta data
>   3 - nonfatal, new disk has "newer" meta data

Does this really belong in compare_super()?

Currently compare super is for checking if the device belongs to the array =
at
all.  The test on the sequence number (event counter) is separate.
getinfo_super should return that in info->events.  Current only super0 and
super1 do that, intel and ddf don't.

>=20
> IMSM already has this to some extent.
>=20
> The logic to handle this must be in the generic, non-metadata-specific
> code. Metadata handlers need methods to force re-reading the meta data
> from certain disk(s). mdmon also needs a way to detect that it needs to
> reread the meta data.

If there is a container with one array started and the other not, then you
might want to reread the metadata for one array but not the other.
That could get messing but should be do-able.

>=20
> Furthermore,  at least compare_super_ddf does not only compare, it also
> makes changes to its internal data structures; I think other meta data
> handlers do the same. IMO it would be more appropriate to do this in a
> separate call, after the caller has decided if and how to merge the meta
> data.

Sounds reasonable.

>=20
> Then we need to make sure that (to the maximum extent possible) these
> issued are handled similarly during Assembly and Incremental Assembly.
>=20
> The "nonfatal" case is similar to the current "homehost" logic.
>=20
> As for the complex scenarios in my "RFC" mail, thinking more about it, I
> found that the dangerous incremental assembly cases are not so critical
> after all, as long as subarrays aren't started prematurely, which is
> mostly guaranteed by the current udev rules.

Agreed.  We should  do our best to detect the dangerous cases, but they
shouldn't be likely.

NeilBrown


--Sig_/rFqKRtrI=tGidMgBuoSRqzA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmRucjnsnt1WYoG5AQJ9Uw/9HEGAgNdCxbLAMQCFD29353sjgUGKNBeO
iXYtkmBVx0A8IERYekmzOaYVSVnp2fc+PkOrkGYDP5USoKqOrcieJrGxGZA7Yp41
rSmY4iBP0ezAsNuTWarvlKa+SGb6X2oKJgPDA1oArnNjGIZhGjrnL5oUUfWp2rp6
pHUkN9zNMLd4ZaByV2hwN398ystO8/m9fMKHgfQ4HRe8jwE/5Ehpc6BIBVIcoT9U
6ZRttn+0qfvakHQtsixBTRbx0GyHS6BOubwtwpMXd2kVsmznDQTUxN63Qc7dm6MX
vzXFhXqwOdLEtGUv2Tod8+bsII7Aq00NtUZr4asOqCg9wkDBDAT5LmOQw0zMvSEQ
8pr7zkgrSdGL/Qy5xOhAH6Bs0oDEyRerL7CNXYfa2iykxgluM0djRAV3+7Nl31C2
btrCsWePX8g76e7wM2UfPWz6RWeW98H35bQp1KXfU2/dy0+x25/shArkd+rLsphX
jw5EMgKC7CGqc56wl7qlLdkxsVvcNr4B34AOJq8xBAP/SLcnhdJmRRq6QJ0U4v4A
wp5KHRa8BCEv747kv0wsUjCg2JgZ/VnL/0o6xuDav11EyKEGpWtaF5Ks5E/jZqwJ
53L3jD91GUA5kdaCdL3rXvs+2OvjLNDDcW05mi0PdlnDr31rQZpWt9lUaLwHlyiY
+NHxymYytyQ=
=978/
-----END PGP SIGNATURE-----

--Sig_/rFqKRtrI=tGidMgBuoSRqzA--
