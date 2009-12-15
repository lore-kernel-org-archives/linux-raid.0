From: "Majed B." <majedb@gmail.com>
Subject: Re: Spurious HD convictions
Date: Tue, 15 Dec 2009 11:47:04 +0300
Message-ID: <70ed7c3e0912150047v1d3284dbk35282f8916d0ba4f@mail.gmail.com>
References: <70ed7c3e0912141206p65005aeegf663183c946dec7b@mail.gmail.com>
	<4b271970.5e44f10a.484f.ffffdd07SMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4b271970.5e44f10a.484f.ffffdd07SMTPIN_ADDED@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As far as I know, the numbers in between define the queue depth of
commands sent to the disks.

It's a matter of whether you want the disk(s) firmware to manage
sorting & executing the commands (when the queue is > 1) or not. In
all cases, as far as I know, the kernel does the sorting before
sending the commands to the disk(s). So if you notice better
performance (when the array is stable) with the queue=3D1, then keep it
that way.

On Tue, Dec 15, 2009 at 8:06 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> Hi Leslie,
>>
>> I was wondering if you were able to stop the weird behavior with you=
r
>> disks.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0It seems to have done so, yes. =C2=A0I've =
looked around the web trying to
> find some additional info, but I've come up empty handed. =C2=A0Perha=
ps someone
> here can answer at least one of my questions? =C2=A0I know that putti=
ng a value
> of 32 into /sys/block/<driveID>/device/queue_depth fully enables NCQ,=
 and
> putting a value of 1 there disables NCQ. =C2=A0What do all the number=
s in between
> do?
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
