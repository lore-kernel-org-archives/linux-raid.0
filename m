From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --fail on RAID0 array
Date: Wed, 7 Aug 2013 16:21:45 +1000
Message-ID: <20130807162145.0d5d94d2@notabene.brown>
References: <52016A36.9090902@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YDW44RG9.88/vAtqVgS/kL5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52016A36.9090902@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YDW44RG9.88/vAtqVgS/kL5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Aug 2013 23:27:18 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil, everyone,
>=20
> I'd like to discuss the following "feature" I just discovered.
> It is impossible to set devices faulty in a container if they
> are only members of a RAID0:
>=20
> mdadm -CR /dev/md/ddf -e ddf -l container -n 3 /dev/loop10  /dev/loop11
> mdadm -CR /dev/md/vol1 -l raid0 -n 2 /dev/md/ddf
> mdadm --fail /dev/md/vol1 /dev/loop11
> mdadm: set device faulty failed for /dev/loop11:
>    Device or resource busy
>=20
> This is independent of DDF / external metadata; it happens with native
> MD meta data, too. I don't quite understand why this is so; certainly
> RAID0 has no way to recover from disk failure, but simply refusing to
> ack the fact that a disk is broken doesn't seem right. IMO the array
> should switch to read-only ASAP, and mark itself failed in the meta
> data. But I may be missing something important for a native MD case.
>=20
> However, in a container, it must be possible to set a disk failed, and
> that's currently not the case if a disk is only member in a RAID0. In
> the DDF case, we'd expect to set the array failed in the meta data and
> update the disk state to "Failed". "mdadm --fail" on container devices
> doesn't work, either, because the kernel refuses to do that without RAID
> personality (actually, this is what I'd like to change in the first
> place, but I don't oversee potential problems).
>=20
> This has actually potential to cause severe breakage. Consider a DDF
> container with 3 disks d0, d1, d2. A RAID0 array uses 50% of space on
> d0, d1, and a RAID1 uses another 50% on d1, d2. Now d0 goes bad. mdmon
> wouldn't notice. When d1 or d2 go bad, too, mdmon would try to use the
> free space on d0 for rebuilding.
>=20
> For this scenario to get fixed, it wouldn't be sufficient for the kernel
> to accept mdadm --fail on RAID0. We'd also need to monitor the RAID0
> (or, actually, all phys devices) with mdmon. In other words, this would
> require to run mdmon on every container, not only on subarrays with
> redundancy.
>=20
> Thoughts?

Hi Martin,
=20
I don't believe there is any value in recording that one device out of a
RAID0 is failed, any more than there is value in the block layer recording
that one block our of a disk drive has failed.
Any IO attempt will fail.  IO attempts to elsewhere in the array (or plain
disk) will not fail.  That is as it should be.  A filesystem must be able to
cope.  Maybe the filesystem should switch to read-only but that isn't my
problem.
If the filesystem wants to keep writing to those parts of the array that
still work, md should not get in its way.

In the scenario you describe with a RAID0 and a RAID1, after mdmon assigns
some of d0 to the RAID1 md will start recovery.  This will presumably
generate a write error (if it is really bad we'll get an error even earlier
when trying to update the metadata).
That error should (and I believe will) result in the device being marked
faulty.  We must be ready for an error at the point and I can see no
particular value in getting the error indication earlier.

So I really don't think there is a problem here (except that "RAID0" should
never have been called "RAID" as it has no "Redundancy" and causes people to
think it is in some way similar to other RAID levels.  It isn't.)


Thanks,
NeilBrown

--Sig_/YDW44RG9.88/vAtqVgS/kL5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgHneTnsnt1WYoG5AQInKhAAgeuehV8PnFYgeP/V3IGpNHXaGKBi8bi1
dUXneCZdsnZOsHaAvvUkIEXatcKFVYog5Pm/lYE618Eh1mcyP1fwLT8y0VqiqIyG
DvT/CkYwKZe/9pS0zbswzYd5yULGTtvTZGtT4j1kpJ1TR0r/gyYBy7T/SXGgmoNk
UgmNdQnbVGS6TCXmD5sMV1o1tSPJ21ph+jJLKBr+AiVGMLcnc4Ytlw8vKRe6Qwdp
FXjegQkui5EDEcQnhKekmgh7/brEwEzvLH2/EYmu1IAvh2fLruejTwG6efm2a+oR
3B75iq+X6Ppxz/LmYZaSWMqErG/KvovGBA5zqlv8jSDzIoR03owuPvVm4K2RlYm5
gcsMyTLh5kri680nNJJpPbpdOPrGYZTToY7LHggtj/zToxFJOvr9zRXOkdRJta7Y
XyU4arcM2P7rn8fzACklo1TyTtospG81OkjhP75HRCXzTZDiWapOVKp9RLx2GnD0
Zt0r6ybqMxEN0H9+J0BscHkfH1pXciXXeceoivhmoBCKWU4b8kwnUktEJimAoDv+
GyGxtMMGaaLdqyqOtmf56kDhB8LIb2Ys4IfkH8qIuB0WAQUtCZ0DOQ+cpbnS9TXy
WSjDSA2CGEhtWWv92whzezCGck7DakggVAPJaucdUNjY+siloEwobpK1vVfcJswi
PBwxk242h1s=
=zHnB
-----END PGP SIGNATURE-----

--Sig_/YDW44RG9.88/vAtqVgS/kL5--
