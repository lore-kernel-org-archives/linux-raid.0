From: NeilBrown <neilb@suse.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
Date: Tue, 31 Jan 2017 09:19:48 +1100
Message-ID: <8760kwry0r.fsf@notabene.neil.brown.name>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com> <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com> <87vasxs47y.fsf@notabene.neil.brown.name> <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com> <87k29drr3w.fsf@notabene.neil.brown.name> <CAA91j0V92RXDky-AnD6w+Dy=M7KJVCWyssA7yHRfRqBxLTWvog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA91j0V92RXDky-AnD6w+Dy=M7KJVCWyssA7yHRfRqBxLTWvog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Luke Pyzowski <Luke@sunrisefutures.com>, "systemd-devel@lists.freedesktop.org" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Jan 30 2017, Andrei Borzenkov wrote:

> On Mon, Jan 30, 2017 at 9:36 AM, NeilBrown <neilb@suse.com> wrote:
> ...
>>>>>>
>>>>>> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
>>>>>> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
>>>>>> systemd[1]: Starting Activate md array even though degraded...
>>>>>> systemd[1]: Stopped target Local File Systems.
>>>>>> systemd[1]: Stopping Local File Systems.
>>>>>> systemd[1]: Unmounting /share...
>>>>>> systemd[1]: Stopped (with error) /dev/md0.
>>>>
> ...
>>
>> The race is, I think, that one I mentioned.  If the md device is started
>> before udev tells systemd to start the timer, the Conflicts dependencies
>> goes the "wrong" way and stops the wrong thing.
>>
>
> From the logs provided it is unclear whether it is *timer* or
> *service*. If it is timer - I do not understand why it is started
> exactly 30 seconds after device apparently appears. This would match
> starting service.

My guess is that the timer is triggered immediately after the device is
started, but before it is mounted.
The Conflicts directive tries to stop the device, but is cannot stop the
device and there are no dependencies yet, so nothing happen.
After the timer fires (30 seconds later) the .service starts.  It also
has a Conflicts directory so systemd tried to stop the device again.
Now that it has been mounted, there is a dependences that can be
stopped, and the device gets unmounted.

>
> Yet another case where system logging is hopelessly unfriendly for
> troubleshooting :(
>
>> It would be nice to be able to reliably stop the timer when the device
>> starts, without risking having the device get stopped when the timer
>> starts, but I don't think we can reliably do that.
>>
>
> Well, let's wait until we can get some more information about what happens.
>
>> Changing the
>>   Conflicts=sys-devices-virtual-block-%i.device
>> lines to
>>   ConditionPathExists=/sys/devices/virtual/block/%i
>> might make the problem go away, without any negative consequences.
>>
>
> Ugly, but yes, may be this is the only way using current systemd.
>
>> The primary purpose of having the 'Conflicts' directives was so that
>> systemd wouldn't log
>>   Starting Activate md array even though degraded
>> after the array was successfully started.
>
> This looks like cosmetic problem. What will happen if last resort
> service is started when array is fully assembled? Will it do any harm?

Yes, it could be seen as cosmetic, but cosmetic issues can be important
too.  Confusing messages in logs can be harmful.

In all likely cases, running the last-resort service won't cause any
harm.
If, during the 30 seconds, the array is started, then deliberately
stopped, then partially assembled again, then when the last-resort
service finally starts it might do the wrong thing.
So it would be cleanest if the timer was killed as soon as the device
is started.  But I don't think there is a practical concern.

I guess I could make a udev rule that fires when the array started, and
that runs "systemctl stop mdadm-last-resort@md0.timer"

NeilBrown


>
>> Hopefully it won't do that when the Condition fails.
>>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliPvAQACgkQOeye3VZi
gbknkQ//cV1R7ZIP/2uuIMEFaMFNhGq8Q4uQjZPkAYRvhNIRK8Z6KyWM9Rq9NFZ4
NvguaT/Ps32ihNLpRL7ZtNUK/Kd5EUg61mwkVLQa9TvgVDwAU+KzFMF9VMa41tZN
eDN8e9IrdZ9KNBs3F3KSJeXUa9X+ORAQ/W1nbSh9LcQdtyKXC4hIBFOlhks0Xhh1
PLObRvHs2pvF9z+6skDefjLkPlTUyxFFU6tv2MHg1yNmvetFedFr5JqvC79zrzwp
sszyGaD5qGh0fb7NvfML5V1ToK1Ryhk2tzAeMkFATD6ajkzUqLNL/jbKOy8kGPt4
KuVvzRXI5v6z4ND1yVttzIhEQN/Ndhgk9IcdeTaX/EHlLhgEjDZRp8rwK5Yud5FK
SDpUkpC0eZEz6f/kP1QtoU79sUy3xbiuiCIetLXHbKYVgWd+pIaY7x0YhIjlE+wu
LqxuAwr3OFIqde6YEOf8YyG2qVfUB9Q3PW60S37U9tLkDq2BktoUvIW3TSLxeSUR
prr7ySNbZ4+SybGPreJsIJF6zO4lZJd8mJpNc901oW0VytGzUOyluCyTcaWIF7Xj
gDn+ZsEusp1Bm9q3fAfhiaaH37unx49eTjSueHsaEpCs6/f9oLbZLpm1fmEgKqV3
mvQAj/bilnwQJGKA4Ne8pklP+Z4pGCy6YRyMbAowyKHUUQG7Hdg=
=C7bs
-----END PGP SIGNATURE-----
--=-=-=--
