From: NeilBrown <neilb@suse.com>
Subject: Re: The dev node can't be released at once after stopping raid
Date: Thu, 31 Aug 2017 14:36:08 +1000
Message-ID: <87bmmwfj5z.fsf@notabene.neil.brown.name>
References: <1159964415.16461871.1496288839399.JavaMail.zimbra@redhat.com> <43bca632-9d77-2063-603c-6dcf47f3d250@suse.com> <1471667815.16472496.1496296238179.JavaMail.zimbra@redhat.com> <1941784023.3852671.1504151717389.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1941784023.3852671.1504151717389.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30 2017, Xiao Ni wrote:

> Hi Neil
>
> I have searched in history emails and there have many topics like this. S=
orry for talking
> about this again. But it looks like the situation I encountered is differ=
ent. There is 1 second
> window between stop the raid device and delete the node /dev/md0. The /de=
v/md0 node can be
> removed successfully after 1 second.=20

I think you are saying that /dev/md0 gets deleted 1 second after the
device is stopped.  I assume that is a delay in udev processing of
events.

When you say "can be"  I assume you mean "is being".
ie. if you say
   "The node can be removed after 1 second", it seems to imply that if
   you try to remove it earlier, the unlink() will fail.
If you say
  "The node is being removed after 1 seconds", that suggests that the
  removal happens automatically, but there is a delay between the device
  stopping and the removal happening.

>
> There is no process that open the /dev/md0 after mdadm -S /dev/md0:=20
>
> mdadm -CR /dev/md0 -l1 -n2 /dev/loop0 /dev/loop1 --assume-clean
> dmesg:
> [36416.860525] Opened by mdadm, pid is 3523
> [36416.984160] md/raid1:md0: active with 2 out of 2 mirrors
> [36416.984181] md0: detected capacity change from 0 to 523239424
> [36416.984219] Released by mdadm, pid is 3523
> [36416.984228] remove_and_add_spares
> [36416.991588] Opened by mdadm, pid is 3541
> [36416.997183] Released by mdadm, pid is 3541
> [36417.001376] Opened by systemd-udevd, pid is 3525
> [36417.007128] Released by systemd-udevd, pid is 3525
>
> udev:
> KERNEL[36419.830817] add      /devices/virtual/bdi/9:0 (bdi)
> KERNEL[36419.831045] add      /devices/virtual/block/md0 (block)
> UDEV  [36419.832911] add      /devices/virtual/bdi/9:0 (bdi)
> UDEV  [36419.836380] add      /devices/virtual/block/md0 (block)
> KERNEL[36419.877705] change   /devices/virtual/block/loop0 (block)
> KERNEL[36419.878057] change   /devices/virtual/block/loop0 (block)
> KERNEL[36419.926761] change   /devices/virtual/block/loop1 (block)
> KERNEL[36419.927015] change   /devices/virtual/block/loop1 (block)
> UDEV  [36419.953112] change   /devices/virtual/block/loop0 (block)
> UDEV  [36419.953141] change   /devices/virtual/block/loop1 (block)
> KERNEL[36419.954765] change   /devices/virtual/block/md0 (block)
> UDEV  [36419.955973] change   /devices/virtual/block/loop0 (block)
> UDEV  [36419.962799] change   /devices/virtual/block/loop1 (block)
> UDEV  [36419.982934] change   /devices/virtual/block/md0 (block)
>
> mdadm -S /dev/md0
> dmesg:
> [36493.068054] Opened by mdadm, pid is 3552
> [36493.072051] Released by mdadm, pid is 3552
> [36493.076123] Opened by mdadm, pid is 3552
> [36493.080073] md0: detected capacity change from 523239424 to 0
> [36493.080077] md: md0 stopped.
> [36493.273011] Released by mdadm, pid is 3552
> udev:
> KERNEL[36496.300219] remove   /devices/virtual/bdi/9:0 (bdi)
> KERNEL[36496.300335] remove   /devices/virtual/block/md0 (block)
> UDEV  [36496.300736] remove   /devices/virtual/bdi/9:0 (bdi)
> UDEV  [36496.301812] remove   /devices/virtual/block/md0 (block)

I don't see any 1 second delay here.
I can see a 3 second delay between "Released by mdadm, pid =3D 3552" and
the UDEV remove event.  Is that what you are referring to?

>
> There are only REMOVE events during command mdadm -S /dev/md0.

The remove events seems to happen *after* "mdadm -S /dev/md0", or did
"mdadm -S /dev/md0" take 3 seconds to run?

>
> I tried to create a lvm and remove it to check whether lvm has this probl=
em or not.=20
>
> pvcreate /dev/md0=20
> vgcreate vg /dev/md0=20
> lvcreate -L 100M -n test vg
> lvremove vg/test -y
> ls /dev/mapper/vg-test
> ls /dev/dm-3
>
> The node /dev/mapper/vg-test and /dev/dm-3 can be removed in time. There =
is no time
> window. So it looks like it's a problem of md. Could you give some sugges=
tions about
> this? What should I do next?=20

Maybe lvremove explicitly unlinks the files in /dev, I don't know.

>
> If it's not a bug, why there is a 1 second window?

As I said, probably because udev is slow.
Why do you think this is a problem?  Why do you care about 1 second
window.  If I don't know how why this matters, I cannot help you.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmnkjoACgkQOeye3VZi
gbkwDQ//Yw6i4yLyGYcN2G4jCUqNWfWe2qVCerVFp3tPscRqfUTS4yfOlVHHQZEn
UNQ2sKpcvkJKwKKAX7x0xb9RnvfAQAmfkejtWXRLxecZvlUDaW5DtGj6hJHzH3b1
UnCbKIIrtGx8AFn5CypUWYIYtV928yNJsKaxiSGiMNDeE2CNWbIm87nJlAohMjsI
JRHGx2NRGSTgilx9VPIe40Z/qRA2YfTKA8ecTrlfTcdY00QhZ29bSa1cxQZRlhDz
T4sxcQuxv2koxntL9KHMuMfRE7O8CUl8TP313U8gpNN3IKCFnL0vIvgBP3+bJZ2S
WCcU/abneDlI3VfRHKDbTE06WwN7C5bOWnXKkzbVcnPkDj4KNNiyoUe0zoBY8blp
NO+DsYMKKk+zF0dnv+pIs/hh9mEZ4AGMGbkATjXkLUJd8OMN2O7xoXEBX20gnir9
7FwmVpOzA16TR3p33f8BEbkhhMdPxB912BRl1aHJpg6Ye6tUNtR8gZHmX4VfHhWk
eBB21TL6OfMCIhrUS7IODjSASbyp02xD+/1yjGFJZqGqYf/acpCSngOreI4UKB+5
XQD1n4mfosixTyXOWrXez2ERZvyaGUooKVEdPm/c+u7yN3krbpCIsmXm4ou9cqgL
b+ZxCwvoudmzEmeEL7qQdYEPe0qDbPBgNR67hlK+BUP4l9oug/k=
=8SY6
-----END PGP SIGNATURE-----
--=-=-=--
