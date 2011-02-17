From: David Brown <david@westcontrol.com>
Subject: Re: high throughput storage server?
Date: Thu, 17 Feb 2011 11:39:10 +0100
Message-ID: <ijitt7$giq$1@dough.gmane.org>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com> <4D5A7198.7060607@hardwarefreak.com> <ijdvmn$4ff$1@dough.gmane.org> <4D5C5EAA.3020208@hardwarefreak.com> <ijhpv7$o84$1@dough.gmane.org> <4D5C6F8E.9020802@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C6F8E.9020802@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/02/2011 01:45, Stan Hoeppner wrote:
> David Brown put forth on 2/16/2011 6:26 PM:
>
>> On 17/02/11 00:32, Stan Hoeppner wrote:
>
>>> RAID level space/cost efficiency from a TCO standpoint is largely irrelevant
>>> today due to the low price of mech drives.  Using the SATABeast as an example,
>>> the cost per TB of a 20TB RAID 10 is roughly $1600/TB and a 20TB RAID 6 is about
>>> $1200/TB.  Given all the advantages of RAID 10 over RAID 6 the 33% premium is
>>> more than worth it.
>
>> I don't think it is fair to give general rules like that.  In this particular
>
> The IT press does it every day.  CTOs read those articles.  In many cases it's
> their primary source of information.  Speak in terms CTOs (i.e. those holding
> the purse) understand.
>

I work at a small company - I get to read the articles, make the 
recommendations, and build the servers.  So I can put more emphasis on 
what I think is technically the best solution for us, rather than what 
sounds good in the press.  Of course, the other side of the coin is that 
being a small company with modest server needs, I don't get to play with 
20 TB raid systems!

>> case, that might be how the sums work out.  But in other cases, using RAID 10
>> instead of RAID 6 might mean stepping up in chassis or controller size and
>> costs.  Also remember that RAID 10 is not better than RAID 6 in every way - a
>> RAID 6 array will survive any two failed drives, while with RAID 10 an unlucky
>> pairing of failed drives will bring down the whole raid.  Different applications
>> require different balances here.
>
> I'm not sure about being "fair" but it directly relates to the original question
> that started this thread.  The OP wanted performance and space with a preference
> for performance.  This demonstrates he can get the performance for a ~33% cost
> premium.  He didn't mention a budget limit, only that most vendor figures were
> too high.
>

I agree that RAID 10 sounds like a match for the OP.  All I am saying is 
that it is not necessarily the best choice in general, and not just 
because of the initial purchase price.

> Also, you're repeating points I've made in this (and other) threads back to me.
>   Try to keep up David. ;)
>

I'm doing my best!  I believe I've got a fair understanding of various 
sorts of RAID systems, but I am totally missing real-world experience of 
anything more advanced than a four disk setup.  Bigger raid setups is 
only a hobby interest for me at the moment, so I'm learning as I go 
here.  And you write such a lot here that it's hard for an amateur to 
take it all in :-)

