From: Ed W <lists@wildgooses.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 16:47:29 +0000
Message-ID: <508D61A1.7020106@wildgooses.com>
References: <11510711257.20121028131527@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11510711257.20121028131527@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/10/2012 12:15, Rainer F=FCgenstein wrote:
> when trying to upgrade my raid5 with 4 Western digital caviar green
> 3TB drives [WDC WD30EZRX-00MMMB0] (3 brandnew, 1 about 4months old),
> the "old" drive and one of the brand new ones failed with
> unrecoverable read errors and about 70 reallocated sectors each. the
> failures already occured during the initial resync after creating the
> raid.
>
> until now I was very fond of WD caviar green drives, but after this
> 50% failure rate I'm not very eager to restore data from the backup.
>
> what is your experience with 3TB drives, WD and others?
>
> (low power drives appreciated, performance is not an issue)
>

I think there is clearly serial correlation in drive failures and this=20
tends to cause people to have brand love/hate stories.

I bought 9x Samsung 2TB green things about 2 years back  (to go in an 8=
x=20
NAS + 1 spare).  I think I had to return 4 almost immediately due to=20
either out of box reallocation warning, or that appeared within 2=20
weeks.  Probably if I hadn't been looking I wouldn't have noticed these=
=20
warnings and then been one of those groaning about Samsung when probabl=
y=20
they all expired within a few weeks of each other.  The RMA'd drives=20
have all been fine and the whole array seems ok some years later (teste=
d=20
weekly).  Note that I think I got 2x drives from a different supplier=20
(hence different batch), so that implies something like 4 out of 7 in a=
=20
given batch were "worrying", but the next 4 from a new batch showed no=20
obvious problems

I think this fits with the idea that the spinning disk failure curve ha=
s=20
a bump in the first few weeks, then flat until some years later when it=
=20
peaks again...

My conclusion:
- RAID6 for data that is highly valuable (and performance is acceptable=
)
- Thrash the drives initially for some weeks before you accept them int=
o=20
production.
- Although highly debated, I believe that failures are likely to be=20
correlated in time, when one drive goes there is a high probability of=20
loosing others in the next 24 hours. Take precautions as you see fit, e=
g=20
regular backups, hot/warm spares, etc
- Green consumer drives likely are satisfactorarily reliable for most=20
uses, caveat that you accept they will fail catastrophically eventually=
=20
(just like your enterprise drive will).  We can debate the relative lif=
e=20
of each, but it's almost certainly just a linear factor...

Good luck

Ed W

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
