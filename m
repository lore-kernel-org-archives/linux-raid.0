From: Alex <creamyfish@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Thu, 26 Apr 2012 12:24:26 +0800
Message-ID: <CAMqP1GUj07A8Rgf+Km5k7ZbgyS6Ucr0ipG+DvMruEzcP3EuA-w@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
	<CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
	<4F97515D.8000406@hardwarefreak.com>
	<CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
	<CAAYorBK4NYA3Gky1oh9yftRRbxWad6SE+D+Lr2SJ+5kfKZ-A2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAYorBK4NYA3Gky1oh9yftRRbxWad6SE+D+Lr2SJ+5kfKZ-A2w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 26, 2012 at 12:59 AM, Emmanuel Noobadmin
<centos.admin@gmail.com> wrote:
> On 4/25/12, Alex <creamyfish@gmail.com> wrote:
>> I can see that you are trying very hard to fit a new picture into an=
 old
>> frame. But with new technology there is always new possibilities. Fo=
r
>> example, what I am thinking is: with the new laser write head, it do=
esn't
>> necessarily require the head to stay very close =A0to the platter si=
nce laser
>> doesn't fade away with longer distance, which may enable a design th=
at
>
> The strength of the laser will fall as the distance to the media
> increases, wouldn't it?
>
>> the head turns(the platter doesn't have to be round) instead of spin=
ning
>> =A0the platter; hence the "Data rate is a product of [density * RPM]=
"
>> statement falls apart. What is more, if the cost is justified, one m=
ay
>> even design a disk with multiple write heads to increase the bandwid=
th
>> since now we are free from the fluid mechanic interaction between th=
e
>> head and the platter. Both of these may lead to independent increase
>> of data rate. I am having these thoughts because it's been an endles=
s
>
> But Ostler's technique only increases the write speed and admits in a
> Wired.com article there is still no faster/other way to read the data=
=2E
> So we would still be stuck with the rotating disk and the magnetic
> reading heads until some other breakthrough happens.
>
> Going back into the context of parity RAID rebuild, we would still be
> bottlenecked on the write side wouldn't we since bits on the
> replacement drive can only be calculated after reading the rest of th=
e
> drives.

I also want to add that sluggishness of read operations can always be
alleviated by prefetching and masked by the speed of a cache.

Cheers,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
