From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Fri, 30 Oct 2015 12:35:04 +1100
Message-ID: <87ziz1w33r.fsf@notabene.neil.brown.name>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru> <87r3kebjgx.fsf@notabene.neil.brown.name> <30651446128148@webcorp02d.yandex-team.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <30651446128148@webcorp02d.yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <klamm@yandex-team.ru>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30 2015, Roman Gushchin wrote:

> 29.10.2015, 03:35, "Neil Brown" <neilb@suse.de>:
>> On Wed, Oct 28 2015, Roman Gushchin wrote:
>>
>>> =C2=A0After commit 566c09c53455 ("raid5: relieve lock contention in get=
_active_stripe()")
>>> =C2=A0__find_stripe() is called under conf->hash_locks + hash.
>>> =C2=A0But handle_stripe_clean_event() calls remove_hash() under
>>> =C2=A0conf->device_lock.
>>>
>>> =C2=A0Under some cirscumstances the hash chain can be circuited,
>>> =C2=A0and we get an infinite loop with disabled interrupts and locked h=
ash
>>> =C2=A0lock in __find_stripe(). This leads to hard lockup on multiple CP=
Us
>>> =C2=A0and following system crash.
>>>
>>> =C2=A0I was able to reproduce this behavior on raid6 over 6 ssd disks.
>>> =C2=A0The devices_handle_discard_safely option should be set to enable =
trim
>>> =C2=A0support. The following script was used:
>>>
>>> =C2=A0for i in `seq 1 32`; do
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dd if=3D/dev/zero of=3Dlarge$i bs=3D10M c=
ount=3D100 &
>>> =C2=A0done
>>>
>>> =C2=A0Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
>>> =C2=A0Cc: Neil Brown <neilb@suse.de>
>>> =C2=A0Cc: Shaohua Li <shli@kernel.org>
>>> =C2=A0Cc: linux-raid@vger.kernel.org
>>> =C2=A0Cc: <stable@vger.kernel.org> # 3.10 - 3.19
>>
>> Hi Roman,
>> =C2=A0thanks for reporting this and providing a fix.
>>
>> I'm a bit confused by that stable range: 3.10 - 3.19
>>
>> The commit you identify as introducing the bug was added in 3.13, so
>> presumably 3.10, 3.11, 3.12 are not affected.
>
> Sure, it's my mistake. Correct range is 3.13 - 3.19. Sorry.
>
>> Also the bug is still present in mainline, so 4.0, 4.1, 4.2 are also
>> affected, though the patch needs to be revised a bit for 4.1 and later.
>
> Yes, exactly, but things are a bit more complicated in mainline.
> I'll try to prepare a patch for mainline in a couple of days.
>
Thanks for the confirmation.

Isn't the 4.1 fix just:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e5befa356dbe..6e4350a78257 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3522,16 +3522,16 @@ returnbi:
 		 * no updated data, so remove it from hash list and the stripe
 		 * will be reinitialized
 		 */
=2D		spin_lock_irq(&conf->device_lock);
 unhash:
+		spin_lock_irq(conf->hash_locks + sh->hash_lock_index);
 		remove_hash(sh);
+		spin_unlock_irq(conf->hash_locks + sh->hash_lock_index);
 		if (head_sh->batch_head) {
 			sh =3D list_first_entry(&sh->batch_list,
 					      struct stripe_head, batch_list);
 			if (sh !=3D head_sh)
 					goto unhash;
 		}
=2D		spin_unlock_irq(&conf->device_lock);
 		sh =3D head_sh;
=20
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))

??

Or maybe
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e5befa356dbe..704ef7fcfbf8 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3509,6 +3509,7 @@ returnbi:
=20
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
+		int hash;
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
 		clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
 		if (sh->qd_idx >=3D 0) {
@@ -3522,16 +3523,17 @@ returnbi:
 		 * no updated data, so remove it from hash list and the stripe
 		 * will be reinitialized
 		 */
=2D		spin_lock_irq(&conf->device_lock);
 unhash:
+		hash =3D sh->hash_lock_index;
+		spin_lock_irq(conf->hash_locks + hash);
 		remove_hash(sh);
+		spin_unlock_irq(conf->hash_locks + hash);
 		if (head_sh->batch_head) {
 			sh =3D list_first_entry(&sh->batch_list,
 					      struct stripe_head, batch_list);
 			if (sh !=3D head_sh)
 					goto unhash;
 		}
=2D		spin_unlock_irq(&conf->device_lock);
 		sh =3D head_sh;
=20
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))


For personal reasons I would like to get this resolved today or
tomorrow, though it would be silly to rush if there is any uncertainty.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWMslIAAoJEDnsnt1WYoG5bu0P/RVQI14wLcb0HexPUuAOt+UA
iO2AIMdfsaZSd2+W85F6iJxkR5EfBxj+S0G+aCuIf8ZW/+Nf6zjvDNFq6BulspUu
JrYIYCKOqI/atuCisBr7EznLCuDlRU6fytEDgePKdT8o6+WGlwoh7O/f3boetMjW
e0qzmrsKiD6SByLF8kSIv/b3u7tkWAB6IsfiF6Q2DN19ftg6KYU1yCOI8by5991U
s83CKFkGipyL1XMdRoYxEj+XPPXJ9UkmaNjV3iYx6cuMNOZZ5iCIkrSivB9L5/k3
ouGJJGGQ7ZI1EqQ9AHxinI5J6rkAVgthdYfWp97HstISbsJCgZ2XTMBS6CFe4Y7U
bg09o0aqC4uhpv7GbQTvcQAvN26PnbmgxdSDHv1vIjg/F8lrhw2voRc56IrXt5om
shJp/1ONyiuIbrXHf6gFtcXgLPdLjks+QBNizJ2uiF5Xj7Oh5KF/Nh9Ks/SI7Uva
6dGDF4gsZo0JboaUGzp1UNOyHTG0QxTmY0ip4ydhzKiKZg4QaE9GkgrlXVWrRqzV
S+l0ok+3yZ7C3NX67d0S+oCuRL4eKmtN6MOYN1YiUK4p+z+FEXzqftmWxdknxvqb
T2lg6OaUVW4PjXAhqt77DwJX4DC8o9qjbFR2iJ15UhnNxkRmU+vGF8Eaeyaq6fHB
H1lErsprNoDacY6j3wWV
=bP8x
-----END PGP SIGNATURE-----
--=-=-=--
