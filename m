From: NeilBrown <neilb@suse.com>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Tue, 08 Aug 2017 17:04:07 +1000
Message-ID: <87h8xisfq0.fsf@notabene.neil.brown.name>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net> <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net> <20170807112025.GA3094@light.dominikbrodowski.net> <20170808045103.xpi32xkjidjuxczq@kernel.org> <20170808065526.Horde.9rrpLi3TCaOrBk9KfEU4ZFP@vinovium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808065526.Horde.9rrpLi3TCaOrBk9KfEU4ZFP@vinovium.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David R <david@unsolicited.net>, Shaohua Li <shli@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 08 2017, David R wrote:

> Quoting Shaohua Li <shli@kernel.org>:
>
>> Spent some time to check this one, unfortunately I can't find how that p=
atch
>> makes rcu stall. the percpu part looks good to me too. Can you=20=20
>> double check if
>> reverting 4ad23a976413aa57 makes the issue go away? When the rcu=20=20
>> stall happens,
>> what the /sys/block/md/md0/array_state? please also attach /proc/mdstat.=
 When
>> you say the mdx_raid1 threads are in 'R' state, can you double check if =
the
>> /proc/pid/stack always 0xffffffffff?
>>
>> Thanks,
>> Shaohua
>
> I confess to knowing absolutely nothing about the md code, so please=20=20
> don't be too hard on me. However
> :-
>
> static bool set_in_sync(struct mddev *mddev)
> {
>      WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
>      if (!mddev->in_sync) {
>          mddev->sync_checkers++;
>          spin_unlock(&mddev->lock);
>          percpu_ref_switch_to_atomic_sync(&mddev->writes_pending);
>          spin_lock(&mddev->lock);
>          if (!mddev->in_sync &&
>              percpu_ref_is_zero(&mddev->writes_pending)) {
>              mddev->in_sync =3D 1;
>              /*
>               * Ensure ->in_sync is visible before we clear
>               * ->sync_checkers.
>               */
>              smp_mb();
>              set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>              sysfs_notify_dirent_safe(mddev->sysfs_state);
>          }
>          if (--mddev->sync_checkers =3D=3D 0)
>              percpu_ref_switch_to_percpu(&mddev->writes_pending);
>
>
> The switch_to_percpu() takes place under mddev->lock however=20=20
> switch_to_atomic_sync() does not. A thread can be in the middle of (or=20=
=20
> about to execute) switch_to_atomic_sync() at the same time as another=20=
=20
> is calling switch_to_percpu(). This can't be correct surely?

No, that wouldn't be correct.

When switch_to_atomic_sync is called, ->sync_checkers > 0.
When switch_to_percpu is called ->sync_checkers =3D=3D 0.

So they cannot happen at the same time.

Thanks for looking at the code!

NeilBrown

>
> Cheers
> David

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmJYmgACgkQOeye3VZi
gbl3jBAAsM54Ww8bzIlNrcji79UtOzKg0dvbhF3zN3aRrfXSjYxCdktorpjv8HBt
d/5gM5oHxpT4nshOfyXmDsS1IE/NC2latPCTzXkXX5pvWRlmeV7v8Vm1+1pu7/oZ
qt2lBj6aLLtAyVnKOEJpTvE90zfdFgIUEs5lP2C3fKXdyzxih6Et7k2psiON1JKR
dyGoojRyFPPAx040pGKkmxLQbE5di9SVws+t+iSeQ2KzqwOoCxhiodbOdU3jny5n
bc8/S6tU8GwjMjCPy799DZxO82ucesVgB+lqRmosZjpCtPdgfWNr1Pc6QiQOyG2s
cv08OoMvTcnMfJt/OZ3WlsVC5a7MoU/qaKLcgOlGSrFGIy6+QIwCJs2/zZJfnrvA
yjRZn8RA6tdA/iTzAu/zigwJSpFvsq48XcQW4NiPdzbltFLdueMIoAwNJQAsFKoL
qhKHJCBLEv4HUsiVoQ9NsvJTtZHzpuMS1LEZBRjge4MPDx4bHDajTmnjJEfLAn+Q
ciWsRK5fO//vyVsvRGy+rTrnkDznxj6Z11P3RhDH5/fWY05lZZz0foYbjm0+XLeT
d78e4sEshmOQ4+nEH3Mfl/TcRRvYQGE8n9tRKIf8juUJ1aw0vOooxRViryuw3OO+
tnybMFSZ+hWfWsra1CerppSjwyjWRpaFteVvK/hWeeQplfByEw0=
=+ZN1
-----END PGP SIGNATURE-----
--=-=-=--
