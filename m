From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Sat, 21 May 2011 12:54:52 +0100
Message-ID: <4DD7A80C.8050808@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD7A205.8070106@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD7A205.8070106@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

> I understand your thinking. There is one big cost not mentioned in this
> calculation though:
> - what is the cost if the data is lost/corrupt?

I think it's fair to say that the loss of all your business data is the
loss of your entire business?!

That said if you are Skype you don't spend 8.5 billion on raid cards,
instead you choose a layered approach to availability which normally
trades speed of restore time vs cost.

Eg one might specify raid 6, dual mirrored servers, backed up to some
spare disks, blueray and some offsite storage service.  This would give
resilliance to various types of disaster without spending the entire
budget on a fancy raid card?

In fact if you go back to my question, the *entire* point is that I
don't want the choice of card to be a point of failure, ie it's my
specific point to purchase a card such that it can be swapped out for
near any other card in the event of failure.

> compared to that cost, how relevant is the cost of a proper card?

See point above.  I don't get a strong feeling that a "proper card" is
any more reliable and resiliant than a well chosen cheap card?  If that
theory is correct then the ability to swap in another cheap card in the
event of disaster is valuable and eliminates a point of failure for
little cost?

> I am getting the feeling of "penny wise, pound foolish"

I don't see that your logic leads here?

There is a clear definition of good/bad here.  The only acceptable
performance is that all reads/writes are accurate and completed.  No
data should be lost or corrupted.  Assuming that the market can be
partitioned into good/bad cards based on the definition above, then if
we select from only "good" cards, then price appears to only buy me
performance, nothing else?

So my question is how to choose from all the "good" cards, the best bang
for buck.  I don't see any reason not to buy a cheaper card that
performs well, subject to it being reliable and doesn't loose data.

Does someone have a claim that dataloss is actually on a curve and that
more expensive cards corrupt less data and cheaper cards corrupt more
data...  That doesn't seem to fit with expectation... (I expect either
working cards that loose nothing, or bad cards that loose some data.
Black and white)


> Now that mind set, of course, describes many a business....

I think this is a silly line of argument.  All you can ever do is buy
"insurance" against low probability events occuring.  Annoyingly the
"insurance" in this scenario doesn't always pay out and so the question
is how much to spend on orthogonal types of insurance to increase the
chance of a payout in the case of disaster...

It's always easy in the event of some disaster to point out how you
should have bought some different type of "insurance", but equally it's
also dead money that a business could spend to generate income...
Balancing funding between profitable activities and insurance is a fine
line (especially since you are insuring against infrequent events)

As engineers, yes it's always easy to prefer to spend money on technical
"insurance", but accept also that there are competing demands on where
cash gets deployed to earn a return?

Cheers

Ed W
