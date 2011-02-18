From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 12:48:17 +1100
Message-ID: <20110218124817.6dbdf4fc@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<20110216202939.GA2756@lazy.lzy>
	<20110217084826.77f4dbf1@notabene.brown>
	<4D5C6AAF.1040600@turmel.org>
	<20110217115257.28a8d174@notabene.brown>
	<4D5C768A.1010502@turmel.org>
	<20110217141017.01e30eab@notabene.brown>
	<alpine.LNX.2.01.1102171149110.13914@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1102171149110.13914@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 12:04:54 -0900 (AKST) "Mr. James W. Laferriere"
<babydr@baby-dragons.com> wrote:

>  	Hello Neil ,
> 
> On Thu, 17 Feb 2011, NeilBrown wrote:
> > On Wed, 16 Feb 2011 20:14:50 -0500 Phil Turmel <philip@turmel.org> wrote:
> >> On 02/16/2011 07:52 PM, NeilBrown wrote:
> >>> So when you do the computation on all of the bytes in all of the blocks you
> >>> get a block full of answers.
> >>> If the answers are all the same - that tells you something fairly strong.
> >>> If they are a "all different" then that is also a fairly strong statement.
> >>> But what if most are the same, but a few are different?  How do you interpret
> >>> that?
> >>
> >> Actually, I was thinking about that.  (You suckered me into reading that PDF
> >> some weeks ago.)  I would be inclined to allow the kernel to make corrections
> >> where "all the same" covers individual sectors, per the sector size reported
> >> by the underlying device.
> >
> > To see what I am strongly against having the kernel make automatic
> > corrections like this, see
> >
> >    http://neil.brown.name/blog/20100211050355
>  	Paraphrasing from the above ,  Mind all I did was skim the article . 
> But this statement from your conclusions leaves me a tad lost .
> 
> "... It could even be done entirely in user-space by suspending IO to the 
> affected stripe (md already supports that), making the required update, then 
> resuming IO. ..."
> 
>  	Hopefully the quantity of 'required update'ng would be extremely small .
>  	Tho if not ,  Then we'll start seeing locked at user level reports .  Of 
> course the process should be completely kill'able & nice'able in userspace as 
> long as there is documantation available to our 'informed admin' on howto limit 
> the processes possible abuses to his primary runtime service(s) .  Which will 
> probably be file sharing to other servers or workstations .
>  	I am quite sure you have thought thru that particular (and many other) 
> scenarios before making that proposal .  Would you please either here OR at the 
> original document above inform us a little more on how you feel you'd like to 
> approach the problem of a 'large update' ?  if a 'large update' should even be 
> possible not even sure of can or not .

If a 'large update' were needed then there is something seriously wrong and
you probably want to take your array offline before all the corruption in it
causes other problems.

It really think this is largely a theoretical issue with little practical
significance so I'm not interested in putting a lot of though/planning/effort
into it.

I think logging inconsistencies is important so people can find out what it
going on.
I think having a tool that can help interpret those inconsistencies would
certainly be valuable.
I don't think there is any point going anywhere beyond that until there is
some sort of information available about what sort of inconsistencies
actually happen.


> 
> 
>  	I also find myself agreeing with your 'to conclude the conclusion'-) 
> that automaticity should in 'general' be avoided .  An Aware & informed admin 
> is the best method to be used .
> 
> 
>  	And finally BUT not the least ,  Thank you .  Even tho we have our 
> differences of opinions on other aspects of the MD structure .

And thank you too!

NeilBrown

