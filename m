From: NeilBrown <neilb@suse.com>
Subject: Re: Linux software RAID becomes unresponsive after removing a disk from server
Date: Wed, 21 Dec 2016 16:12:40 +1100
Message-ID: <8737hhsw53.fsf@notabene.neil.brown.name>
References: <7b8b1130-e79b-efcd-0579-c4a349ec5814@php-friends.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b8b1130-e79b-efcd-0579-c4a349ec5814@php-friends.de>
Sender: linux-raid-owner@vger.kernel.org
To: PHP-Friends GmbH <gl@php-friends.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 17 2016, PHP-Friends GmbH wrote:

> Hello everyone,
>
> first of all: This is in fact a crossposting from serverfault=20
> (http://serverfault.com/questions/821195/linux-software-raid-becomes-unre=
sponsive-after-removing-a-disk-from-server),=20
> as the user shodanshok recommended contacting this mailing list because=20
> to him this seems like a possible bug in the Linux RAID software. I want=
=20
> to add that I can provide more logs and information if they are needed,=20
> but as the text is already quite long I thought that would be enough for=
=20
> the moment.
>
> I am running a CentOS 7 machine (standard kernel:=20
> 3.10.0-327.36.3.el7.x86_64) with a software RAID-10 over 16x 1 TB SSDs=20
> (to be more precise, there are two RAID arrays on the disks; one of the=20
> arrays is providing the host's swap partition). Last week, a SSD failed:
>
...

> 11:48:00 kvm7 kernel: INFO: task md3_raid10:1293 blocked for more than=20
> 120 seconds.
> 11:48:00 kvm7 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
=20
> disables this message.
> 11:48:00 kvm7 kernel: md3_raid10      D ffff883f26e55c00     0 1293=20=20=
=20=20=20=20
> 2 0x00000000
> 11:48:00 kvm7 kernel: ffff887f24bd7c58 0000000000000046 ffff887f212eb980=
=20
> ffff887f24bd7fd8
> 11:48:00 kvm7 kernel: ffff887f24bd7fd8 ffff887f24bd7fd8 ffff887f212eb980=
=20
> ffff887f23514400
> 11:48:00 kvm7 kernel: ffff887f235144dc 0000000000000001 ffff887f23514500=
=20
> ffff8807fa4c4300
> 11:48:00 kvm7 kernel: Call Trace:
> 11:48:00 kvm7 kernel: [<ffffffff8163bb39>] schedule+0x29/0x70
> 11:48:00 kvm7 kernel: [<ffffffffa0104ef7>] freeze_array+0xb7/0x180 [raid1=
0]

Might be a known bug, maybe the one fixed by
 Commit: ccfc7bf1f09d ("raid1: include bio_end_io_list in nr_queued to prev=
ent freeze_array hang")

I have no idea what patches are included in your centos kernel.
In general, we only provide support for mainline kernels here.  Not
because we don't want to support others, but because digging around
inside a non-mainline kernel is much more work.

BTW, to remove a device from an md array after it has been physically
removed from the system, you can use
  mdadm /dev/mdXX --remove detached
That wouldn't have helped you here, but for future reference.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhaD0gACgkQOeye3VZi
gbneQg//Zi3xlcxowQWRi8S2ZlZ95JN7th6j8M+/y2UzKNZSgMs3SOp1SIcQ2DJx
Sf6rsAokzoSoY4D9dpaV0vokdLOI3mQp4UCmmlwrnRdKjpXy1O9RGQX8jSzCJIJ2
l/EKbsGovegdNDXlsb6V3tIKxA9Hv7V99CiqiHe2cB5kKqRgg3d8LcYoXI5l7yTg
HlWBud2QA16Xlvcf6PEUobHLGY0EqLbBfYnRq/zj0MNZES3E21GMIrybU2JZNSQs
iE43hNhvZ/9NrxKngQoiR2w5ilyiy3C1WqdrFtS+gf3w6BHPQTUedA1X9+M8FwOz
0/patu7kz8Kz+lPaL5Rhsh2+DdKg9hgsKs2qmYLbnfwneHVTdHOB4ekM0/betUy8
P+qgyS98LoB+6ta5qtLvoIvU8kn8QSObylBSEvZZ1dSpnb4wQCca60zTAOeVSmQ5
+N7z6y94G1ospEOI5rgfWtHElxyvrAajZwX5Z0sPHQHq1qM0x9OL7DJFPUU028w1
0JxdPw19o8XeLonBSW/N4qrEmUIUyCFi5fVXm7+cPZ16mopia1ZbF9/dpEgumBPa
wl0XgDhZHdylD+e/aJGtc/QyDP6WmGruJaMaYABNhGbdq1cXrXO9w+geoyouIu2S
KGQQSpVKlOgNTSu2/4MSpHXP7P3cIc6Qw77mm2+ORH1o0oJE4uU=
=lrwv
-----END PGP SIGNATURE-----
--=-=-=--
