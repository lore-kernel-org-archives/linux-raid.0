From: "Majed B." <majedb@gmail.com>
Subject: Re: Help - Urgent!!!
Date: Sun, 15 Nov 2009 03:05:28 +0300
Message-ID: <70ed7c3e0911141605k42b46dbbo29988b74ab6bf676@mail.gmail.com>
References: <19197.1188.481294.873723@notabene.brown> <20091114214504754.VURJ5263@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091114214504754.VURJ5263@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Congratulations :D

Out of curiosity, how did you fix the homehost issue?

On Sun, Nov 15, 2009 at 12:45 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
>> > =C2=A0 =C2=A0 Should I stop the arraya nd re-assemble it with -vvv=
?
>> >
>> > =C2=A0 =C2=A0 Also, what about my question about the bitmap? =C2=A0=
Should I delete it,
>> despite
>> > the fact mdadm says there isn't one, or should I attempt to add it
>> again, or
>> > should I wait until I do the checkarrray?
>> >
>>
>> There is nothing to delete. =C2=A0Just try to add it again.
>> Though I would really like to know why it hangs. =C2=A0If that happe=
ns
>> again, see if alt-sysrq-T shows anything useful.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, it hasn't hung again, but now that I=
 can catch my breath I can
> provide a little detail. =C2=A0As I mentioned before, the original ha=
ng occurred
> when I first issued:
>
> `mdadm -G /dev/md0 -b internal --bitmap-chunk=3D65535`
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Mdadm complained about the bitmap chunk be=
ing an incorrect size. =C2=A0I
> don't know if it actually created a bitmap anyway using the default s=
ize, or
> what, but I assumed the error meant the bitmap was not created. =C2=A0=
Going on
> this assumption, I immediately issued the command again, changing onl=
y the
> bitmap chunk size:
>
> `mdadm -G /dev/md0 -b internal --bitmap-chunk=3D65536`
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0That's when it hung. =C2=A0I tried stoppin=
g the array, but I couldn't
> umount the file system because it was dirty. =C2=A0Any commands to md=
adm - even
> informational ones and even
>
> `cat /proc/mdadm`
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0would cause the xterm to hang. =C2=A0Even =
a shutdown would not work. =C2=A0I
> had to shut down =C2=A0the server with the power switch.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0When the system booted, mdadm would not as=
semble the array. =C2=A0I think
> Neil has figured out why. =C2=A0Subsequent attempts to assemble the a=
rray also
> failed, at least in part because /dev/md0 had been created without th=
e array
> being active. =C2=A0I deleted /dev/md0, but subsequent failed assembl=
y attempts
> again created the file. =C2=A0Finally I deleted the file once again a=
nd then
> assembled using
>
> `mdadm -A /dev/sd[a-j]`
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0and it worked, although the array was mark=
ed as dirty, and the first
> attempt to access it caused a resync. =C2=A0When the resync was done,=
 I fixed the
> "homehost" issue Neil had spotted and corrected /etc/mdadm/mdadm.conf=
 to
> show all 10 drives. =C2=A0Finally, I added back the bitmap, and now e=
verything
> seems fine. =C2=A0I rebooted the server, and it comes up with all 10 =
drives in an
> assembled array with an internal bitmap.
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
