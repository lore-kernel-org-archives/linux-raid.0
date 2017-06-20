From: NeilBrown <neilb@suse.com>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Wed, 21 Jun 2017 07:02:33 +1000
Message-ID: <87efue2x06.fsf@notabene.neil.brown.name>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org> <87r2yxdazc.fsf@notabene.neil.brown.name> <20170620182745.rbufznqe4tuxqttq@merlins.org> <20170620183154.GA5303@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170620183154.GA5303@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20 2017, Marc MERLIN wrote:

> On Tue, Jun 20, 2017 at 11:27:45AM -0700, Marc MERLIN wrote:
>> On Tue, Jun 06, 2017 at 01:57:27PM +1000, NeilBrown wrote:
>> > Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
>> > would have told you how many bits were set at that time.
>> >=20
>> > That "x/y pages" information never should have appeared in /proc/mdstat
>> > - it is really just of interest to developers.  But it is there now, so
>> > removing it is awkward.
>>=20
>> So, I got the problem again, re-added a drive that had just been missing
>> for maybe 2mn, and this time I'm getting a very long (but not full)
>> recovery:
>=20=20
> Mmmh, this is puzzling.
>
> The progress meter was wrong, it recovered in 3mn:
> Jun 20 11:19:28 gargamel kernel: [  916.007017] md: recovery of RAID arra=
y md8
> Jun 20 11:22:41 gargamel kernel: [ 1108.395580] md: md8: recovery done.

It is a progress bar - haven't you learned by now that they are *always*
wrong :-)

recovery always reports progress in sectors completed, and estimates
time based on how many sectors were processes in the last 30 seconds,
and how many are left.

With a bitmap based recovery, most sectors are handled very quickly
(instantly?), while some take milliseconds.  That makes the estimate
imprecise.

NeilBrown


>
> Marc
> --=20
> "A mouse is a device used to point at the xterm you want to type in" - A.=
S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet c=
ooking
> Home page: http://marc.merlins.org/=20=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllJjWsACgkQOeye3VZi
gbmhKxAAwjThkoWyAqBiOc8wGlQtlW1MYPLpNYA1wkC9HHw/IOksbpbnyJOYsdpr
fCqnJskvdr4TdQAiSteY3f9lYIpFMZcnxgbgqHETOv/tXghtbvot5qLe8ySaKSWB
TG1zBc4ysBsaWL5fYS2Jmh4mG7/kModFw5So1KY2eXLHPzVd4FsJUC371GCiF10n
l9UrDgQiQAKwdrHzvHYhQ+Pr7Y7oyASLpbUm2zmc3gJ+3LgJN3X/FjVzDX8MGVlq
LGAyDig1h5jBs4nNm9+1tfNRJ4/fcH6mcfVrS3YNwIGjA2sK67KzeKK4xNCqwCrk
+3v71KQWRJf9VcjsmTk9IJjHHXhCVvgrtaNbBFWuFM+nOzPpWe1dqvKi0UUGV/pM
MH1AOt1OAhS9EmW7dMvVcFv3sTVy3373UfwiXTNAxTr/mFPbx74U2b0wj72N2w6Z
hwNegLIGEljvczImbfymbf12wCNCqsdx4srySHfkWVMWLQl6iQNcVktUUblP4/At
+u+SfZHpJpHbkVisYeTw2eLBrFMzH9H3WyRJu8lQIEnberpHu3d/Gs1dMClTetAv
sePHKKd4TiadzB8tHTDAAafVAPcRPeqx8HPaGkapyVVJpbjjT+WsVstSgc9VtGRg
JElB7K2X8FnLLDgiTgri+LjTKFlu5vlvjcTivXXR5+dy8Yzv/hs=
=WXO3
-----END PGP SIGNATURE-----
--=-=-=--
