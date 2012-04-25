From: Alex <creamyfish@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Wed, 25 Apr 2012 10:45:49 +0800
Message-ID: <CAMqP1GV_gZ7J4u1qt21yHwKoxwxy41f0kYg1YLPN8TfPCiaNtQ@mail.gmail.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
	<4F91142C.80305@hardwarefreak.com>
	<CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
	<4F97515D.8000406@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F97515D.8000406@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can see that you are trying very hard to fit a new picture into an ol=
d
frame. But with new technology there is always new possibilities. For
example, what I am thinking is: with the new laser write head, it doesn=
't
necessarily require the head to stay very close  to the platter since l=
aser
doesn't fade away with longer distance, which may enable a design that
the head turns(the platter doesn't have to be round) instead of spinnin=
g
 the platter; hence the "Data rate is a product of [density * RPM]"
statement falls apart. What is more, if the cost is justified, one may
even design a disk with multiple write heads to increase the bandwidth
since now we are free from the fluid mechanic interaction between the
head and the platter. Both of these may lead to independent increase
of data rate. I am having these thoughts because it's been an endless
effort trying to remove the mechanical parts from a HDD(SSD was an
attempt). With Ostler's new technology, this once again becomes
possible. It is wise to think outside the box at this time.

Cheers,
Alex

On Wed, Apr 25, 2012 at 9:20 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> On 4/23/2012 10:26 AM, Alex wrote:
>
>> It looks like to me Ostler's team's work does independently lead to =
an
>> increase in areal density and writing speed, and
>> there is not fixed relation between these two.
>
> That's because you've not taken 60 seconds to actually think about th=
is
> logically.
>
> Data rate is a product of [density * RPM]. =A0To increase data rate w=
e
> must increase one of these two. =A0Making the R/W head simply punch h=
oles
> faster won't increase data rate. =A0It will allow simply allow us to
> increase the other two without the R/W head becoming a bottleneck.
>
> Designing the R/W head to punch bits 1000x faster cannot independentl=
y
> increase throughput. =A0The platter must either have more bits per in=
ch or
> they must spin faster. =A0Period.
>
> Thus, the only way this laser R/W head will increase throughput is if=
 it
> simultaneously writes more bits per inch, which increases density,
> allowing. =A0So again, unless it increases density, the faster punchi=
ng
> speed doesn't increase throughput.
>
> --
> Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
