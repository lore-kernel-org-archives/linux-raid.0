From: NeilBrown <neilb@suse.de>
Subject: Re: RFC: incremental container assembly when sequence numbers don't
 match
Date: Mon, 21 Oct 2013 11:07:27 +1100
Message-ID: <20131021110727.363cdd02@notabene.brown>
References: <523CADFD.9050006@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/v/efc_XWeZUMbK=m5dSc8F_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523CADFD.9050006@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Francis Moreau <francis.moro@gmail.com>
List-Id: linux-raid.ids

--Sig_/v/efc_XWeZUMbK=m5dSc8F_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Sep 2013 22:20:13 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi,
>=20
> I have spent a few days thinking about the problem of incremental
> container assembly when disk sequence numbers (aka event counters) don't
> match, and how mdadm/mdmon should behave in various situations.
> Before I start coding on this, I'd like to get your opinion - I may be
> overlooking something  important.
>=20
> The scenario I look at is that sequence numbers don't match during
> incremental assembly. This can occur quite easily. A disk may have been
> missing the last time the array was assembled, and be added again. The
> last incremental assembly may have been interrupted before all disks
> were found, for whatever reason. Etc. The problems Francis reported
> lately all occur in situations of this type.
>=20
> A) New disk has lower seq number as previously scanned ones:
>    The up-to-date meta data is the meta data previously parsed.
>=20
>    For each subarray the new disk is a member in the meta data:
>      A.1) If the subarray is already running, add the new disk a spare.

If the new disk has old metadata, then it might have failed at some point, =
so
we shouldn't add it as anything without good reason.
If the most recent metadata records that a device went missing, rather than
actually failed, then it might be justified to add it as a spare.  But in
general I'd prefer thing were only added as spares if that was explicitly
requested of if the policy in mdadm.conf encourages it.

>      A.2) check the subarray seqnum; if the subarray seqnum is equal
> between existing and new disks, the new disk can be added as "clean".
> (This requires implementing separate seqnums for every subarray, but
> that can be done quite easily, at least for DDF).
>      A.3) Otherwise, add the new disk as a spare.
>=20
>    The added disk may be marked as "Missing" or "Faulty" in the meta
> data. That will be handled already by existing code already AFAICS.
>=20
> B) New disk has higher seq number than previously scanned ones.
>    The up-to-date meta data is on the new disk. Here it gets tricky.
>=20
>    B.1) If mdmon isn't running for this container:
>      B.1.a) reread the meta data (load_container() will automatically
> choose the best meta data).
>      B.1.b) Discard previously made configurations
>      B.1.c) Reassemble the arrays, starting with the new disk. When
> re-adding the drive(s) with the older meta data, act as in A) above.
>=20
>    B.2) If mdmon is already running for this container, it means at
> least one subarray is already running, too.
>      B.2.a) If the new disk belongs to a already running and active
> subarray, we have encountered a fatal error. mdadm should refuse to do
> anything with the new disk and emit an alert.
>      B.2.b) If the new disk belongs to a already running read-only
> subarray, and the subarray seqnum of the new disk is lower than that of
> the existing disks, we also have a fatal error - we don't know which
> data is more recent. Human intervention is necessary.
>      B.2.c) Both mdadm and mdmon need to update the meta data as
> described in B.1.a).
>      B.2.d) If the new disk belongs to a already running read-only
> subarray, and the subarray seqnum of the new disk is greater or equal to
> the subarray seqnum of the existing disk(s), it might be possible to add
> the new disk to the array as clean. If the seqnum isn't equal, recovery
> must be started on the previously existing disk(s). Currently the kernel
> doesn't allow adding a new disk as "clean" in any state except
> "inactive", so this special case will not be implemented any time soon.
> It's a general question whether or not mdadm should attempt to be
> "smart" in situations like this.
>      B.2.e) Subarrays that aren't running yet, and which the new disk is
> a member of, can be reassembled as described in A)
>      B.2.f) pre-existing disks that are marked missing or failed in the
> updated meta data must have their status changed. This may cause the
> already running array(s) to degrade or break, even if the new disk
> doen't belong to them.
>      B.2.g) The status of all subarrays (consistent/initialized) is
> updated according to the new meta data.
>=20
> Note that the really difficult cases B.2.a/b/d can't easily happen if
> the Incremental assembly is done without "-R", as it should be. So it
> may be reasonable to just quit with an error if any of these situation
> is encountered.
>=20
> An important further question is where this logic should be implemented.
> This is independent of meta data type and thus most of it should be in
> the generic Incremental_container() code path.

maybe in assemble_container_content?  But mdmon need to know about some of =
it
too of course.

>=20
> Feedback welcome.
> Best regards
> Martin

Sounds very sensible, but the devil is in the detail of course. :-)

Thanks,
NeilBrown

--Sig_/v/efc_XWeZUMbK=m5dSc8F_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmRwPznsnt1WYoG5AQJ6Xw/+ImAsjgSWgsQYTSFR0AM9MzBjAnSGvr28
PRj/W2imTFIoaOeggMg2auJ5zzNr3cwiICpDEyes9izHGYl5vQwraX1CAi4LImSL
O4UslEQL13KBbZuKQ2ztqabFDbFhNU9bPHEw/pJ4Vv+aMUvcUKc5BCEFS1/m+DZE
BYs60Ea1TIUWNrdP7x7cd2HgEvLTdpvCZ3b3YYc6KK4BeAy+WksgzSyi0ukxrcG1
gt9OXIuKOXKyDcVJ1qmCX7pCjUGQsd6SrDmwKivnEam3Z+QhV5IM7AV1vkrS7FzN
NJNlC72/UjIB9T7bNvoXEvdTzgMn2li2VlYuoiUOzETEShrGvcym7VeIaXxRPTc7
DDNfprUkWM0H2seL1MJJqs528FzeCXHnD3rQWdkT9p1wQdpHh/30xjz+AeHWhS+Y
fHD548fOmVVYoekl1kq3oX+84Lksvop7QMfCk4+fwrVoUCd0Mw0j1WVqKYqbzwlV
ZCLVbBv30YCiMATmN9e1g1Yy4jry/xbip6o1seyI2gfTlnEna7JznPAx+3Exevza
nyjaxZJ0OD1KjoavTsuCYMtbi6LNr8G8sebxRWX/F9ZjhLJap3LKTv3zfHrQk9uS
qzl2hkYZwKVh1fcpiqVyxY+OBXzRlOPANaKeMgG8QvUK+GoKguUuMM5106qwpqHp
lDhfVSVWdPI=
=59tC
-----END PGP SIGNATURE-----

--Sig_/v/efc_XWeZUMbK=m5dSc8F_--
