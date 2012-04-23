From: Alex <creamyfish@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Mon, 23 Apr 2012 23:26:38 +0800
Message-ID: <CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F91142C.80305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

Sorry for not replying earlier. My background is not exactly Physics,
so I talked
to Thomas Ostler for a clarification. Here is what I did:

I first ask him how exactly does his model possibly increase areal
density, and I am
quoting his answer:

"thank you for your inquiry. The main reason for our statement that
areal density could be improved is down to a prediction made by the
model we used in this paper to predict this phenomena. The model
results show that the effect occurs with very small system sizes (on
the same time-scale), thus potentially the density could be improved.
However, the model is parameterised on experimental observations of
bulk system so it is not clear that the physics would be the same when
we decrease the size of the bits, this is something that we are
looking at studying in York using different methods over the next few
years. Obviously any increase in writing speed needs to have an
improvement in reading speed to see overall performance, one of the
many engineering problems to be overcome."

Then I ask him to clarify the following two things for me:

1. We also want to make sure what we got about your model improving
writing speed is correct: writing speed could be increased because
writing a bit could be achieved on a timescale of picoseconds rather
than the current nanoseconds and is for this reason only

2. In particular, increase of areal density doesn't lead to increase
of writing speed.

And I am quoting his answers again:

Answer for 1:
"yes, indeed we showed that the process is complete (apart from the
longer time cooling) after a couple of pico seconds. We also verified
the time-scale experimentally by measuring what happens as a function
of time to the Fe and Gd sublattices (though this experiment was done
in an applied field), see Radu et al. Nature 472, 205-208 (2011)."

Answer for 2:
"yes that is correct, the simulations show that the time-scale for
switching is not affected by the system size (within reasonable
limits). The features of this material that are physically important
for switching is something that we wish to study further to allow us
to gain more insight into the mechanism behind this switching."

It looks like to me Ostler's team's work does independently lead to an
increase in areal density and writing speed, and
there is not fixed relation between these two. I am still evaluating
what this means, but my first feeling is the whole
thing is still not very mature and there definitely will be other
improvements in the future, so taking a ' wait and see'
stand point at this point may not necessarily be a bad idea.

On Fri, Apr 20, 2012 at 3:45 PM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 4/17/2012 1:11 AM, Alex wrote:
>> Thanks to Billy Crook who pointed out this is the right place for my=
 post.
>>
>> Adam Leventhal integrated triple-parity RAID into ZFS in 2009. The
>> necessity of triple-parity RAID is described in detail in Adam
>> Leventhal's article(http://cacm.acm.org/magazines/2010/1/55741-tripl=
e-parity-raid-and-beyond/fulltext).
>
> No mention of SSD.
>
>> al.(http://www.nature.com/ncomms/journal/v3/n2/full/ncomms1666.html)
>
> Pay wall. =A0No matter, as I'd already read of this research.
>
>> established a revolutionary way of writing magnetic substrate using =
a
>> heat pulse instead of a traditional magnetic field, which may increa=
se
>> data throughput on a hard disk by 1000 times in the future.
>
> Your statement is massively misleading. =A0The laser heating technolo=
gy
> doesn't independently increase throughput 1000x. =A0It will allow for
> increased throughput only via enabling greater aerial density. =A0Thu=
s the
> ratio of throughput to capacity stays the same. =A0Thus drive rebuild
> times will still increase dramatically.
>
Sorry

>> facilitate another triple-parity RAID algorithm
>
> CPU performance is increasing at a faster rate than any computer
> technology. =A0Thus, if you're going to even bother with introducing
> another parity RAID level, and the binary will run on host CPU cores,
> skip triple parity and go straight to quad parity, RAID-P4=99. =A0Mos=
t savvy
> folks doing RAID6 are using a 6+2 or 8+2 configuration as wide stripe
> parity arrays tend to be problematic. =A0They then stripe them to cre=
ate a
> RAID60, or concatenate them if they're even more savvy and use XFS.
>
> The most common JBOD chassis on the market today seems to be the 24x
> 2.5" drive layout. =A0This allows three 6+2 RAID6 arrays, losing 6 dr=
ives
> to parity leaving 18 drives of capacity. =A0With RAID-P4=99 =A0a wide=
r stripe
> array becomes more attractive for some applications. =A0Thus our 24 d=
rive
> JBOD could yield a 20+4 RAID-P4=99 with two drives more capacity than=
 the
> 6+2 RAID6 configuration. =A0If one wished to stick with narrower stri=
pes,
> we'd get two 8+4 RAID-P4=99 arrays and 16 drives total capacity, 2 le=
ss
> than the triple RAID6 setup, and still 4 drives more capacity than RA=
ID10.
>
> The really attractive option here for people who like parity RAID is =
the
> 20+4 possibility. =A0With a RAID-P4=99 array that can withstand up to=
 4
> drive failures, people will no longer be afraid of using wide stripes
> for applications that typically benefit, where RAID50/60 would have b=
een
> employed previously. =A0They also no longer have to worry about secon=
dary
> and/or tertiary drive failures during a rebuild.
>
> Yeah, definitely go straight to RAID-P4=99 and skip triple parity RAI=
D
> altogether. =A0You'll have to do it in 6-10 years anyway so may as we=
ll
> prevent the extra work. =A0And people could definitely benefit from
> RAID-P4=99 today.
>
> --
> Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
