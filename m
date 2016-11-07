From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Mon, 07 Nov 2016 16:44:18 +1100
Message-ID: <87fun3ond9.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Nov 05 2016, Marc Smith wrote:

> Hi,
>
> It may be that I've never noticed this before, so maybe its not a
> problem... after using '--stop' to deactivate/stop an MD array, there
> are remnants of it lingering, namely an entry in /sys/block (eg,
> /sys/block/md127) and the device node in /dev remains (eg,
> /dev/md127).
>
> Is this normal? Like I said, it probably is, and I've just never
> noticed it before. I assume its not going to hurt anything, but is
> there a way to clean it up, without rebooting? Obviously I could
> remove the /dev entry, but what about /sys/block?
>

You can remove them both by running
  mdadm -S /dev/md127

but they'll probably just reappear again.

This seems to be an on-going battle between md and udev.  I've "fixed"
it at least once, but it keeps coming back.

When md removes the md127 device, a message is sent to udev.
As part of its response to this message, udev tries to open /dev/md127.
Because of the rather unusual way that md devices are created (it made
sense nearly 20 years ago when it was designed), opening /dev/md127
causes md to create device md127 again.

You could
  mv /dev/md127 /dev/md127X
  mdadm -S /dev/md127X
  rm /dev/md127X
that stop udev from opening /dev/md127.  It seems to work reliably.

md used to generate a CHANGE event before the REMOVE event, and only the
CHANGE event caused udev to open the device file.  I removed that and
the problem went away.  Apparently some change has happened to udev and
now it opens the file in response to REMOVE as well.

So to "fix" it again, you need to figure out what udev is doing and fix
that.

Alternately... place "create names=yes" in your mdadm.conf
and always use names, not numbers, to work with md arrays.
e.g. /dev/md/home /dev/md/root /dev/md/scratch etc.

When will trigger the use of an alternate scheme for creating md devices
(using minor numbers >= 512) which udev cannot break so easily.  When it
tries to open /dev/md_home, that will fail.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYIBSyAAoJEDnsnt1WYoG5eSkP/3YTvflENh+HTRLWv1s78GDZ
eSJGW00FBW7jP5HHk741OS+mvBNDxl9nU2xLHME84YsIllN4rkWa9p3jgC+0DQGx
rfc5Owf5awMr4xOPHM52lmhZPEadeWEGlHIWoYWIUMhM/0IrbEM5DD0HifaRz8Rw
Z6nqoLjdjVwkLlu9PvWHc+HFZS0gPGfPZMnb5FaeBuPJ0XEZL1RPvU9vRmnUJS2p
uATHMtZt/PswD05yCEjzCsfVS7t4gu7l6+p8QC7mEBJZ1pB0XwI5wUlQXMiFBl2W
8PZ0YK5OnXMzgOegN5zZjTAl2MXvt91gEQII4egNGKL/2xpr7F03tl/nbPx2KYOI
nTtEeZFazpZxhqsUjTSNTJGkAShqJjkI7WkiiDljdrqa7Hi++yhMcliGYnrxNtST
aUSSlJEPAAo3Hf2CasBePulFN5+UTtbchVvor4+QabSmmGOvN2zzc3DL63lcDYxm
1Ja3cc98v/sxeX99DEayIKovZyzF/O/UYFO3jlWovqimr7+4wVp9DgfxbJu8h94B
aO0OdyKPupj71AXCa9h6/HSPzz1NAyUu2+laevvFKiOjKUIo3CrBjntl1yLwG65z
XNLoMi+0Y6FXohmsqu+I8hrRQb9Yr0Om86lG0k7FFrK4qe12y1h7mHXvogUtaTk7
Tb+uRW8aqfcc4KQA84Vj
=0OEY
-----END PGP SIGNATURE-----
--=-=-=--
