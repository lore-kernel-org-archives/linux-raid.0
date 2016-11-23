From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Thu, 24 Nov 2016 10:38:05 +1100
Message-ID: <87oa15938i.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com> <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com> <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com> <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com> <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 24 2016, Marc Smith wrote:

> On Tue, Nov 22, 2016 at 6:51 PM, NeilBrown <neilb@suse.com> wrote:
>> On Wed, Nov 23 2016, Marc Smith wrote:
>>
>>> Hi,
>>>
>>> Sorry, I'm not trying to beat a dead horse here, but I do feel
>>> something has changed... I just tested with Linux 4.5.2 and when
>>> stopping an md array (with mdadm --stop) the entry in /sys/block/ is
>>> removed, and even the /dev/mdXXX and /dev/md/name link are removed
>>> properly.
>>>
>>> When testing with Linux 4.9-rc3, the entries in /sys/block/ still
>>> remain (array_state attribute value is "clear") after using mdadm
>>> --stop and the /dev/mdXXX device exists (the /dev/md/name link is
>>> removed, by udev I assume).
>>
>> With the latest (git) mdadm, when events are reported by "udevadm monito=
r"??
>>
>> I only see remove events, and the entries from /dev and /sys are
>> removed.
>>
>> If I could reproduce your problem, I would fix it...
>
> On one set of hosts I can reliably reproduce this issue, and on
> another system I could previously reproduce this, but now seems to be
> working fine... I haven't found the connection (same distro / kernel
> versions on all hosts).
>
> # mdadm --version
> mdadm - v3.4-100-g52a9408 - 26th October 2016
>
>
> From 'mdadm --stop /dev/md/blah1' (non-clustered RAID0 array):
>
> --snip--
> # udevadm monitor -pku
> calling: monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
>
> KERNEL[32930.834312] change   /devices/virtual/block/md126 (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/md126
> DEVPATH=3D/devices/virtual/block/md126
> DEVTYPE=3Ddisk
> MAJOR=3D9
> MINOR=3D126
> SEQNUM=3D3678
> SUBSYSTEM=3Dblock
>
> UDEV  [32930.836032] change   /devices/virtual/block/md126 (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/md126
> DEVPATH=3D/devices/virtual/block/md126
> DEVTYPE=3Ddisk
> MAJOR=3D9
> MINOR=3D126
> SEQNUM=3D3678
> SUBSYSTEM=3Dblock
> SYSTEMD_READY=3D0
> USEC_INITIALIZED=3D843336612

Using the recent version of mdadm, and a kernel newer than 4.6 (commit
399146b8) a CHANGE event should only be generated when the array is
started. To see a CHANGE of stop, you must have an older mdadm or and
older kernel.... unless something else is synthesizing a CHANGE event.=20

When using a clustered array, you can also see a CHANGE event when a new
disk is being added to an array.

> --snip--
>
> Kernel logs from that:
> --snip--
> [32928.465695] md126: detected capacity change from 146681102336 to 0
> [32928.465699] md: md126 stopped.
> [32928.465702] md: unbind<dm-3>
> [32928.465798] udevd[499]: inotify event: 8 for /dev/md126
> [32928.465964] udevd[499]: device /dev/md126 closed, synthesising 'change'
> [32928.466029] udevd[499]: seq 3678 queued, 'change' 'block'
> [32928.466129] udevd[499]: seq 3678 forked new worker [27035]
> [32928.466357] udevd[27035]: seq 3678 running
> [32928.466423] udevd[27035]: removing watch on '/dev/md126'
> [32928.466492] udevd[27035]: IMPORT 'probe-bcache -o udev /dev/md126'
> /usr/lib/udev/rules.d/69-bcache.rules:16
> [32928.466712] udevd[27036]: starting 'probe-bcache -o udev /dev/md126'
> [32928.467540] udevd[27035]: 'probe-bcache -o udev /dev/md126' [27036]
> exit with return code 0
> [32928.467564] udevd[27035]: update old name,
> '/dev/disk/by-id/md-name-tgtnode1.parodyne.com:blah1' no longer
> belonging to '/devices/virtual/block/md126'
> [32928.470851] md: export_rdev(dm-3)
> [32928.470920] md: unbind<dm-2>
> [32928.478843] md: export_rdev(dm-2)
> --snip--
>
>
> From 'mdadm --stop /dev/md/asdf1' (clustered RAID1 array):
>
> --snip--
> # udevadm monitor -pku
> calling: monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
>
> KERNEL[34402.247229] change   /devices/virtual/block/md127 (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/md127
> DEVPATH=3D/devices/virtual/block/md127
> DEVTYPE=3Ddisk
> MAJOR=3D9
> MINOR=3D127
> SEQNUM=3D3679
> SUBSYSTEM=3Dblock
>
> KERNEL[34402.247885] offline
> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
> ACTION=3Doffline
> DEVPATH=3D/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
> LOCKSPACE=3D62fccfd6-605f-19e6-be6d-99a1e3cb987e
> SEQNUM=3D3680
> SUBSYSTEM=3Ddlm
>
> UDEV  [34402.248269] offline
> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
> ACTION=3Doffline
> DEVPATH=3D/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
> LOCKSPACE=3D62fccfd6-605f-19e6-be6d-99a1e3cb987e
> SEQNUM=3D3680
> SUBSYSTEM=3Ddlm
> USEC_INITIALIZED=3D402248230
>
> KERNEL[34402.248841] remove
> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
> ACTION=3Dremove
> DEVPATH=3D/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
> LOCKSPACE=3D62fccfd6-605f-19e6-be6d-99a1e3cb987e
> SEQNUM=3D3681
> SUBSYSTEM=3Ddlm
>
> UDEV  [34402.248899] change   /devices/virtual/block/md127 (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/md127
> DEVPATH=3D/devices/virtual/block/md127
> DEVTYPE=3Ddisk
> MAJOR=3D9
> MINOR=3D127
> SEQNUM=3D3679
> SUBSYSTEM=3Dblock
> SYSTEMD_READY=3D0
> USEC_INITIALIZED=3D1273670
>
> UDEV  [34402.248990] remove
> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
> ACTION=3Dremove
> DEVPATH=3D/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
> LOCKSPACE=3D62fccfd6-605f-19e6-be6d-99a1e3cb987e
> SEQNUM=3D3681
> SUBSYSTEM=3Ddlm
> USEC_INITIALIZED=3D2248905
> --snip--
>
>
> Kernel logs from that:
> --snip--
> [34399.753876] udevd[499]: inotify event: 8 for /dev/md127
> [34399.765389] md127: detected capacity change from 73340747776 to 0
> [34399.765393] md: md127 stopped.
> [34399.765579] udevd[499]: device /dev/md127 closed, synthesising 'change'

That is weird.  udev is synthesizing a CHANGE event.  How nice of it
(not!).
It doesn't do this for dm, only other devices.

This happens when an open-for-write is closed.
If you edit mdopen.c and change the O_RDWR in open_mddev() to O_RDONLY,
this change will go away.


> [34399.765656] udevd[499]: seq 3679 queued, 'change' 'block'
> [34399.765751] udevd[499]: seq 3679 forked new worker [6317]
> [34399.765878] udevd[6317]: seq 3679 running
> [34399.765943] udevd[6317]: removing watch on '/dev/md127'
> [34399.766012] udevd[6317]: IMPORT 'probe-bcache -o udev /dev/md127'
> /usr/lib/udev/rules.d/69-bcache.rules:16
> [34399.766259] udevd[6318]: starting 'probe-bcache -o udev /dev/md127'
> [34399.766295] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: leaving the
> lockspace group...
> [34399.766421] udevd[499]: seq 3680 queued, 'offline' 'dlm'
> [34399.766549] udevd[499]: seq 3680 forked new worker [6319]
> [34399.767080] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: group event don=
e 0 0
> [34399.767297] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e:
> release_lockspace final free
> [34399.767320] md: unbind<dm-1>
> [34399.795574] md: export_rdev(dm-1)
> [34399.795640] md: unbind<dm-0>
> [34399.803565] md: export_rdev(dm-0)
> --snip--
>
>
> On the other machines where the md array stopped correctly (removing
> the entries from /dev and /sys) I do see the 'remove' events with
> "udevadm monitor". What produces those remove events? Is that
> something directly from the mdadm tool, or indirectly as part of the
> stop/tear-down that mdadm initiates?

REMOVE events are generated by

md_free() -> del_gendisk() ->  blk_unregister_queue()

which should happen when the md object is finally released.
If there is no CHANGE event, then nothing should stop this from
happening.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNihdAAoJEDnsnt1WYoG5+wAQAIdmK/zgO3OTUypToVxCXFiB
ZbPJ8AiyRXuvrkRh2wzF0ROCi6CPCZOcgNnN18OPIBpmSSjZ1xkxR2ccfutYfcII
WNcxTN2tAkA+1F3f1yWyq6+jNNCXJ7gedXnukG6hbhDuVSkyLU5Jn3hEY4iZjWi7
oRgFIJEiMn0eHR7RAHjwAxZo3I+vhfFcChb6eKMSOGIG93BK4UqIUPTdSBNaXjuu
LuIgZ9uxPubeWTquhnLCYMW46PraFYy5pTQngRSnYfbtOA+Tc4U0m7RizsVn2QXd
wcxAnhJQYCLhmkO+UuG9QyHJ2JO7P0gj+DnILIpS1Q8vV/DabqqKKrrcAwm3j2jB
piF/+n7nU8O52ukyYdAJfmC65P8dfQ7sRePOkvAfUWAFLc1XIzL2oLA5ovmlyZp1
1i0kzgJKyKsvjhdR6LIIUV5gJ81DsnWShmEP4HIwNXXDo7V/cgoH6rPG/q4TOAGG
E+aS6A2iRFlUeQnZO31S6wl8u4Mwto2eFrCwM5WgMZXU+SaekQCD5DC/D4DzuDPp
z+K9vNsLrbqPup6aB1LJgldrTxmW439UDz8Ler9Z/Ilu4GdBSx8TXzvTDgGv+z4Z
zOvKp4PpCrmveZl9p3FW1rn0qVSYUWzb69AarxkmYBdFcBetfCZzwn2cQ6tLZbvP
B9Z+Ye1V1lyDVGXgzUsT
=SE7w
-----END PGP SIGNATURE-----
--=-=-=--
