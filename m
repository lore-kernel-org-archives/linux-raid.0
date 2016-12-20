From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Wed, 21 Dec 2016 08:23:02 +1100
Message-ID: <871sx2thvt.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com> <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com> <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com> <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com> <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com> <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com> <87oa07tu6q.fsf@notabene.neil.brown.name> <CAMGffEmEUg2Xrg-v_z+cMxzsH-Uk6bDCqTSA7vGoPw4f2dvu0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEmEUg2Xrg-v_z+cMxzsH-Uk6bDCqTSA7vGoPw4f2dvu0A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 20 2016, Jinpu Wang wrote:

> Hi Neil,
>> This is the problem.  'hold' hasn't been initialised.
>> We could either do:
>>   bio_list_init(&hold);
>>   bio_list_merge(&hold, &bio_list_on_stack);
> I tried above variant first and it lead to panic in endio path:
>
...
>
>     [exception RIP: bio_check_pages_dirty+65]


I can't explain that at all.  Maybe if I saw the complete patch I would
be able to see what went wrong (or maybe there is a separate cause).

>>
>> You didn't find 'hold' to be necessary in your testing, but I think that
>> is more complex arrangements it could make an important difference.
>
> Could you elaborate a bit more, from my understanding, in later code,
> we pop all bio from bio_list_on_stack,
> add it to either "lower" or "same" bio_list, so merge both will have
> the whole list again, right?

If there are several bios on bio_list_on_stack, and if processing the
first one causes several calls to generic_make_request(), then we want
all the bios passed to generic_make_request() to be handled *before* the
remaining bios that were originally on bio_list_on_stack.  Of these new
bios, we want to handle those for a lower level device first, and those
for the same device after that.  Only when all of those have been
completely submitted (together with any subordinate bios submitted to
generic_make_request()) do we move on to the rest of bio_list_on_stack
(which are at the same level as the first bio, or higher in the device
stack).

The usage of 'hold' would become important when you have multiple
levels.  e.g. dm on md on scsi.  If the first bio send to dm is split,
then the first half needs to be processed all the way down to all the
scsi devices, before the second half of the split is handled.

Hope that helps,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhZoTYACgkQOeye3VZi
gbnK2A//Zuu7P0YSM6C10JwS8D/vdP/RXfTt1jz0O078pJZtr5Z2TXhkzRR4Vrj4
cHiXFheOGipstZfwtoihYxyX2SoUD/cX/05d1mJCniyz/4lv7xI0MKhW/rVAehaB
u3hnxkeSPwuk9skWjE3kUnUCZxDU1EYRUciIb9deR2hzO5rzf/Dtvtg7Ytn41TTQ
UO3aePKJ1UPdQsqSAQI3JXXPnHGq34s/ZxxjQTDXotNW+85yORuFr9ImK1pHl+fl
cawklsukDu0r7TU5MiZbPItcwVSMZ3sG0OKumgjnKQp1CxI0N7ka28kaWzhdDSPi
Qw1GsHrurofRcvDlzNJAN+Ft4ocLrWxkGL3VTt2XIbOhNfddkmCyIkKIBDYkYrX0
QlcdSOLyekveSMCRbCePfC1hGulDMdter1mI9hxCzJjrIWWp75ldNoD8M2MqWEC2
JGETMJxzQLtaRZ+1IA1u6kjIJ0Dqs8r7UzpC3oiY6lqDgytjt9eFZyilpxMckb/w
6cV5pLH3z671OvYF90Zxjjyn9w/dB+aqV54z+iaLHJQ7vpDCetsD4y3+YRrQDwgs
x4eXZQ3gavyvtOobLLKpar0D5ye67HiivoVtyNKFbnY9ZYY22PrNiv9PacMKcpYA
iIGrxM8TLV0o0N5x4LF0m4bTLXPV4iOuxPgD4g0uEeFeHz/rbZ8=
=tavO
-----END PGP SIGNATURE-----
--=-=-=--
