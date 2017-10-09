From: NeilBrown <neilb@suse.com>
Subject: Re: hung grow
Date: Mon, 09 Oct 2017 15:28:03 +1100
Message-ID: <87d15xymgc.fsf@notabene.neil.brown.name>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com> <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com> <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk> <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com> <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk> <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com> <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk> <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org> <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com> <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com> <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org> <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com> <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaP
 FTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com> <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com> <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com> <
 CADg2FGY97NYLYPk9W3XL_WgbVdCvOWamF6gjbw9zqwPON5h2og@mail.gmail.com> <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Oct 08 2017, Curt wrote:

>> You get this because sdf1 says:
>>
>>    Raid Devices : 7
>>   Total Devices : 7
>>
>> while sda1 (for example) says:
>>
>>    Raid Devices : 8
>>   Total Devices : 6
>> Preferred Minor : 127
>>
>>   Reshape pos'n : 3799296 (3.62 GiB 3.89 GB)
>>   Delta Devices : 1 (7->8)
>>
>> mdadm cannot reconcile this difference.
>>
>> It appears that sdf1 was never involved in any reshape.
>> So you need to revert the reshape before trying to include sdf1 into the
>> array.  Clearly you need at least 6 devices that were involved in
>> the reshape to do this.
>> I haven't been following closely ... do you have 6 such devices?
>>
>> NeilBrown
>>
>
> Correct.  Which I thought was sorta the point, but could have
> completely misunderstood it, sdf was restored from a "faulty" drive
> that was out before the reshape.  Whether I have 6 devices depends on
> how picky things are.  I've got 5 that should be in sync, the 6th not,
> but it was involved in the reshape.
>
> Short version, is I shot myself in the foot on this one. Reshape never
> got anywhere, but need to try to revert and save what data I can.

Hmmm... (goes back and looks at more of thread..)

Ahhh .. you had an array which was rebuilding two spares, and you
told it to start reshaping... Interesting.
Theoretically that should work.  Was it deliberate? (I cannot seem to
find the start of the thread).

Looking at the list of "current --examine output", it appears that
 /dev/sdg1
 /dev/sdd1
 /dev/sdc1
 /dev/sda1
 /dev/sde1

 /dev/sdb

are all valid devices with the same event counts.  They are the six that
you need.
To confirm that names haven't changed, you can:
  mdadm --examine  /dev/sdg1 /dev/sdd1 /dev/sdc1 /dev/sda1 /dev/sde1 \
  /dev/sdb | grep Events

and confirm all the numbers are the same.
Then do the same and grep for "this" and confirm all the Raid Disk
numbers are different.

Interesting that /dev/sdb is a whole device and the rest are partitions.
I assume you know about that and why it is.

What happens if you run the --assemble --update=revert-reshape command on
these 6 devices (without --force)??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlna+tMACgkQOeye3VZi
gbnOPQ/+Imt3p0oBuqj7WSHHciYS0nBgnPNGE2anw1qe74AHUrvxtarqBYcWE+M5
yC1h/WTW5y8NgskTgKHdUdighwN/UGF2PIY0nTs6cyJ6QamnYSmvVwKepOgyOMKt
epwWdhoebFz2NARWjNWSP0KgbMQ/9KU+6E7aYwqY93Vr5lXBEVvFO2bb8MfGrDr3
sUt6aPEAw7HrA0dvE7xLbNvS5dp5v5pI2Gsc0EYUMC69cvcDBqqBOP4T9LhQFdQ9
r9v4INe4N5ew1+Nt9edyaBsaEpf9DXjoK4zHnRFDUazinsXUFKIKcRpv8rOc06Kx
fZ3eZULgeaM6R7iV0eTYs38w9cE4wh4AS4wQISsR4AawL6MPilhknwu71PsEjN/U
xhUVyFTEbCxza/0pCgptOJlyXYgCTDOi5Um/tXVoCPu9BpH1KaItALuSMm0kw2TI
5uYu/sQj8bAiw1XJecewktRiDueHenK1tgLmmkZnh8wVxTKLqjzE/ujBUtWsxBGM
iNfqbYRWe1cYFzyAknXaB4kcG97dELATYyT9l54BU/EdEUoXfu7cHC4+kvtuPrYX
bkTelCJcFsa5d9uxdrAi70IuxKXvJmEWB6szx75I7YX1wm2ROXo5A3p0/5K3YGuk
zMW/OAp0WFTLBYeYzpbfaJN4vf7QBO+0hm9N+7sycdUEvIBctc0=
=ttRO
-----END PGP SIGNATURE-----
--=-=-=--
