From: Al Boldi <a1426z@gawab.com>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Mon, 26 Feb 2007 00:07:10 +0300
Message-ID: <200702260007.10205.a1426z@gawab.com>
References: <45D89FF5.3020303@sauce.co.nz> <200702252057.22963.a1426z@gawab.com> <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>  	- disks are very complicated, so their failure rates are a
>  	combination of conditional failure rates of many components.
>  	to take a fully reductionist approach would require knowing
>  	how each of ~1k parts responds to age, wear, temp, handling, etc.
>  	and none of those can be assumed to be independent.  those are the
>  	"real reasons", but most can't be measured directly outside a lab
>  	and the number of combinatorial interactions is huge.

It seems to me that the biggest problem are the 7.2k+ rpm platters 
themselves, especially with those heads flying closely on top of them.  So, 
we can probably forget the rest of the ~1k non-moving parts, as they have 
proven to be pretty reliable, most of the time.

>  	- factorial analysis of the data.  temperature is a good
>  	example, because both low and high temperature affect AFR,
>  	and in ways that interact with age and/or utilization.  this
>  	is a common issue in medical studies, which are strikingly
>  	similar in design (outcome is subject or disk dies...)  there
>  	is a well-established body of practice for factorial analysis.

Agreed.  We definitely need more sensors.

>  	- recognition that the relative results are actually quite good,
>  	even if the absolute results are not amazing.  for instance,
>  	assume we have 1k drives, and a 10% overall failure rate.  using
>  	all SMART but temp detects 64 of the 100 failures and misses 36.
>  	essentially, the failure rate is now .036.  I'm guessing that if
>  	utilization and temperature were included, the rate would be much
>  	lower.  feedback from active testing (especially scrubbing)
>  	and performance under the normal workload would also help.

Are you saying, you are content with pre-mature disk failure, as long as 
there is a smart warning sign?

If so, then I don't think that is enough.

I think the sensors should trigger some kind of shutdown mechanism as a 
protective measure, when some threshold is reached.  Just like the 
protective measure you see for CPUs to prevent meltdown.

Thanks!

--
Al

