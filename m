From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: MD performance options: More =?iso-8859-1?Q?CPU=92s?= or more
 =?iso-8859-1?Q?Hz=92s=3F?=
Date: Wed, 04 Nov 2009 16:01:30 +0100
Message-ID: <87iqdqcp11.fsf@frosties.localdomain>
References: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10911040149q165edf1s94a86f179f9af9fc@mail.gmail.com> (mark
	delfman's message of "Wed, 4 Nov 2009 09:49:33 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman <markdelfman@googlemail.com> writes:

> Hi... I am wondering if anyone can offer some advice on MD performanc=
e
> related to CPU (speed and or cores).  The basic question (probably to=
o
> basic) is =93for more MD performance are you better with more cpu=92s=
 or a
> faster single cpu=94.  (in an ideal world we would have lots of very
> fast CPUs, but given we never have enough money....).

In older kernels the raid6 code was single threaded. There a single
faster cpu would give you more speed as all other cores would remain
totaly idle.

But the raid code has been moving to use multiple cores and hardware
acceleration when available for a while now. And since raid operations
can be distributed among cores nicely (e.g. each core gets one stripe)
more cores will be better than a single faster core. The combined
speed of many cores will usualy be more than a faster single core has
at a smaller price.

> Is there any grounding to the following logic:
>
> Presuming that a RAID0 will deliver 1.5GBsec and a RAID6 circa
> 700MBsec, I am guessing there are many complex reasons for the
> difference, but one of the more obvious being the need for the CPU to
> perform all the necessary R6 overheads.

Back with ~2.6.18 I could only get 180MB/s out of a raid6 because the
cpu would hit 100% used then. Splitting the raid6 into 3 raid6 (same
config, 1/3 the size each) made it use 3 cores at trice the overall
speed. But the raid driver has improved since then.

> If we look at a single RAID 6 configuration, then I am guessing if we
> increase the speed of the CPU from eg 2.0GHz to 2.8GHz (quad core
> xeon) then the RAID6 calculations would be faster?  Would other
> overheads also be faster and if so is there any know relationship
> between CPU Hz and MD performance (maybe even rough rule of thumb eg
> double cpu Hz and increase R6 performance by 20% etc)

Unless you hit other bottlenecks double the cpu Hz shoud give double
R6 performance. But I doubt you ever get that because you always hit
other bottlenecks. For example if the 2.0GHz runs R6 at 100% of the
ram speed then 2.8GHz will give 0% improvement.

> If however I start to think of multiple RAID6 configurations maybe vi=
a
> iSCSI etc... then I wonder if MD would be better served with more CPU=
s
> instead... for example 2 x Quad core 2.0GHz xeons instead of 1 x 2.8.
>   This theory is dependent on linux / md effectively parallel
> processing the overheads and I have no knowledge in this area... henc=
e
> the question.
>
> Any thoughts anyone?

Consider all factors, esspecially ram speed and bus/controler speed.
But generally the sum of all cores is more relevant than each core for
throughput.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
