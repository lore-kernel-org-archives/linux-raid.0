From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Fri, 27 Apr 2012 23:15:15 +0800
Message-ID: <CAAYorBLn9GyeZdHvp9ZcFZtoZtFpsqLk4rRa-bgu4jQ1VxUeGQ@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
	<CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
	<4F97515D.8000406@hardwarefreak.com>
	<CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
	<CAAYorBK4NYA3Gky1oh9yftRRbxWad6SE+D+Lr2SJ+5kfKZ-A2w@mail.gmail.com>
	<CAMqP1GUxt27OE2vqeABE26o5-erM6Z-BtPzC7J0NDeP59_57NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GUxt27OE2vqeABE26o5-erM6Z-BtPzC7J0NDeP59_57NQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/12, Alex <creamyfish@gmail.com> wrote:

> Yes if we can't make reading as fast as writing. But in general having a
> disk with write speed faster than read speed might still be an interesting
> choice for applications with a lot of disk write.

Pardon me if I might be missing something here. The proposition here
is that with the laser writing technique, we can increase the data
rate by having new type write heads which swivel instead of the
traditional moving head over rotating platter isn't it?

But since we cannot do the same for reading, we are stuck with the
traditional head/platter mechanism. How would the write speed increase
independently of the RPM x density general case?  It seems to me that
we cannot expect a breakthrough in write/read without a fundamental
improvement in the read function.

It's like we have two person in a car, one collecting payment while
one gives out goods. Now we increase the speed of the guy giving out
goods (writing) but the total number units moved will still be the
same because the car can't go any faster than the guy collecting
payment (reading). Only difference is that the write head has more
idle time between bits?

Unless we are suggesting a hybrid system which has an independent
swiveling write head and a traditional read head? But that sounds
overly complicated and unlikely to work.
