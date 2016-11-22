From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Wed, 23 Nov 2016 10:51:40 +1100
Message-ID: <878tsbcbub.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com> <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com> <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com> <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Nov 23 2016, Marc Smith wrote:

> Hi,
>
> Sorry, I'm not trying to beat a dead horse here, but I do feel
> something has changed... I just tested with Linux 4.5.2 and when
> stopping an md array (with mdadm --stop) the entry in /sys/block/ is
> removed, and even the /dev/mdXXX and /dev/md/name link are removed
> properly.
>
> When testing with Linux 4.9-rc3, the entries in /sys/block/ still
> remain (array_state attribute value is "clear") after using mdadm
> --stop and the /dev/mdXXX device exists (the /dev/md/name link is
> removed, by udev I assume).

With the latest (git) mdadm, when events are reported by "udevadm monitor"??

I only see remove events, and the entries from /dev and /sys are
removed.

If I could reproduce your problem, I would fix it...

NeilBrown

>
> Looks like Linux 4.9 is at rc6 now -- have there been any changes that
> would correct this behavior? Or is this expected behavior with the
> latest version? Not sure when this changed, but I did go back to 4.5.2
> and confirmed everything is removed correctly in that version, not
> sure if this is different starting in 4.9, or something between 4.5
> and 4.9.
>
> Can anyone else confirm with Linux 4.9 that the /sys/block/mdXXX entry
> lingers after using mdadm --stop? I suppose it could be some other
> system that is causing this on my machines. I tested using the latest
> from the master branch of mdadm and get the same result.
>
>
> Thanks for your time and help.
>
> --Marc
>
>
> On Mon, Nov 21, 2016 at 9:08 AM, Marc Smith <marc.smith@mcc.edu> wrote:
>> On Sun, Nov 20, 2016 at 10:42 PM, NeilBrown <neilb@suse.com> wrote:
>>> On Sat, Nov 19 2016, Marc Smith wrote:
>>>
>>>> On Mon, Nov 7, 2016 at 12:44 AM, NeilBrown <neilb@suse.com> wrote:
>>>>> On Sat, Nov 05 2016, Marc Smith wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> It may be that I've never noticed this before, so maybe its not a
>>>>>> problem... after using '--stop' to deactivate/stop an MD array, there
>>>>>> are remnants of it lingering, namely an entry in /sys/block (eg,
>>>>>> /sys/block/md127) and the device node in /dev remains (eg,
>>>>>> /dev/md127).
>>>>>>
>>>>>> Is this normal? Like I said, it probably is, and I've just never
>>>>>> noticed it before. I assume its not going to hurt anything, but is
>>>>>> there a way to clean it up, without rebooting? Obviously I could
>>>>>> remove the /dev entry, but what about /sys/block?
>>>>>>
>>>>>
>>>>> You can remove them both by running
>>>>>   mdadm -S /dev/md127
>>>>>
>>>>> but they'll probably just reappear again.
>>>>>
>>>>> This seems to be an on-going battle between md and udev.  I've "fixed"
>>>>> it at least once, but it keeps coming back.
>>>>>
>>>>> When md removes the md127 device, a message is sent to udev.
>>>>> As part of its response to this message, udev tries to open /dev/md127.
>>>>> Because of the rather unusual way that md devices are created (it made
>>>>> sense nearly 20 years ago when it was designed), opening /dev/md127
>>>>> causes md to create device md127 again.
>>>>>
>>>>> You could
>>>>>   mv /dev/md127 /dev/md127X
>>>>>   mdadm -S /dev/md127X
>>>>>   rm /dev/md127X
>>>>> that stop udev from opening /dev/md127.  It seems to work reliably.
>>>>>
>>>>> md used to generate a CHANGE event before the REMOVE event, and only the
>>>>> CHANGE event caused udev to open the device file.  I removed that and
>>>>> the problem went away.  Apparently some change has happened to udev and
>>>>> now it opens the file in response to REMOVE as well.
>>>>
>>>> I used "udevadm monitor -pku" to watch the events when running "mdadm
>>>> --stop /dev/md127" and this is what I see:
>>>>
>>>> --snip--
>>>> KERNEL[163074.119778] change   /devices/virtual/block/md127 (block)
>>>> ACTION=change
>>>> DEVNAME=/dev/md127
>>>> DEVPATH=/devices/virtual/block/md127
>>>> DEVTYPE=disk
>>>> MAJOR=9
>>>> MINOR=127
>>>> SEQNUM=3701
>>>> SUBSYSTEM=block
>>>>
>>>> UDEV  [163074.121569] change   /devices/virtual/block/md127 (block)
>>>> ACTION=change
>>>> DEVNAME=/dev/md127
>>>> DEVPATH=/devices/virtual/block/md127
>>>> DEVTYPE=disk
>>>> MAJOR=9
>>>> MINOR=127
>>>> SEQNUM=3701
>>>> SUBSYSTEM=block
>>>> SYSTEMD_READY=0
>>>> USEC_INITIALIZED=370470
>>>> --snip--
>>>>
>>>> I don't see any 'remove' event generated. I should mention if I hadn't
>>>> already that I'm testing md-cluster (--bitmap=clustered), and
>>>> currently using Linux 4.9-rc3.
>>>
>>> What version of mdadm are you using?
>>
>> v3.4
>>
>>
>>> You need one which contains
>>> Commit: 229e66cb9689 ("Manage.c: Only issue change events for kernels older than 2.6.28")
>>>
>>> which hasn't made it into a release yet.  But if you are playing with
>>> md-cluster, I would guess you are using the latest from git...
>>
>> Wasn't, but I will now. Thanks.
>>
>> --Marc
>>
>>
>>>
>>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNNoMAAoJEDnsnt1WYoG5Tj4P/RepqrLb1ROPLM1SGKUMP6D9
nymQzE75GXkrancehzn8IkOlkJdU7b20KuAuxvjSaDmvv+l6uF3dDPODrd3DdwE9
xyhKZ0OYrKEDkrk5DxC14lPc0HumysAu0vNDUIyGgM44SWqXQGEbTGPAzQbbA+ht
BYell4eZ21DR8OqNgGrIzOlTSxOuu1HZ9/asqCHTOmelkZjUyCqHSxaIWPMXjpDX
+myE/YTIVJrhZNbDUeuHeYtvYHjCSdMIrdFCT5JObFqa1uVzPoFnjDV1f24RtQ11
YPaT6de8zKPt1eXCJNz5nVQknNMn8oCdWO9/yV0PV4mQ+3jEgcmk88M17nhxHnID
wK6bsfPfDtA3sTzf0yMn+zfmbzpKJRTeC/WQGVfmWTPvj1JB5wtXdE4vN8Pu1Zux
EfP7FaHLAw99ycxdeY1j6DkUfcFfF0JPKhZlnwg/Z6Qxrz5sTseFG8tfftCGMFHZ
OYo6MJ6FnYA55QrbH/jmJVMfiZNHpHhdmyn+KVYiiAKSE6KGcSan0sjmLzvl7AZm
Qmay7ip8w/DLWvR/GXOiXDbkxdU46hKZdYNvsfSlurek5q0cms64MbgNmBNyWHVa
6sBI2jDZcZ+V4PZrHyBkxhg/qHqykzpqOFnVLw9LvLPKp6ACyorBfpEdjtTs15AG
xEyyn0MNpmESwbSJIlAm
=1+xc
-----END PGP SIGNATURE-----
--=-=-=--
