From: Maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 14:24:19 +0100
Message-ID: <200501041424.19802.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501040145.07569.maarten@ultratux.net> <rs6qa2-ekh.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <rs6qa2-ekh.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 11:14, Peter T. Breuer wrote:
> maarten <maarten@ultratux.net> wrote:
> > On Monday 03 January 2005 21:41, Peter T. Breuer wrote:
> > > maarten <maarten@ultratux.net> wrote:

> It would make sense to a 16 year old, since that's about where you get
> to be certified as competent in differential calculus and probability
> theory, if my memory of my high school math courses is correct.  This is
> pre-university stuff by a looooooong way.

Oh wow.  So you deduced I did not study math at university ?
Well, that IS an eye-opener for me.  I was unaware studying math was a 
requirement to engage in conversation on the linux-raid mailinglist ?
Or is this not the list I think it is ?

> The problem is that I never have a 9-year old child available when I
> need one ...

Um, check again... he's sitting right there with you I think.

> You forget it because it is tiny.  As tiny as you or I could wish to
> make it.  Puhleeze.  This is just Poisson distributions.

>
> Therefore you forget it. All of differential calculus works like that.
> Forget the square term - it vanishes. All terms of the series beyond
> the first can be ignored as you go to the limiting situation.

And that is precisely what false assumption you're making ! We ARE not going 
to the limiting situation. We are discussing the probabilities in failures of 
media.  You cannot assume we will be talking about harddisks, and neither is 
the failure rate in harddisk anywhere near limit zero. Drive manufacturers 
might want you to believe that through publishing highly theoretical MTBFs, 
but that doesn't make it so that any harddrive has a life expectancy of 20+ 
years, as the daily facts prove all the time.
You cannot assume p to be vanishingly small.  Maybe p really is the failure 
rate in 20 year old DAT tapes that were stored at 40 degrees C.  Maybe it is 
the failure rate of wet floppydisks. You cannot make assumptions about p.  

The nice thing in math is that you can make great calculations when you 
assume a variable is limit zero or limit infinite.  The bad thing is, you 
cannot assume that things in real life act like predefined math variables.

> > Who is to say p will always be 0.1 ?
>
> Me.  Or you.  But it will always be far less.  Say in the 1/10^40 range
> for a time interval of one second.  You can look up such numbers for
> yourself at manufacturers sites - I vaguely recall they appear on their
> spec sheets.

Yes, and p will be in the range of 1.0 for time intervals 10^40 seconds. Got 
another wisecrack ?  Of course p will approach zero when you make time 
interval t approach zero !!  And yes, judging a time of 1 second as a 
realistic time interval to measure a disk drives' failure rate over time 
certainly qualifies as making t limit zero.
 
Goddamnit, why am I even discussing this with you.  Are you a troll ??   

> Your logic fails here - it is exactly as small as I wish it to be,
> because I get to choose the interval of time (the "scale") involved.

No, you don't.  You're as smart with numbers as drive manufactures are, 
letting people believe it is okay to sell a drive with a MTBF of 300000 
hours, yet with a one year warrantee.  I say if you trust your own MTBF put 
your money where your mouth is and extend the warrantee to something 
believable. 
You do the same thing here.  I can also make such calculations:  I can safely 
say that at this precise second (note I say second) you are not thinking 
clearly.  I now can prove that you never are thinking clearly, simply by 
making time interval t of one second limit zero, and hey, whaddayaknow, your 
intellect goes to zero too.  Neat trick huh ?

> If your jaw were to drop any lower it would drag on the ground :(.  This
> really demonstrates amazing ignorance of very elementary high school
> math.

That is because I came here as a linux admin, not a math whiz. I think we have 
already established that you do not surpass my admin skills, in another 
branch of this thread, yes ? (boy is that ever an understatement !)

A branch which you, wisely, left unanswered after at least two people besides 
myself pointed out to you how fscked up (pun intended ;) your server rooms 
and / or procedures are.  

So now you concentrate on the math angle, where you can shine your cambridge 
medals (whatever that is still worth, in light of this) and outshine "baby 
math" people all you want.  I got news for you: I may not be fluent anymore 
in math terminology, but I certainly have the intellect and intelligence to 
detect and expose a bullshitter.

>
> Perhaps you've forgotten it all!  Then how do you move your hand from
> point A to point B?  How do you deal with the various moments of inertia
> involved, and the feedback control, all under the affluence of incohol
> and gravity too?

Well that's simple.  I actually obey the law.  Such as the law of gravity, and 
the law that says any outcome of a probability calculation cannot be other 
than between zero and one, inclusive.  You clearly do not.  (though I still 
think you obey gravity law, since obviously you're still here)

Maarten

