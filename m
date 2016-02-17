From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md: Inform udev about device removal when stopping
Date: Thu, 18 Feb 2016 09:57:04 +1100
Message-ID: <87si0rq727.fsf@notabene.neil.brown.name>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com> <1455633877-4813-2-git-send-email-sebastian.riemer@profitbricks.com> <20160216200553.GA13119@kernel.org> <8760xotmi0.fsf@notabene.neil.brown.name> <56C45886.7020200@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C45886.7020200@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17 2016, Sebastian Parschauer wrote:

> On 16.02.2016 21:43, NeilBrown wrote:
>> On Wed, Feb 17 2016, Shaohua Li wrote:
>>=20
>>> On Tue, Feb 16, 2016 at 03:44:36PM +0100, Sebastian Parschauer wrote:
>>>> When stopping an MD device, then its device node /dev/mdX may still
>>>> exist afterwards or it is recreated by udev. The next open() call
>>>> can lead to creation of an inoperable MD device. The reason for
>>>> this is that a change event (KOBJ_CHANGE) is announced to udev.
>>>> So announce a removal event (KOBJ_REMOVE) to udev instead.
>>>>
>>>> A change is likely also required in mdadm because of the support
>>>> for kernels prior to 2.6.28.
>>>
>>> I didn't follow why we need the change. Shouldn't the KOBJ_REMOVE event=
 be sent
>>> automatically when gendisk is deleted?
>>> mddev_put()->mddev_delayed_delete()->md_free()->del_gendisk().
>>>
>>> Thanks,
>>> Shaohua
>>=20
>> For a bit of context: this KOBJ_CHANGE event was added in Oct 2008
>>=20
>> Commit: 934d9c23b4c7 ("md: destroy partitions and notify udev when md ar=
ray is stopped.")
>>=20
>> At the time, md devices weren't getting removed at all.
>> Now they are (I figured out the locking), though they can still come
>> back.
>>=20
>> There are still two stages.  The array is stopped, and then the block
>> device is destroyed.  It is theoretically possible to stop the array
>> without destroying the block device, though I don't think that happens
>> in practice.
>>=20
>> So this KOBJ_CHANGE is, I think, technically correct (change from
>> "active" to "inactive")  but probably isn't needed any more - not to the
>> extent it was at the time.
>>=20
>> There are some annoying races with caused by udev responding (belatedly)
>> to events by running programs that open s/dev/mdXX and so automatically
>> re-creates the md device.
>> The real problem here is not the event or the delays in udev.  It is the
>> fact that opening /dev/mdXX transparently creates a device.
>>=20
>> The only way (I know of) to really avoid these races is to use named
>> arrays.
>> Put
>>    CREATE names=3Dyes
>>=20
>> in mdadm.conf.  Then md arrays will be created by writing a name to a
>> magic file in /sys.  The arrays have a minor number >=3D512 and are not
>> auto-re-created if the device node is re-opened before udev unlinks it.
>>=20
>> So: the patch might be safe, and might solve a particular problem, but
>> it is really just a bandaid.  The best fix is "CREATE named=3Dyes" (and
>> use named like "md_home", not "md4".
>
> Older mdadm versions like 3.2.6 have really bad scaling issues as they
> search the whole /dev directory with map_dev() for the correct device
> and we've hit further issues with the symlinks in /dev/md/. This is why
> we've decided to go for the /dev/mdX devices directly as then also the
> minor number is clear.

Why would anyone care about the minor number?

with 'name=3Dyes', the entries in /dev are e.g. "md_foo" - no symlinks in
/dev (the exact same symlinked are in /dev/md).

If there are scaling issues, we should try to fix them.  Please report
details.

>
> I remember custom commits:
> * dev_open: add parameter 'do_map_dev'
> * mdopen: don't do 'map_dev' in 'create_mddev' if devname is /dev/mdX

Have you posted these?  Please do.

>
> I did a further test: If mdadm and the kernel don't send any uevent when
> stopping, then it also works. Might be the best solution.

I'm glad it works for your test cases, but that doesn't necessarily
means it is correct or sufficient.
I'm not exactly against removing the uevent, but I wouldn't be surprised
if that ends up causing a regression for someone who does things
differently to you.
And as I have said, I think there are other situation, maybe less
common, where udev can get bogged down and end up handling change events af=
ter
the array has been destroyed.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxPrAAAoJEDnsnt1WYoG5MiwP/RSQ/8Rg1QKH9yC7PIyv6Dzb
PW6iQ15FfK1AYoJHh4O1tOw7WX5dV5lW1orslKBty7vScO5EeKhlmoTCX53rhJBT
GPRFJevRsImxlwRWFv5Ix7ScGGBJJFd8p5YWyw8U3Eayi/b+CRTj2y7wPi+qCk6G
+nIWmIz+zQRtH90QiQN2KKTYRD7IWwbrkyIH7memzzPyyV9D58E5V2q/oO+xTYuI
GdcSsmCIRczCGm2EpFvC9ztYB06Euksw1CmEs9/cJdBLQEs76vMPAENygMyoEAOk
Kh+rQKB5PmvjxTKVCZlo+lzk14jS+x6P7pqB1HoU4HpoZkmWpz/bVV2TBmBoyX2C
OUtrUvGeT/7tP4hniCo10j6WgQvTh1Yt8SxMXZukOQhA5UQ/S0eyO15zd4xHc7U9
xrp6SFhu4gSDghhueCi1jI9nU3E1JYktYn0g5qlQvosHHg1s0hkSYvAvX9ci9oiU
5M2BKaQFt7z4Qosb5REi/Dc+PL1MKyM/5E4zMgdty/F3ch8/nef51ZczDrsGJ6nm
B2Gj1IkG4fEDlqMYqwiRU+wJ71YHEvxVPHX+Zd9/A3VSkCuTQ10MoX65+YFK1yAm
jD8HWk4vQ4hOPf/UXQ4IHYvRVguPkWF0zd+chHyRQJX70Fucd58tdXx1R9Rh3T37
mEEElDVZAa4TzwKKSrxm
=h0nG
-----END PGP SIGNATURE-----
--=-=-=--
