From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 09:37:44 +0300
Message-ID: <70ed7c3e0912152237v3b7bf25cg54c70eb61101a60a@mail.gmail.com>
References: <50.42.04641.7E2782B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50.42.04641.7E2782B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you made sure that the value of
/proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200
MB/s) along with /proc/sys/dev/raid/speed_limit_max?

I interrupted an array resyncing a couple of times without issues.
Only one time I interrupted an array during growth process and I had
an old version of mdadm (2.6.3) which didn't support resuming that. I
think Neil told me that 2.6.9 is the minimum requirement to resume.

On Wed, Dec 16, 2009 at 8:40 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I just purchased 2 new drives to add to a =
RAID5 and RAID6 array,
> respectively. =C2=A0I have already added the 8th drive to the RAID5 a=
rray and
> begun the growth. =C2=A0The critical phase has been completed. =C2=A0=
=46or safety, I
> umounted the array before I started the growth processs. =C2=A0At the=
 rate the
> data is being read and written to the drives, the resync is going to =
take a
> very long time - about 4 days. =C2=A0I'd rather not have the array do=
wn that
> long, unless it's really necessary. =C2=A0Is there any greater amount=
 of jeopardy
> to a RAID5 array during the growth (once the critical phase is comple=
te)
> than under ordinary circumstances? =C2=A0That is to say, will losing =
a drive
> during the resync wreak havoc on the data?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Once I am done upgrading the RAID5 array, =
I'm going to add a drive
> to the RAID6 array. =C2=A0'Same question, there. =C2=A0Will the loss =
of 2 drives
> during the resync cause a loss of data?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
