From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:32:37 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105101721.9914A-100000@Maggie.Linux-Consulting.com>
References: <20050105172627.GQ99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050105172627.GQ99565@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya andy

On Wed, 5 Jan 2005, Andy Smith wrote:

> > > Your recommendations
> > 
> > that'd be your comment ... that is not whati said above
> 
> Direct quote:
> 
>         i'd add more memory before i'd use raid

i see ... when i say "i would use" ... i dont mean or imply 
others to do so ..

if i do mean "you" should, or i strongly recommend ... i usually
explicitly say so
        
> > and all i said, was use memory before you use swap on disks
> 
> Which means what?  Who is there on this list who likes to use swap
> *before* physical memory?

you'd be surprized how many people wonder why their system is slow
and they using 100% swap ( hundreds of MB of swap ) and little memory
beause its $50 of expensive memory
 
> Do all your machines which you believe have adequate memory also
> have no swap configured?

yes .... in my machines .. they are all mostly tuned for specfic
tasks ... very little ( say 0.05% swap usage even at peak )

> Fact is if your machine has swap configured then that swap is part
> of your virtual memory and if a device that is providing part of
> your virtual memory suddenly fails then your machine is going down.

yup...

and in some systems ... having swap ( too slow ) is NOT an option ... 
	( embedded systems, realtime operations, ... )
 
> I repeat, if "add more memory" is your answer to "swapping on a
> single device which then dies kills my machine" then does that mean
> that your machines are configured with no swap?

i'm NOT the one having hardware problems of any sort ...

i'm stating people that are having problems usually have problems
because of many possible reasons ...
	- most common one is, that it's a machine just slapped
	together with parts on sales from far away website vendors 
 
- if the machine cannot handle swapp ... to one partiton or
  or swap on other disks, than they have a serious hardware problem 
  that they bought pieces of hw junk  vs buying good parts
  from known good vendors
	==
	== you should NEVER have swap problems
	== otherwise, toss that system out or salvage what you can
	==

> All people are saying is that if you don't mirror swap then disk
> failures cause downtime.

yes ... 

and i'm just saying, if you dont know why swapp failed or 
that if downtime is important, use better quality hardware
and install it properly ... maintain it properly ...

if you forget about it .. the disk ... the disk will get
lonely too will forget about holding its 1's and 0's too

>  You are replying to add more memory and
> don'trun things that can get swapped. 

you're twisting things gain

> Those don't seem like very  useful recommendations.

that is becuase you're twisting things so you can make
comments i didnt say


> > 	- and i don't think anybody is idiotic enough to add
> > 	more memory for the "spikes" in the workload
> 
> OK so you must add swap to handle those spikes which means either
> you are happy that your machine will crash should the device that
> the swap is on die, or you use swap on a mirror to try to mitigate
> that.

this is pointless isnt it ...

are you an idiot or what ..
 
do you like to put words and recommendations that i didnt say
and twist it in your favor 

> 
> From previous email (not a direct quote):
> 
>         Don't run lpd on user-accessible machine

you obviously do NOT understand where to run lpd and where
to run dns and where to run pop and where to run ssh and where
to run mta ... and on and on and on ...
 
> If you do not suffer disk crashes then why do you use mirrors at
> all?

i do NOT use mirrors for the protection against disk failures

nobody said i did .. you again are twisting things into your
own ideas and misconceptions

>  If you do suffer disk crashes then any disk that is providing
> swap may very well cause the machine to crash.

i dont have that problem ...  but if someone ddid have that
problem ... i assuem they are smart enough to figure out
within 5-10 minutes why the disk/system is crashing
 
> I thought everyone suffered disk crashes and that was the point of
> RAID.

not everybody suffers disk crashes ... in such great numbers
that raid is better solution ...
	- raid is NOT theonly solution

== ever hear of high availability ...
	= clusters ...
	= even plain ole backups

there are more than one solution to one disk crashing

c ya
alvin

