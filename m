From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: HBA Adaptor advice
Date: Sat, 21 May 2011 12:37:12 -0500
Message-ID: <38.4D.17273.348F7DD4@cdptpa-omtalb.mail.rr.com>
References: <4DD7A80C.8050808@wildgooses.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD7A80C.8050808@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ed W' <lists@wildgooses.com>, 'Rudy Zijlstra' <rudy@grumpydevil.homelinux.org>
Cc: 'Stan Hoeppner' <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Ed W
> Sent: Saturday, May 21, 2011 6:55 AM
> To: Rudy Zijlstra
> Cc: Stan Hoeppner; linux-raid@vger.kernel.org
> Subject: Re: HBA Adaptor advice
> 
> Hi
> 
> > I understand your thinking. There is one big cost not mentioned in this
> > calculation though:
> > - what is the cost if the data is lost/corrupt?
> 
> I think it's fair to say that the loss of all your business data is the
> loss of your entire business?!

	If a single device failure results in the loss of all one's business
data, then one has done a completely incompetent job of building a data
system.  In a properly designed system, the question is how much time and
effort will be spent over the life of the system in recovering data, or more
properly the cost of those resources, vs. the capital outlay for more
expensive hardware.  If any loss of productivity for the company as a whole
is involved with a hardware failure, then that should be taken into account,
as well.

> That said if you are Skype you don't spend 8.5 billion on raid cards,
> instead you choose a layered approach to availability which normally
> trades speed of restore time vs cost.
> 
> Eg one might specify raid 6, dual mirrored servers, backed up to some
> spare disks, blueray and some offsite storage service.  This would give
> resilliance to various types of disaster without spending the entire
> budget on a fancy raid card?
> 
> In fact if you go back to my question, the *entire* point is that I
> don't want the choice of card to be a point of failure, ie it's my
> specific point to purchase a card such that it can be swapped out for
> near any other card in the event of failure.
> 
> > compared to that cost, how relevant is the cost of a proper card?
> 
> See point above.  I don't get a strong feeling that a "proper card" is
> any more reliable and resiliant than a well chosen cheap card?  If that
> theory is correct then the ability to swap in another cheap card in the
> event of disaster is valuable and eliminates a point of failure for
> little cost?

	Well, yes, and no.  First of all, a "bad" card is often the result
of random factors unmitigated by any process.  The most expensive card on
Earth may have accidentally been exposed to ESD at some point in its
existence, for example.  OTOH, an inexpensive card may not necessarily be of
poor quality or design.  That said, I think there is a reasonable
expectation that a higher cost card should be the result of careful
engineering, high quality production methods, and extensive QC procedures,
all of which may be somewhat less likely of a lower cost card.

	I think on average one may expect lower failure rates on higher cost
devices.  The thing is, a statistical average has nothing to do with any
given failure.  A customer does not care if he is the only client who has
ever lost any data out of hundreds of clients.  He only cares that he has
lost his data.

> > I am getting the feeling of "penny wise, pound foolish"
> 
> I don't see that your logic leads here?
> 
> There is a clear definition of good/bad here.  The only acceptable
> performance is that all reads/writes are accurate and completed.  No
> data should be lost or corrupted.  Assuming that the market can be
> partitioned into good/bad cards based on the definition above, then if
> we select from only "good" cards, then price appears to only buy me
> performance, nothing else?

	I would say there are exceptions, but in general, yes.  More to the
point - and I think this is your point - relying upon quality hardware to
prevent failures is a much poorer approach than developing a strategy that
mitigates the impact of failures.  Put more simply, a proper backup strategy
is a must.

> So my question is how to choose from all the "good" cards, the best bang
> for buck.  I don't see any reason not to buy a cheaper card that
> performs well, subject to it being reliable and doesn't loose data.
> 
> Does someone have a claim that dataloss is actually on a curve and that
> more expensive cards corrupt less data and cheaper cards corrupt more
> data...  That doesn't seem to fit with expectation... (I expect either
> working cards that loose nothing, or bad cards that loose some data.
> Black and white)

	Well, yes, but there is a (fairly minor, I think) statistical
correlation between cost and failure rates.

> > Now that mind set, of course, describes many a business....
> 
> I think this is a silly line of argument.  All you can ever do is buy
> "insurance" against low probability events occuring.  Annoyingly the
> "insurance" in this scenario doesn't always pay out and so the question
> is how much to spend on orthogonal types of insurance to increase the
> chance of a payout in the case of disaster...
> 
> It's always easy in the event of some disaster to point out how you
> should have bought some different type of "insurance", but equally it's
> also dead money that a business could spend to generate income...
> Balancing funding between profitable activities and insurance is a fine
> line (especially since you are insuring against infrequent events)
> 
> As engineers, yes it's always easy to prefer to spend money on technical
> "insurance", but accept also that there are competing demands on where
> cash gets deployed to earn a return?

	Well, there is a big difference between "insurance" in the ordinary
sense, which is to say a recurring premium paid ad infinitum and a one time
capital outlay that offers greater reliability for the indefinite future.
In addition, depending upon the application, performance does have value.
All that said, I agree that as long as the performance is acceptable, and as
long as the average reliability is reasonable, the lower cost solution
coupled with a solid backup strategy is the better choice.

