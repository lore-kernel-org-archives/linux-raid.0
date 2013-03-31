From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Sun, 31 Mar 2013 10:56:56 -0700
Message-ID: <CAK2H+efkGPNGbhRAgg8HabUL4fsioDTL0uUkrx2rrKxxQ=ZXGQ@mail.gmail.com>
References: <16639206.20.1364400094382.JavaMail.root@zimbra>
	<51534450.8050905@hardwarefreak.com>
	<CAK2H+eczN+fqWJv0r6WTA871R__jrrybS9ObdZ9dx6mX+Z=HHw@mail.gmail.com>
	<51535252.2080105@hardwarefreak.com>
	<CAK2H+ecbcH-dqM6OAcip68-NkRf8w3eDC7ZCx0-QGteKURXvpw@mail.gmail.com>
	<51536DDD.5010800@hardwarefreak.com>
	<CAK2H+edehoVSrEbD_Hh_rE79V0MvgHPcrxNJiOh7_suhGdAXSA@mail.gmail.com>
	<51585CB9.5020208@hardwarefreak.com>
	<CAK2H+efkcjobknaWBupLQpxPkM+m_9JMDGwY1sH9UWw4tc=Czw@mail.gmail.com>
	<51587548.3060306@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51587548.3060306@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 31, 2013 at 10:41 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 3/31/2013 12:15 PM, Mark Knecht wrote:
<SNIP>
>>
>> Hopefully that gives you enough info to suggest a direction.
>
> These applications append small data slowly over a long period of time,
> which usually means fragmentation.  Thus there's not much to optimize at
> the chunk/stripe level, other than keeping chunk size small to spread
> random reads over all platters.  You currently have a 16KB chunk, IIRC,
> which is about as good as you'll get for this workload.  Given your
> applications' low write throughput chunk/strip really doesn't matter.
>
> --
> Stan
>

OK, I cannot argue with your conclusions and will stick with 16K for now.

Presumably if any improvement is to be made here its getting
everything onto a single partition instead of multiple RAIDs on the
same drives which then reduces the physical overhead (moving heads to
different partitions) and allows the md software to do the heavy
lifting?

Thanks,
Mark
