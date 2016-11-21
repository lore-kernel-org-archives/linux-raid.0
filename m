From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Mon, 21 Nov 2016 14:42:47 +1100
Message-ID: <87fumlebwo.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com> <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 19 2016, Marc Smith wrote:

> On Mon, Nov 7, 2016 at 12:44 AM, NeilBrown <neilb@suse.com> wrote:
>> On Sat, Nov 05 2016, Marc Smith wrote:
>>
>>> Hi,
>>>
>>> It may be that I've never noticed this before, so maybe its not a
>>> problem... after using '--stop' to deactivate/stop an MD array, there
>>> are remnants of it lingering, namely an entry in /sys/block (eg,
>>> /sys/block/md127) and the device node in /dev remains (eg,
>>> /dev/md127).
>>>
>>> Is this normal? Like I said, it probably is, and I've just never
>>> noticed it before. I assume its not going to hurt anything, but is
>>> there a way to clean it up, without rebooting? Obviously I could
>>> remove the /dev entry, but what about /sys/block?
>>>
>>
>> You can remove them both by running
>>   mdadm -S /dev/md127
>>
>> but they'll probably just reappear again.
>>
>> This seems to be an on-going battle between md and udev.  I've "fixed"
>> it at least once, but it keeps coming back.
>>
>> When md removes the md127 device, a message is sent to udev.
>> As part of its response to this message, udev tries to open /dev/md127.
>> Because of the rather unusual way that md devices are created (it made
>> sense nearly 20 years ago when it was designed), opening /dev/md127
>> causes md to create device md127 again.
>>
>> You could
>>   mv /dev/md127 /dev/md127X
>>   mdadm -S /dev/md127X
>>   rm /dev/md127X
>> that stop udev from opening /dev/md127.  It seems to work reliably.
>>
>> md used to generate a CHANGE event before the REMOVE event, and only the
>> CHANGE event caused udev to open the device file.  I removed that and
>> the problem went away.  Apparently some change has happened to udev and
>> now it opens the file in response to REMOVE as well.
>
> I used "udevadm monitor -pku" to watch the events when running "mdadm
> --stop /dev/md127" and this is what I see:
>
> --snip--
> KERNEL[163074.119778] change   /devices/virtual/block/md127 (block)
> ACTION=change
> DEVNAME=/dev/md127
> DEVPATH=/devices/virtual/block/md127
> DEVTYPE=disk
> MAJOR=9
> MINOR=127
> SEQNUM=3701
> SUBSYSTEM=block
>
> UDEV  [163074.121569] change   /devices/virtual/block/md127 (block)
> ACTION=change
> DEVNAME=/dev/md127
> DEVPATH=/devices/virtual/block/md127
> DEVTYPE=disk
> MAJOR=9
> MINOR=127
> SEQNUM=3701
> SUBSYSTEM=block
> SYSTEMD_READY=0
> USEC_INITIALIZED=370470
> --snip--
>
> I don't see any 'remove' event generated. I should mention if I hadn't
> already that I'm testing md-cluster (--bitmap=clustered), and
> currently using Linux 4.9-rc3.

What version of mdadm are you using?
You need one which contains
Commit: 229e66cb9689 ("Manage.c: Only issue change events for kernels older than 2.6.28")

which hasn't made it into a release yet.  But if you are playing with
md-cluster, I would guess you are using the latest from git...

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYMm03AAoJEDnsnt1WYoG54LkP/1kCRzkAGr0eqLwXj84nyVfF
pAt8+q68BSiOuTLED0MZz5yCIBxjZN9863+YkEPfUWNgPP58P2amiPwK1ZsB77Sz
y5BoV64JOzPaYqqRtqWv6PkOjg/IJQde/XRBxLwlMttQ9uPQzM6vWwom9SLSPehL
KgNlrSNwh0sRbZadosd1X0KeXLh9eeBqaC7fh5US1P2SrzB+UhJPuX7sbMOE47aE
4RSdIqjiVzaE1CGtvSBEGj7n3dspyNvukvyQLUHB0IgQgr5MY9oACBDXqlG+th7f
YJZZvSZtdAFP2GKYaj2x/BlmjfHbqu4RxUkhaWbClYlx3Xk4ogFoD7ZP91RLe65q
KFKj1XCx1VqxAAlGDwRgs5pxQcSmuRfEEQKr+m2DYLCbljr8p0CWV+K/A6ahCu36
T1VAdjX3vjXNSKPwkQlFAp7z7FeTSJeg0i7VUiNdoo7QVmnYc8C7+TjzRVn78ztz
+meH1pag35Afv/wxBxhVghzFXhkwQgigFlEhj6It+5SSDTegELCp/2npn9fzihdm
+2khHsD4HuhifUlU0bzrpmRc/W+Tk8oGky7it24m1iFcAdgh878XK+XMwLOifqKy
QTe5ly7yVs4SbSHdcdke4koVU/LGvJZMVPTXensrgt+nOFLFJKn+J06TmR0+Xxn1
S54rBJf1xnmGmKDvP20I
=EPoM
-----END PGP SIGNATURE-----
--=-=-=--
