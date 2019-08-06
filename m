From: NeilBrown <neilb@suse.com>
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency than Kernel 4.4 with raid1
Date: Wed, 07 Aug 2019 09:40:26 +1000
Message-ID: <87blx1kglx.fsf@notabene.neil.brown.name>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com> <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de> <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com> <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com> <87h86vjhv0.fsf@notabene.neil.brown.name> <CAMGffEnKXQJBbDS8Yi0S5ZKEMHVJ2_SKVPHeb9Rcd6oT_8eTuw@mail.gmail.com> <CAMGffEkfs0KsuWX8vGY==1dym78d6wsao_otSjzBAPzwGtoQcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkfs0KsuWX8vGY==1dym78d6wsao_otSjzBAPzwGtoQcw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>, Neil F Brown <nfbrown@suse.com>
Cc: Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06 2019, Jinpu Wang wrote:

> On Tue, Aug 6, 2019 at 9:54 AM Jinpu Wang <jinpu.wang@cloud.ionos.com> wr=
ote:
>>
>> On Tue, Aug 6, 2019 at 1:46 AM NeilBrown <neilb@suse.com> wrote:
>> >
>> > On Mon, Aug 05 2019, Jinpu Wang wrote:
>> >
>> > > Hi Neil,
>> > >
>> > > For the md higher write IO latency problem, I bisected it to these c=
ommits:
>> > >
>> > > 4ad23a97 MD: use per-cpu counter for writes_pending
>> > > 210f7cd percpu-refcount: support synchronous switch to atomic mode.
>> > >
>> > > Do you maybe have an idea? How can we fix it?
>> >
>> > Hmmm.... not sure.
>> Hi Neil,
>>
>> Thanks for reply, detailed result in line.

Thanks for the extra testing.
...
> [  105.133299] md md0 in_sync is 0, sb_flags 2, recovery 3, external
> 0, safemode 0, recovery_cp 524288
...

ahh - the resync was still happening.  That explains why set_in_sync()
is being called so often.  If you wait for sync to complete (or create
the array with --assume-clean) you should see more normal behaviour.

This patch should fix it.  I think we can do better but it would be more
complex so no suitable for backports to -stable.

Once you confirm it works, I'll send it upstream with a
Reported-and-Tested-by from you.

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 24638ccedce4..624cf1ac43dc 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8900,6 +8900,7 @@ void md_check_recovery(struct mddev *mddev)
=20
 	if (mddev_trylock(mddev)) {
 		int spares =3D 0;
+		bool try_set_sync =3D mddev->safemode !=3D 0;
=20
 		if (!mddev->external && mddev->safemode =3D=3D 1)
 			mddev->safemode =3D 0;
@@ -8945,7 +8946,7 @@ void md_check_recovery(struct mddev *mddev)
 			}
 		}
=20
=2D		if (!mddev->external && !mddev->in_sync) {
+		if (try_set_sync && !mddev->external && !mddev->in_sync) {
 			spin_lock(&mddev->lock);
 			set_in_sync(mddev);
 			spin_unlock(&mddev->lock);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1KD+oACgkQOeye3VZi
gbkOBBAAvAchxMWgyz5FTx4uM4/I228Z2NCgD/+0UHkI6Z46bivBLwpCu3BhqSgX
EADIcAm+gfJU569NUFaMBQbTy+m/X3e6GoEaN6hVrilBhNKTOyUSibk6qFTXT9J0
2el59+qsf2fx9MqtwT5ClEMTIIp9P1251snNDMSdIFjJwmEe1tKTselsO2GI4fNJ
0CNBxsUa4dQwDOLx7+7at7dWF26ZRWVWkSp+eaUgtyxc3w2WFroM7xAlIvr6pzwL
M/mfLTXNyuSUsB2em/QsXiguKECbtZYDhhQrspYbvS/Z6CZYGalDQGhCv9efeVvQ
7MAGSeo3emoy5fm2JB9z+xqF6KHdG+uK0PNOs7LE22tBiSnPlXW3raGZso2K7arQ
H++UvSwkqRTw8GY2vTa0wLJ0cG4I7twXJjxrFQU8Tjk89BUECxryW9TkJHl/AjhU
hL6X+itFyKMg7mc2H7B0PqdLz5dkcvnpJbmbs0O3BFNEGGjR+PG+qdAee/fbPmxk
p5X2qRocvzUG8AaAlVpYJpaUi++9B5EPxtaGaMEiz4Xa4mEvFzwZ2KXIytJfiy7X
mUo/EOGtodMV2L8Rim5hSXTTx29NYh97/PiPFb+GMRwm+txNyopiFi+GyK072GTq
7trxozNthdQLrvEAq9CTa/yyxDHVtEhTL7Mun85HqZIrUZdf15c=
=O8+M
-----END PGP SIGNATURE-----
--=-=-=--
