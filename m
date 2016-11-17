From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Fri, 18 Nov 2016 09:43:44 +1100
Message-ID: <87d1hthgm7.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com> <87lgwihc2v.fsf@notabene.neil.brown.name> <20161117150954.GH21587@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117150954.GH21587@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Andy Smith wrote:

> Hi Neil,
>
> On Thu, Nov 17, 2016 at 05:09:28PM +1100, NeilBrown wrote:
>> On Thu, Nov 17 2016, Andy Smith wrote:
>> > After install the name of the server was changed from "tbd" to
>> > "jfd". Another array was then created (md5), added to
>> > /etc/mdadm/mdadm.conf and the initramfs was rebuilt
>> > (update-initramfs -u).
>> >
>> > md5 does not auto-assemble. It can be started fine after boot with:
>> >
>> >     # mdadm --assemble /dev/md5
>> >
>> > or:
>> >
>> >     # mdadm --incremental /dev/sdc
>> >     # mdadm --incremental /dev/sdd
>>=20
>> This is almost exactly what udev does when the devices are discovered,
>> so if it works here, it should work when udev does it.
>
> Indeed. So confusing. :(
>
>> My only guess is that maybe the "DEVICE /dev/sd*" line in the mdadm.conf
>> is causing confusion.  udev might be using a different name, though that
>> would be odd.
>>=20
>> Can you try removing that line and see if it makes a difference?
>
> I've now tried that and it hasn't made a difference.
>
> I don't know anything about udev but I guess that assembly is
> handled by /lib/udev/rules.d/64-md-raid-assembly.rules whose only
> relevant ACTION lines are:
>
> # remember you can limit what gets auto/incrementally assembled by
> # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> ACTION=3D=3D"add|change", IMPORT{program}=3D"/sbin/mdadm --incremental --=
export $tempnode --offroot ${DEVLINKS}"
> ACTION=3D=3D"add|change", ENV{MD_STARTED}=3D=3D"*unsafe*", ENV{MD_FOREIGN=
}=3D=3D"no", ENV{SYSTEMD_WANTS}+=3D"mdadm-last-resort@$env{MD_DEVICE}.timer"
>
> =E2=80=A6but I can't work out why they wouldn't be working here.
>
> Time for a Debian bug report?

Maybe, though as they are using *exactly* the upstream mdadm-udev files
it probably isn't something they've broken.
Something you could try, after boot and while the arrays are still not
assembled, is

  echo change > /sys/block/sdc/uevent
  echo change > /sys/block/sdd/uevent

That should cause udev to assemble the array.
If you had "udevadm monitor" running at the same time, you would even
see the events.

Alternately you could use "udevadm trigger" instead of the "echo"
commands. That effectively sends 'change' to all devices.

If that doesn't work, the looking over the udev logs, and possibly
turning on extra udev logging, might lead to an answer.

If it does work, then we need to work out why it doesn't work earlier in
boot.
/etc/init.d/udev runs "udevadm trigger --action=3Dadd" which should pick
up anything that the initrd missed.  Maybe adding some tracing around
that would help.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLjKhAAoJEDnsnt1WYoG5meMQAIt8g9+Ir6Mb4xWkrcjzyt+z
w6qsw+hsLIDAmWGjUGgp36Uttvheq8IuBmOUOZSg5rZMV0JZo9hTYRq5tutNXaYI
eLguLF4LsC7hM7UI45krGVRzsuqixlVLvnBe/00vo7ES99atckcc7FZTtzs/uhIh
FeWfa7nZrdExRxx8/UxTISxaaO/glPkawzy9vrnl383PNUwQ/PNPDEcpbi+d17jD
psCCpZRl3ER1FRDIGQG+A6aHG/HkUAKV6IrMnXpX+BYVZgKCN+ilbvJKtwbGoesZ
pGtKJMj32m4r58C58HrNN675SITSDnyLueLPfGIO/LSO4LsYqZziOU1EOMxrLv6k
azy2Z6zPgJZ9fwqON/fwx5ob3ZZ8oqnv+EvBVwQg+GNi6Z+X84Rh9nq/L9DkH8kC
gxx0jodLXo3hCxz3QYivErunJ6V6SO/faf2dX0gsl+vSu3nWtCHa/DW86KUHxzPB
mCCpUjsa9wTrQ3YRETy2RmuTwbQkd+DJVQGzmMiVkGglc1h7K0XEXecnHOmjBddl
9nB1N54M794tWfd4txNWE7UsxMD8JReYzis7tFWPNGFaYSbPJEeLfd4wT0v5sJWV
lxq5JIRVVeBy8I99xsl/9o5gM+7VwJl+bXk7vaUPDKGoTqm3695IwbNqeq8a64rH
4BZXJdCrpsDIsZN1IHB3
=D9e6
-----END PGP SIGNATURE-----
--=-=-=--
