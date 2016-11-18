From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Fri, 18 Nov 2016 11:01:07 +1100
Message-ID: <8760nlhd18.fsf@notabene.neil.brown.name>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com> <87wpg2heg8.fsf@notabene.neil.brown.name> <20161117181353.z7mgiynosyb664oc@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117181353.z7mgiynosyb664oc@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Shaohua Li wrote:

> On Thu, Nov 17, 2016 at 04:18:15PM +1100, Neil Brown wrote:
>> On Thu, Nov 17 2016, Shaohua Li wrote:
>>=20
>> > Currently raid5-cache update superblock in .quiesce. But since at
>> > shutdown/reboot, .quiesce is called with reconfig mutex locked,
>> > superblock isn't guaranteed to be called in reclaim thread (see
>> > 8e018c21da3). This will make assemble do unnecessary journal recovery.
>> > It doesn't corrupt data but is annoying.  This adds an extra hook to
>> > guarantee journal is flushed to raid disks.  And since this hook is
>> > called before superblock update, this will guarantee we have a uptodate
>> > superblock in shutdown/reboot
>>=20
>> Hi.
>> I don't quite follow some of the reasoning here.
>> In particular, the ->stop_writes() that you have implemented
>> does almost exactly the same thing as r5l_quiesce(1).
>> So why not simply call ->quiesce(mddev, 1) in __md_stop_writes()??
>> You probably need to also call ->quiesce(mddev, 0) to keep things
>> balanced.
>
> reboot (md_notify_reboot) doesn't call .quiesce, maybe we should do thoug=
h. And
> in stop, we hold reconfig_mutex before calling .quiesce. And with commit
> 8e018c21da3, r5l_write_super_and_discard_space tries to hold the reconfig=
_mutex
> before write super, which it can't hold, so superblock write is skipped. =
After
> .quiesce we don't write superblock. To fix the shutdown case, we can add a
> superblock write after .quiesce. But I think it's more generic to add a
> ->stop_writes since it will work for the reboot case.

I hadn't quite processed that this was about md_notify_reboot().
I would be very wary of optimizing this code.  It should certainly avoid
data loss, but anything more doesn't belong here.
During a clean shutdown the array should be stopped properly.
md_notify_reboot() is only meant for minimizing damaged caused by a
hasty "reboot -f -n".

A "clean" shutdown currently includes systemd/mdadm.shutdown (in the
mdadm package) running "mdadm --wait-clean --scan".
"mdadm --wait-clean" changes the "safe_mode_delay" so that the array
will become "clean" more quickly.
Possibly we should add something to that to trigger a flush of the
journal, and to wait for the flush to complete.

>
>> Also you have introduced a static mutex (which isn't my favourite sort
>> of thing) without giving any explanation why in the changelog comment.
>> So I cannot easily see if that addition is at all justified.
>
> Now it's possible both the reclaim thread and the thread calling
> __md_stop_writes run into r5l_do_reclaim. The mutex is trying to avoid ra=
ces.
> I'll add comments there.

It seems to me there is already quite a bit of locking in there... I'll
wait to read the comments though.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLkTDAAoJEDnsnt1WYoG5qhsP/A/SljQ2dg6XDUMISSdq8O5X
a5EEbcKl8G4qf+ag38LDzoJPdbJkiXyS2byXjMIk9gDuo2ubazMe6726T8v0WSd0
ZU/rOZPhHJX58JrDwMJ6wklJ1058M1qKlo+1QxCFB4PLxnIosANmmIXHZyRPUo10
ICb5XEYyjwztgNcUn/+v843xbObGxsshZspEVjJo5lRKi/gt23zXtNgbnYrATcfC
XbWrtQGDZI4e5pHh9/GMrLhPFiuh9HWWbIVYbMVKmcKliF3e74HQCi9LdvsLYml1
tUYzoyxKCxvL5PP3UZa0iEyM3hxTpxO3lOV9ENwjKSXIV0g0OfWvtBe1U3IrG31p
ywRYMJmnRPNZLRyjoIVgTjBYOjWEs7gl732Y5p7MSDWynpmyY/gYJEJqH2ljWOVO
apn92OdxJbZyXezBh0VOgv7aTh0dzL8yvWdFivJHraSMwFrX2Sa4m90/7loqxAnO
8W2AiWR4mI5Sxv6KkGXdP9TunK1NDPwygD3wwMG/VeAXi6b4YgWVp6UrYbKmexgd
FzQnNy1iT0jSPjjUhlZzY6/W865d6o/GXlQkrHUF9P8fhT8PZoEUIaldHv1us6+h
YzKlKgsHtuSbod1hG4TnlnKXDE30OJ0Np0wTcBHT61y9274R28AS+DAQJTbdaMbH
fsql28Ijg46ysEXfDLGf
=88mO
-----END PGP SIGNATURE-----
--=-=-=--
