From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Thu, 26 Apr 2012 00:59:32 +0800
Message-ID: <CAAYorBK4NYA3Gky1oh9yftRRbxWad6SE+D+Lr2SJ+5kfKZ-A2w@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
	<CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
	<4F97515D.8000406@hardwarefreak.com>
	<CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/25/12, Alex <creamyfish@gmail.com> wrote:
> I can see that you are trying very hard to fit a new picture into an old
> frame. But with new technology there is always new possibilities. For
> example, what I am thinking is: with the new laser write head, it doesn't
> necessarily require the head to stay very close  to the platter since laser
> doesn't fade away with longer distance, which may enable a design that

The strength of the laser will fall as the distance to the media
increases, wouldn't it?

> the head turns(the platter doesn't have to be round) instead of spinning
>  the platter; hence the "Data rate is a product of [density * RPM]"
> statement falls apart. What is more, if the cost is justified, one may
> even design a disk with multiple write heads to increase the bandwidth
> since now we are free from the fluid mechanic interaction between the
> head and the platter. Both of these may lead to independent increase
> of data rate. I am having these thoughts because it's been an endless

But Ostler's technique only increases the write speed and admits in a
Wired.com article there is still no faster/other way to read the data.
So we would still be stuck with the rotating disk and the magnetic
reading heads until some other breakthrough happens.

Going back into the context of parity RAID rebuild, we would still be
bottlenecked on the write side wouldn't we since bits on the
replacement drive can only be calculated after reading the rest of the
drives.
