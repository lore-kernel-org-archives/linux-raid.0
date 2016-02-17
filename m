From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: Drop sending a change uevent when stopping
Date: Thu, 18 Feb 2016 08:29:28 +1100
Message-ID: <871t8brpon.fsf@notabene.neil.brown.name>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com> <20160217181943.GA28011@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160217181943.GA28011@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Hannes Reinecke <hare@suse.de>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 18 2016, Shaohua Li wrote:

> On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian Parschauer wrote:
>> When stopping an MD device, then its device node /dev/mdX may still
>> exist afterwards or it is recreated by udev. The next open() call
>> can lead to creation of an inoperable MD device. The reason for
>> this is that a change event (KOBJ_CHANGE) is sent to udev which
>> races against the remove event (KOBJ_REMOVE) from md_free().
>> So drop sending the change event.
>>=20
>> A change is likely also required in mdadm as many versions send the
>> change event to udev as well.
>
> Makes sense, it's unlikely we need the CHANGE event. Applied.
>
> Thanks,
> Shaohua

It would be worth checking, but I think that with this change, you can
write
  "inactive" to /sys/block/mdXXX/md/array_state
and the array will become inactive, but no uevent will be generated,
which isn't good.
Maybe send the uevent that was just removed from the 'inactive' case of
array_state_store() instead.

(But I still think this is just a bandaid and doesn't provide any
guarantees that there will be no races with udev)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxOY4AAoJEDnsnt1WYoG5B2EP+gNtWUkvlpE/5/8vBS9NLRJw
Q/e60LY6SBbuMjgT7o/KtXCaXgulzrOJg7gjSHQc2ZvZ7RVjm2mM2xZpaw50hFuv
RSEhbkeGNZ1AXcj18yWzIcGuiJGBfGzSUHdmrDOhK0SFTEgcXIvmdolp7FIkPLVz
Lp5do0sx4XV/bHSvvMjPV1oEb448YT1g5AmB2PCCBrsJoT7QG1UhfUXs5/uwR3ZL
oT39WUnElNGqB/DFy9WPqMmlWQVTQSUC1/sQZYwrsxbIqoqInMh3vb4JIDQynUaG
VF6BxQm2Fa0uXzFTw9GAR1gjTZok8A9TgiMYCFGJ7yHMqnQQbVL/8UEUdZnmmiYI
NHDciFYYec1/tG7ocVzQQU1Lw/rTvMndodBazAuTIRIR0AKK31WCBer/29ao6R6F
XDxjwaWyn+Me0G7aJz0rcE1estBddyH1mhQXYTuQiyFOyj8WGRCNC88bcI+XFU5p
n4ug05ucWj3mpTK1EBVpSloIFWgZ12gNG7CQfFzMULDVV9UZ+pC1ubUp7t8YRa3m
lvz6EA0G2x4nb3dTbmrCUwFVbuQbbAQiywF9XnhGBYnHzBH6iFjkm0Ur2ByA9X4C
Me+uu7TDQVXzHAdMwCZU7hCDHIjeRZE/9qjfKmuXcaQTrBAiY5bXsxfQgcvFDjpu
mjK4EWxyz/G2iM63H8Cp
=MQH0
-----END PGP SIGNATURE-----
--=-=-=--
