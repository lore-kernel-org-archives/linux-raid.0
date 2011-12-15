From: NeilBrown <neilb@suse.de>
Subject: Re: Split-Brain Protection for MD arrays
Date: Fri, 16 Dec 2011 06:40:03 +1100
Message-ID: <20111216064003.18a7ab4f@notabene.brown>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
	<20111215140252.2f9bb986@notabene.brown>
	<CAGRgLy7oCm87HRTK_FS6g80g5MQzSvto10T0PH0vE022XMsn-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SCsi_8efPAgl7r231ZmBIPq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7oCm87HRTK_FS6g80g5MQzSvto10T0PH0vE022XMsn-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SCsi_8efPAgl7r231ZmBIPq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 16:29:12 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Neil,
> thanks for the review, and for detailed answers to my questions.
>=20
> > When we mark a device 'failed' it should stay marked as 'failed'. =C2=
=A0When the
> > array is optimal again it is safe to convert all 'failed' slots to
> > 'spare/missing' but not before.
> I did not understand all that reasoning. When you say "slot", you mean
> index in the dev_roles[] array, correct? If yes, I don't see what
> importance the index has, compared to the value of the entry itself
> (which is "role" in your terminology).
> Currently, 0xFFFE means both "failed" and "missing", and that makes
> perfect sense to me. Basically this means that this entry of
> dev_roles[] is unused. When a device fails, it is kicked out of the
> array, so its entry in dev_roles[] becomes available.
> (You once mentioned that for older arrays, their dev_roles[] index was
> also their role, perhaps you are concerned about those too).
> In any case, I will be watching for changes in this area, if you
> decide to make them (although I think this might break backwards
> compatibility, unless a new version of superblock will be used).

Maybe...  as I said, "confusing" is a relevant word in this area.

>=20
> > If you have a working array and you initiate a write of a data block an=
d the
> > parity block, and if one of those writes fails, then you no longer have=
 a
> > working array. =C2=A0Some data blocks in that stripe cannot be recovere=
d.
> > So we need to make sure that admin knows the array is dead and doesn't =
just
> > re-assemble and think everything is OK.
> I see your point. I don't know what's better: to know the "last known
> good" configuration, or to know that the array has failed. I guess, I
> am just used to the former.

Possibly an 'array-has-failed' flag in the metadata would allow us to keep
the last known-good config.  But as it isn't any good any more I don't real=
ly
see the point.


>=20
> > I think to resolve this issue we need 2 thing.
> >
> > 1/ when assembling an array if any device thinks that the 'chosen' devi=
ce has
> > =C2=A0 failed, then don't trust that devices.
> I think that if any device thinks that "chosen" has failed, then
> either it has a more recent superblock, and then this device should be
> "chosen" and not the other. Or, the "chosen" device's superblock is
> the one that counts, then it doesn't matter what current device
> thinks, because array will be assembled according to the "chosen"
> superblock.

This is exactly what the current code does and it allows you to assemble an
array after a split-brain experience.  This is bad.  Checking what other
devices think of the chosen device lets you detect the effect of a
split-brain.


>=20
> > 2/ Don't erase 'failed' status from dev_roles[] until the array is
> > optimal.
>=20
> Neil, I think both these points don't resolve the following simple
> scenario: RAID1 with drive A and B. Drive A fails, array continues to
> operate on drive B. After reboot, only drive A is accessible. If we go
> ahead with assemble, we will see stale data. If after reboot, we,
> however, see only drive A, then (since B is "faulty" in A's
> superblock), we can go ahead and assemble. The change I suggested will
> abort in the first case, but will assemble in the second case.

Using --no-degraded will do what you want in both cases.  So no code change
is needed!

>=20
> But obviously, you know better what MD users expect and want.

Don't bet on it.
So far I have one vote - from you - that --no-degraded should be he default
(I think that is what you are saying).  If others agree I'll certainly
consider it more.

Note that "--no-degraded" doesn't exactly mean "not assemble a degraded
array".  It means "don't assemble an array more degraded that it was last
time it was working".  i.e. require that all devices that are working
according to the metadata are actually available.

NeilBrown



> Thanks again for taking time and reviewing the proposal! And yes, next
> time, I will put everything in the email.
>=20
> Alex.


--Sig_/SCsi_8efPAgl7r231ZmBIPq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTupNEznsnt1WYoG5AQIf8Q//Wf+nu+YpeE5HV6ZKDKDG5406qB1f2wms
U5BV6lMUbHQPd1UiqvNe5Cisk0DVup4RCmrgeK7CbpcIYBYz3Dq1qY6vJ/Au2zL5
ZYLIFJ6BeYRK2oE6Wqa4vgZie45R65nTlaSpRI3ugrC2lmlTpjXJZOdVxkrnxnYj
n74iv+99USPvjjXl36FH8dVWRG2cOqBkOYBPOlv+N0yDLPye4nIEi5a8fT+OrlEl
Acf+x6kzruLvO5lLJbBY0snNEk8+dQgZY1YVBplLrdjga9Up+Yz+1IU9PhoS2oc8
vyuJnDx+UcJ2b9xGrCGeIIdpQl6hzK63L+269m0/4Bue+mjpI4tuxnm7vaynpWQE
sBR03x8vqK0oo2K26szKe89clKeFiARa/p3yCokJSpnknQfoXfYfLVtBPXCoLrqB
iphEvgIAF7BgZbCI6JRNA616z8fORIVsg5JeZ2vvXquV9rZ6fQ60T4bgj2ajgTO7
OHN4i+spSKT+XWmUinr39/dlybpdqCSqY5mkqA/JxnpuMyDjWUvnRshJokQGD7Ks
MibrtoqvJozqWZxgG9E4tnKMiSPZQ24tntrSlkiCsabnhW812oq/wi2NS9p4ZThy
H/6PhAPQQbKzJqovJmcHZlJincjst/2XzEZBa7woBaOzGimeM/OkFW6TnvFwApCs
C7oIgI9ak2U=
=kRuN
-----END PGP SIGNATURE-----

--Sig_/SCsi_8efPAgl7r231ZmBIPq--
