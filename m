From: =?UTF-8?Q?Gar=C3=B0ar_Arnarsson?= <gardar@giraffi.net>
Subject: Re: raid6 array assembled from 11 drives and 2 spares - not enough to
 start the array
Date: Sat, 7 Sep 2013 23:49:21 +0000
Message-ID: <CAH-e9vJGPOWm2YqGk54CRtGVW1pYcxbU0xS9HaU74fR_q+Ecug@mail.gmail.com>
References: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vL7fUYSrd4J7+nej=xiqndgk3vim38Mu7+E-w37QX0Ebw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I seem to have been able to resolve this.

I tried force assembling the array with all the drives except for sda1
(the problematic device before) that way the array got assembled with
12 drives and one spare, enough so I could recover the array.

Still would want to know what might have caused these problems for the
first place, but I'm glad it seems to be working ok for now.

On Sat, Sep 7, 2013 at 10:56 PM, Gar=C3=B0ar Arnarsson <gardar@giraffi.=
net> wrote:
> I am unable to start my raid6 array.
>
> At first I got sda1 missing so I went ahead and re-added it and was
> able to start the array. Then few minutes later I got 3 failed drives=
=2E
>
> I shut down my server, checked all the sata and power cables and
> booted up again.
> The array did not start automatically so I tried to force assemble it=
=2E
>
> sudo mdadm --assemble --verbose --force /dev/md1 /dev/sda1 /dev/sdb1
> /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
> /dev/sdj1 /dev/sdk1 /dev/sdm1 /dev/sdp1 /dev/sdq1
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sda1 is identified as a member of /dev/md1, slot 15.
> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 8.
> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 3.
> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 6.
> mdadm: /dev/sdf1 is identified as a member of /dev/md1, slot 9.
> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 10.
> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 7.
> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdm1 is identified as a member of /dev/md1, slot 14.
> mdadm: /dev/sdp1 is identified as a member of /dev/md1, slot 2.
> mdadm: /dev/sdq1 is identified as a member of /dev/md1, slot 4.
> mdadm: ignoring /dev/sdq1 as it reports /dev/sda1 as failed
> mdadm: added /dev/sdc1 to /dev/md1 as 1
> mdadm: added /dev/sdp1 to /dev/md1 as 2
> mdadm: added /dev/sdd1 to /dev/md1 as 3
> mdadm: no uptodate device for slot 4 of /dev/md1
> mdadm: added /dev/sdk1 to /dev/md1 as 5
> mdadm: added /dev/sde1 to /dev/md1 as 6
> mdadm: added /dev/sdj1 to /dev/md1 as 7
> mdadm: added /dev/sdb1 to /dev/md1 as 8
> mdadm: added /dev/sdf1 to /dev/md1 as 9
> mdadm: added /dev/sdg1 to /dev/md1 as 10
> mdadm: added /dev/sdi1 to /dev/md1 as 11
> mdadm: no uptodate device for slot 12 of /dev/md1
> mdadm: no uptodate device for slot 13 of /dev/md1
> mdadm: added /dev/sdm1 to /dev/md1 as 14
> mdadm: added /dev/sda1 to /dev/md1 as 15
> mdadm: added /dev/sdh1 to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 11 drives and 2 spares - not enough to
> start the array.
>
> Any ideas what could have gone wrong and how I can possibly start the
> array again?



--=20
Gar=C3=B0ar Arnarsson
kerfisstj=C3=B3ri Giraffi sf.
gardar@giraffi.net
http://gardar.giraffi.net
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
