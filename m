From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Wed, 16 Feb 2011 18:45:02 -0600
Message-ID: <4D5C6F8E.9020802@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com> <ijdvmn$4ff$1@dough.gmane.org> <4D5C5EAA.3020208@hardwarefreak.com> <ijhpv7$o84$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijhpv7$o84$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 2/16/2011 6:26 PM:

> On 17/02/11 00:32, Stan Hoeppner wrote:

>> RAID level space/cost efficiency from a TCO standpoint is largely irrelevant
>> today due to the low price of mech drives.  Using the SATABeast as an example,
>> the cost per TB of a 20TB RAID 10 is roughly $1600/TB and a 20TB RAID 6 is about
>> $1200/TB.  Given all the advantages of RAID 10 over RAID 6 the 33% premium is
>> more than worth it.

> I don't think it is fair to give general rules like that.  In this particular

The IT press does it every day.  CTOs read those articles.  In many cases it's
their primary source of information.  Speak in terms CTOs (i.e. those holding
the purse) understand.

> case, that might be how the sums work out.  But in other cases, using RAID 10
> instead of RAID 6 might mean stepping up in chassis or controller size and
> costs.  Also remember that RAID 10 is not better than RAID 6 in every way - a
> RAID 6 array will survive any two failed drives, while with RAID 10 an unlucky
> pairing of failed drives will bring down the whole raid.  Different applications
> require different balances here.

I'm not sure about being "fair" but it directly relates to the original question
that started this thread.  The OP wanted performance and space with a preference
for performance.  This demonstrates he can get the performance for a ~33% cost
premium.  He didn't mention a budget limit, only that most vendor figures were
too high.

Also, you're repeating points I've made in this (and other) threads back to me.
 Try to keep up David. ;)

-- 
Stan
