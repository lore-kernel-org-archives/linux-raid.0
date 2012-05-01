From: Alex <creamyfish@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Wed, 2 May 2012 00:38:55 +0800
Message-ID: <CAMqP1GWAkk1ShGGxJnx51+tbiniUk-o5YGVPAdCMdKdfUqXOeg@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
	<CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
	<4F97515D.8000406@hardwarefreak.com>
	<CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
	<CAAYorBK4NYA3Gky1oh9yftRRbxWad6SE+D+Lr2SJ+5kfKZ-A2w@mail.gmail.com>
	<CAMqP1GUxt27OE2vqeABE26o5-erM6Z-BtPzC7J0NDeP59_57NQ@mail.gmail.com>
	<CAAYorBLn9GyeZdHvp9ZcFZtoZtFpsqLk4rRa-bgu4jQ1VxUeGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAYorBLn9GyeZdHvp9ZcFZtoZtFpsqLk4rRa-bgu4jQ1VxUeGQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Emmanuel,

The real reason of a HDD performance bottleneck is the mechanical
movements inside it,
RPM * density is just a reflection of that. It is always more
desirable to try to remove the
mechanical parts in it instead of playing with RPM * density when we
try to optimize it for
better performance.

There are three types of mechanical movements and interaction inside a =
HDD:
1. The spinning of the platter (the one we want to eliminate most)
2. The movement of the actuator arm to position the read/write head on
the right track (relatively tamed)
3. The fluid dynamic interaction between the platter and the
read/write head through a thin layer of fast
moving air

With Ostler' technology, 3 is no longer necessary for the write head,
and the platter is no longer tightly
coupled with the write head as it was. This might lead to elimination
of the spinning of the platter and
my ideas were just some premature attempts.

If this were to succeed, we still need to develop a new way to read
the data from the now non-spinning
storage medium. I haven't even got a premature idea for it yet, but
one observation is this: since we
can always use a cache to increase access response time, the new
reading method may not need to
be 1000X faster than the original one to be comparable to the new
writing method.

=46inally we probably need a new way to coordinate the read and write
operations of the new disk since
the new read head and write head are likely to be separate and the
current simply scheme will not
work any more.

This doesn't sound like a plan we can work out via interchange of
e-mail message, so I really want to
stop right here. I myself will definitely follow Ostler's work and see
how things go. So good luck!

Cheers,
Alex

On Fri, Apr 27, 2012 at 11:15 PM, Emmanuel Noobadmin
<centos.admin@gmail.com> wrote:
> On 4/26/12, Alex <creamyfish@gmail.com> wrote:
>
>> Yes if we can't make reading as fast as writing. But in general havi=
ng a
>> disk with write speed faster than read speed might still be an inter=
esting
>> choice for applications with a lot of disk write.
>
> Pardon me if I might be missing something here. The proposition here
> is that with the laser writing technique, we can increase the data
> rate by having new type write heads which swivel instead of the
> traditional moving head over rotating platter isn't it?
>
> But since we cannot do the same for reading, we are stuck with the
> traditional head/platter mechanism. How would the write speed increas=
e
> independently of the RPM x density general case? =A0It seems to me th=
at
> we cannot expect a breakthrough in write/read without a fundamental
> improvement in the read function.
>
> It's like we have two person in a car, one collecting payment while
> one gives out goods. Now we increase the speed of the guy giving out
> goods (writing) but the total number units moved will still be the
> same because the car can't go any faster than the guy collecting
> payment (reading). Only difference is that the write head has more
> idle time between bits?
>
> Unless we are suggesting a hybrid system which has an independent
> swiveling write head and a traditional read head? But that sounds
> overly complicated and unlikely to work.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
