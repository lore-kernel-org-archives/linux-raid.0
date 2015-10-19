From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH 3/6] Enable create array with write journal (--write-journal DEVICE).
Date: Mon, 19 Oct 2015 13:42:08 +1100
Message-ID: <87fv17lgu7.fsf@notabene.neil.brown.name>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com> <1440804426-1461372-4-git-send-email-songliubraving@fb.com> <CAPcyv4g8b=RS7um6KzpmfrEtF1WaC2DF050gDNdA7MxP6mh-nw@mail.gmail.com> <C709E4D363AAB64590BFAC54D4C478AA0104B88525@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AA0104B88525@PRN-MBX02-4.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Song Liu <songliubraving@fb.com> writes:
>>=20
>> Hmm, perhaps this should instead follow the same command line mechanics
>> as "--write-mostly" whereby all the devices listed after that flag take =
on that
>> role.  Also, if we anticipate more roles I wonder if the option should b=
e "--
>> role=3D" that assigns the given role to the device(s) that follow.
>>=20
>> Thoughts?
>>=20
>> I'm looking at this from the perspective of reviving the SRT patches [1]=
 where
>> a role for a read/write cache device is needed.  Where a read/write-cach=
e is
>> different than a journal.
>>=20
>> [1]:
>> https://urldefense.proofpoint.com/v1/url?u=3Dhttps://lwn.net/Articles/59=
661
>> 4/&k=3DZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3DJ3jGe56dIPfS5TN6DM82U
>> YbbeR1j2viaiSJI40tv6lE%3D%0A&m=3Ddv5znFd%2BTZdHZaSKjzBVqJbdtNBALR0
>> RgzhZsOmsWAU%3D%0A&s=3D80c812981ff98264cf1bb2b79032863d4e33ba100
>> 093d41956eab3fbd33b5635
>
> I think --write-mostly is used as _hint_ to RAID 1 that differentiates SS=
D from=20
> HDD. While --write-journal turns on "MD_FEATURE_JOURNAL" and specifies=20
> journal device. We should not need more than 1 journal device. In this se=
nse,=20
> I think current --write-journal works well...

=2D-write-mostly isn't a hint.  It is a clear statement that these devices
should only be read from if there is no other option (the original
justification had nothing to do with SSDs).

However a write journal is a very different thing to the other devices.
For example it is not counted in the --raid-disks and --spare-disks
where as all other devices (whether --write-mostly or not) are.

If anything --write-journal is more like a --bitmap=3D/some/file than
=2D-write-mostly.

So, I'm happy for --write-journal to stay as it is.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJFiAAAoJEDnsnt1WYoG59HcQAKdNs6dpvgpjY7ZLrAXYprjq
VoEMzzpOUL/eD9q4qZbD5QGpHPXEBZsSKLBv9CdL5zsJ3RYJwhhRo5TMLxsTk9Td
09oVIaV+x0ST4CTq8xPHjpbf18WlgwMRDi+IYyneKjBGQBbpALvrUlRxtn1g1KbN
exvQJQhmnBjjEva1AQoCZ7aGharO1nOlEI7DMTqPFVxd59cPc7J3xCuzFGM0NBBW
qXxYdECLhW9sUjBzkSG7SMkQJoQIrjNljQ0rUfHRktDuC9mfaOz3EPRZJFXT6ULE
ZC2ZuG9Lkw4wXxTYrNLRallfTLVsmk9gIwpUqxyIYfPcwkWVkp3SROZLr8oCYi09
ONYSkVfXTd8yG/q1zQprc5VteMpdA3jxtBZcCBVxOfdMpxeQn98FPgqAgGqXn36Y
aVIaBt0Ymr96++MYOSi3MRehsSqA3ws9fwpVDoXRm5bajFHZtaWIAC5XUsRACufh
I+618fsqw2pW5OHg/JJKwUaSD2UL2uRceStx6mtmQjfeO4vg4VzhUHZe4+XpZuTZ
gGlIpfd26KV8D3I6zXihZIKz0BTbvW8MYRFeMc+1AepQemhgXuVy/S6WbKbABvcB
YTEpxI5MvzlkdNpczTaBCdr6NdLLLq70xtpWkTPWLMFpVLk9HJcmO5yoKtYvzwCE
JM3QMLvSdJ725ZVma4vL
=A3gT
-----END PGP SIGNATURE-----
--=-=-=--
