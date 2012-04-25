From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Tue, 24 Apr 2012 20:20:29 -0500
Message-ID: <4F97515D.8000406@hardwarefreak.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F91142C.80305@hardwarefreak.com> <CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMqP1GWR2-_a=+FTJOsjK9W48zCUVd3smsF63x=+-PimBPzAXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <creamyfish@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/23/2012 10:26 AM, Alex wrote:

> It looks like to me Ostler's team's work does independently lead to an
> increase in areal density and writing speed, and
> there is not fixed relation between these two.

That's because you've not taken 60 seconds to actually think about this
logically.

Data rate is a product of [density * RPM].  To increase data rate we
must increase one of these two.  Making the R/W head simply punch holes
faster won't increase data rate.  It will allow simply allow us to
increase the other two without the R/W head becoming a bottleneck.

Designing the R/W head to punch bits 1000x faster cannot independently
increase throughput.  The platter must either have more bits per inch or
they must spin faster.  Period.

Thus, the only way this laser R/W head will increase throughput is if it
simultaneously writes more bits per inch, which increases density,
allowing.  So again, unless it increases density, the faster punching
speed doesn't increase throughput.

-- 
Stan
