From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
Date: Tue, 31 Jan 2017 23:17:03 +0300
Message-ID: <e32430d2-5f59-40af-6027-715dfde1045d@gmail.com>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <87vasxs47y.fsf@notabene.neil.brown.name>
 <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
 <87k29drr3w.fsf@notabene.neil.brown.name>
 <CAA91j0V92RXDky-AnD6w+Dy=M7KJVCWyssA7yHRfRqBxLTWvog@mail.gmail.com>
 <8760kwry0r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="61tMEB1chVGstBq0OMorEpSLJvxtk2j0E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760kwry0r.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Luke Pyzowski <Luke@sunrisefutures.com>, "systemd-devel@lists.freedesktop.org" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--61tMEB1chVGstBq0OMorEpSLJvxtk2j0E
Content-Type: multipart/mixed; boundary="1ETFtmPne6sx1Hi2s3CdAXRgh5Al1EMLN"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: NeilBrown <neilb@suse.com>
Cc: Luke Pyzowski <Luke@sunrisefutures.com>,
 "systemd-devel@lists.freedesktop.org" <systemd-devel@lists.freedesktop.org>,
 linux-raid@vger.kernel.org
Message-ID: <e32430d2-5f59-40af-6027-715dfde1045d@gmail.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <87vasxs47y.fsf@notabene.neil.brown.name>
 <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
 <87k29drr3w.fsf@notabene.neil.brown.name>
 <CAA91j0V92RXDky-AnD6w+Dy=M7KJVCWyssA7yHRfRqBxLTWvog@mail.gmail.com>
 <8760kwry0r.fsf@notabene.neil.brown.name>
In-Reply-To: <8760kwry0r.fsf@notabene.neil.brown.name>

--1ETFtmPne6sx1Hi2s3CdAXRgh5Al1EMLN
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable

31.01.2017 01:19, NeilBrown =EF=E8=F8=E5=F2:
> On Mon, Jan 30 2017, Andrei Borzenkov wrote:
>=20
>> On Mon, Jan 30, 2017 at 9:36 AM, NeilBrown <neilb@suse.com> wrote:
>> ...
>>>>>>>
>>>>>>> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
>>>>>>> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
>>>>>>> systemd[1]: Starting Activate md array even though degraded...
>>>>>>> systemd[1]: Stopped target Local File Systems.
>>>>>>> systemd[1]: Stopping Local File Systems.
>>>>>>> systemd[1]: Unmounting /share...
>>>>>>> systemd[1]: Stopped (with error) /dev/md0.
>>>>>
>> ...
>>>
>>> The race is, I think, that one I mentioned.  If the md device is star=
ted
>>> before udev tells systemd to start the timer, the Conflicts dependenc=
ies
>>> goes the "wrong" way and stops the wrong thing.
>>>
>>
>> From the logs provided it is unclear whether it is *timer* or
>> *service*. If it is timer - I do not understand why it is started
>> exactly 30 seconds after device apparently appears. This would match
>> starting service.
>=20
> My guess is that the timer is triggered immediately after the device is=

> started, but before it is mounted.
> The Conflicts directive tries to stop the device, but is cannot stop th=
e
> device and there are no dependencies yet, so nothing happen.
> After the timer fires (30 seconds later) the .service starts.  It also
> has a Conflicts directory so systemd tried to stop the device again.
> Now that it has been mounted, there is a dependences that can be
> stopped, and the device gets unmounted.
>=20
>>
>> Yet another case where system logging is hopelessly unfriendly for
>> troubleshooting :(
>>
>>> It would be nice to be able to reliably stop the timer when the devic=
e
>>> starts, without risking having the device get stopped when the timer
>>> starts, but I don't think we can reliably do that.
>>>
>>
>> Well, let's wait until we can get some more information about what hap=
pens.
>>

Not much more, but we at least have confirmed that it was indeed last
resort service which was fired off by last resort timer. Unfortunately
no trace of timer itself.

>>> Changing the
>>>   Conflicts=3Dsys-devices-virtual-block-%i.device
>>> lines to
>>>   ConditionPathExists=3D/sys/devices/virtual/block/%i
>>> might make the problem go away, without any negative consequences.
>>>
>>
>> Ugly, but yes, may be this is the only way using current systemd.
>>

This won't work. sysfs node appears as soon as the very first array
member is found and array is still inactive, while what we need is
condition "array is active".

Conflicts line works because array is not announced to systemd
(SYSTEMD_READY) until it is active. Which in turn is derived from the
content of md/array_state.

>>> The primary purpose of having the 'Conflicts' directives was so that
>>> systemd wouldn't log
>>>   Starting Activate md array even though degraded
>>> after the array was successfully started.
>>

Yes, I understand it.

>> This looks like cosmetic problem. What will happen if last resort
>> service is started when array is fully assembled? Will it do any harm?=

>=20
> Yes, it could be seen as cosmetic, but cosmetic issues can be important=

> too.  Confusing messages in logs can be harmful.
>=20
> In all likely cases, running the last-resort service won't cause any
> harm.
> If, during the 30 seconds, the array is started, then deliberately
> stopped, then partially assembled again, then when the last-resort
> service finally starts it might do the wrong thing.
> So it would be cleanest if the timer was killed as soon as the device
> is started.  But I don't think there is a practical concern.
>=20
> I guess I could make a udev rule that fires when the array started, and=

> that runs "systemctl stop mdadm-last-resort@md0.timer"
>=20


Well ... what we really need is unidirectional dependency. Actually the
way Conflicts is used *is* unidirectional anyway - nobody seriously
expects that starting foo.service will stop currently running
shutdown.target. But that is semantic we have currently.

But this probably will do to mitigate this issue until something more
generic can be implemented.


--1ETFtmPne6sx1Hi2s3CdAXRgh5Al1EMLN--

--61tMEB1chVGstBq0OMorEpSLJvxtk2j0E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAliQ8MAACgkQR6LMutpd94y3nwCeNe/9D0KRjtQqEq8+ivljygD2
GHEAoM+g3vVtQY7NqJFR6g0jxP0nE0dM
=Aj2+
-----END PGP SIGNATURE-----

--61tMEB1chVGstBq0OMorEpSLJvxtk2j0E--
