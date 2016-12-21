From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 22 Dec 2016 10:51:40 +1100
Message-ID: <878tr8rgc3.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com> <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com> <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com> <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com> <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com> <87fulpyj33.fsf@notabene.neil.brown.name> <CAMGffEkufeaDytaHxtLR02iiQifZDhcwkLdzMj3X8_yaitSoFQ@mail.gmail.com> <87oa07tu6q.fsf@notabene.neil.brown.name> <CAMGffEmEUg2Xrg-v_z+cMxzsH-Uk6bDCqTSA7vGoPw4f2dvu0A@mail.gmail.com> <871sx2thvt.fsf@notabene.n
 eil.brown.name> <CAMGffE=OVX-jp+-SY8A4pmJHyVAkVQVXSCa_3VgndFf4tYyG9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffE=OVX-jp+-SY8A4pmJHyVAkVQVXSCa_3VgndFf4tYyG9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Dec 21 2016, Jinpu Wang wrote:

>>
> Thanks, it does help a lot, I attached the patch I'm still testing,
> but so far so good.
> Could you check if I got it right?

Yes, that looks exactly right.
I guess one of us should try to push it upstream... maybe next year :-)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhbFY0ACgkQOeye3VZi
gblm1xAAoAxHxSbYnG11I5Ck6/5PfhFqjR7z57zjdIzZPp4lPeXVao+Y8OBxF1lf
TWIvTXG83VJA6oSOqZVKX7Fssis0el96WKZv+vIl+tMwNkwCvp9Ck9taC//M/1+X
0jqipD1RyTazJPypXt9YlXFnOyfzf/bZlMku55Dq5UALPx857XnZwltz2KjeSL5J
E66rx+//CXcCr7a+ttiSC2LrExnNDxGzMqrVcPB+K8+jLr4Q2t6O/9LfRVcl84Io
pMMM8ILmd3cqiFAIJpt0UBT6HLPD9URyxfxpHQYDYcN11pz3TKkWZkd2CCZD87TK
/en2A5h1ozKj+AvFdn8zRCdtahxFLxCERTabW6vfAshIN2A1oNp6El/Smmi8DAUW
URP9UCIJ0Hhl3H5f1wBy9cHhaJaYOJ8NOvXjD84tQM7tC8/NqeGo52iLqUKkEXAJ
PDSoVtjmC3JuGFwU1AA3K5qHeXbQPt74Si09sDrRN2ejQZzMEMLiKkwETSnGs7OG
GTBVMzNjNsW75yByR8u7yqJoFf0IGXtu37v3tIhSQFJn4ZhVzJYi73RLiX+WrENs
loApG/ru9+156lzHFEvTbjqs9RazxmvInGYOO5Pbr3ojccC7rK+dLaSVSVoYExUV
sPBWoowmsjtS0eB5O4BnCjoPAUruRU2aGoMXBOMOadpKBlcrP6o=
=Dstk
-----END PGP SIGNATURE-----
--=-=-=--
