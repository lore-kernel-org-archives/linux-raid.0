From: NeilBrown <neilb@suse.com>
Subject: Re: [lvm-devel] [lvm2 PATCH] Remove special-case for md in 69-dm-lvm-metadata.rules
Date: Thu, 05 Jan 2017 14:44:20 +1100
Message-ID: <87wpeakw6j.fsf@notabene.neil.brown.name>
References: <87eg0jmrgz.fsf@notabene.neil.brown.name> <e0225e4c-80fe-359e-462a-5829195ca5b6@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e0225e4c-80fe-359e-462a-5829195ca5b6@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, LVM2 development <lvm-devel@redhat.com>, linux-raid@vger.kernel.org
Cc: Lidong Zhong <lidong.zhong@suse.com>, GuoQing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04 2017, Peter Rajnoha wrote:

> On 01/04/2017 04:30 AM, NeilBrown wrote:
>>=20
>> This special casing brings no value.  It appears to attempt to
>> determine if the array is active yet or not, and to skip
>> processing if the array has not yet been started.
>
> Hi Neil,
>
> those rules also have another use which is to not trigger further
> unnecessary actions if the device is already up and running, hence
> avoiding useless resource consumption if it brings no new information.
> Currently, this is applied only for running pvscan on top of newly
> activated MD device (that's why it's part of 69-dm-lvm-metad.rules
> at the moment).

I am having difficulty seeing why MD devices should be handled
differently from any others in this respect.  If you want to filter out
unhelpful event for MD, surely you should filter them out for all
devices??

I also wonder if there are really so many unhelpful events that there is
a genuine gain in filtering them out.

>
> So what we also need is to detect the very first CHANGE event
> that makes the device active and to make a difference between this
> first CHANGE event and further CHANGE events which are possibly
> part of the WATCH rule and any other possible CHANGE events which
> do not notify about the device switching from "not ready" to "ready"
> state (of course, counting with possible coldplug events).
>
>> However, if the array hasn't been started, then "blkid" will
>> not have been able to read a signature, so:
>>   ENV{ID_FS_TYPE}!=3D"LVM2_member|LVM1_member", GOTO=3D"lvm_end"
>> will have caused all this code to be skipped.
>>=20
>> Further, this code causes incorrect behaviour in at least one case.
>> It assumes that the first "add" event should be ignored, as it will be
>> followed by a "change" event which indicates the array coming on line.
>> This is consistent with how the kernel sends events, but not always
>> consistent with how this script sees event.
>> Specifically: if the initrd has "mdadm" support installed, but not
>> "lvm2" support, then the initial "add" and "change" events will
>> happen while the initrd is in charge and this file is not available.
>> Once the root filesystem is mountd, this file will be available
>> and "udevadm trigger --action=3Dadd" will be run.
>> So the first and only event seen by this script for an md device will be
>> "add", and it will incorrectly ignore it.
>>=20
>
> Yes, you're right that in this case, it's not behaving correctly when
> the initrd doesn't have this rule while the root FS does.  To fix this
> issue for now, I suggest to separate those rule out of 69-dm-lvm-metad.ru=
les
> and make it a part of MD rules so that rule is always available both in
> initrd and root fs when MD is used (while LVM doesn't need to be
> installed in initrd).
>
> This comes right on time because right at this very moment, I'm working
> on a design for a solution which covers this area - I'll surely pass you
> the design doc once it's more complete (should be in next few days) so
> you we can discuss this problem further. This will cover the *standard*
> notification about when the block device is ready which provides a
> standard way of letting others (rules or any uevent monitors) know when
> the switch from "not ready" to "ready" state happens exactly. This should
> save us lots of unnecessary work that is done at the moment - we don't
> need to fire scans and further inspection of the device for all the
> events all the time. This work also covers identification of spurious
> events coming as a result of the WATCH rule and minimization of its
> impact on uevent processing performance in userspace.

I'd certainly be very interested to read and comment on your design.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhtwRQACgkQOeye3VZi
gbkrnBAAhYuXPhpTL7t/d2dcLwM3nDCADzOw0opjSfUiQOz23r5yfe16XGNBC8Ei
g71yQaZ46cOaXmsYWBV0ZPDVjke9rwf1bGljCPqm6uwew6LSaDe/OqxUKkDWGXgT
vQkOhd5xMiubeoyVbcS3vzAiBXm0/oGX59tpjEB5Prvdysv7/64oPaGGAi4BoXAE
Bu4MXP8LAqov5BG6j/nESjLoTzCgKfB2EC8qtF2dUuz5zgytfRn2UGWSyQDVoIay
7EKriUqfbmraY0ockJdLz6ZwWS42LeLvMConc4RG+bqJcBDG3cGQOXQ4hkHAqrBg
RylAAZMgaL+5EZN/SjpZYI8G7JFuvKbULhfZDHi0FFPX8UPROqpQdqbSpl3/oHFB
5i9UkxucWbYkP6+NK7+KGzv4NTAK08l8KCbEPwJ+D9w/Hgtyi3b/GRIjZzarIfks
+zM46Z9NsGGg9eEKlhW65dAKBbAHx2ptRGsMwoJoSixV+toqMmawUiN1fdzLdtx8
CIWDGLuMg2zdMiDCCTYyiWcsJyIgwuDoUuFUAn874h+riOLchXIkSSUBW1SzWecN
Md3i/v1iXgApKUwRCEpbGiwP2QzHrOvFmr78PR/+CdAFR2P3P1R1mw05Rh+itPrv
fKSJzq10vigyJFB8uCxsgnPIJvxMwiS7O0X1fTcbpSoD8kcynrk=
=a8HU
-----END PGP SIGNATURE-----
--=-=-=--
