From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 05 Dec 2008 18:39:18 -0600
Message-ID: <4939C9B6.30600@gmail.com>
References: <1228510833.16555.76.camel@localhost>	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>	 <1228511195.16555.78.camel@localhost>	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>	 <1228511558.16555.84.camel@localhost>	 <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>	 <4939A75C.6050705@rabbit.us>	 <6c4602af0812051426t2f7c1834w8e7478597b82d175@mail.gmail.com> <87f94c370812051443nd154992kfb61f3b6f0f5625d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370812051443nd154992kfb61f3b6f0f5625d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>, Peter Rabbitson <rabbit+list@rabbit.us>, Redeeman <redeeman@metanurb.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:

> I'm also very concerned about silent corruption and we often "verify"
> our critical large files by  performing MD5 verifies against a known
> good value.  Especially when we make copies or move them from one
> media to another.
> 
> But in all the cases of silent corruption I've seen, it was never the
> disk.  Instead I've seen it be the cable, the controller, bad memory,
> bad power supply, but never the disk itself.  Not to say the disk
> controller could not be the cause, just that I have not seen it.
> 
> I did not read the relevant threads, but do they cover all of these
> sources of silent corruption, or just if a disk is the source?
> 
> Thanks
> Greg

I will second what Greg says, I have debugged a number of corruptions 
related to filesystems.    I have never seen it be the disk, I have 
seen 3-4 different controllers corrupt (bad PCI/MB interaction-2 
different manufacturers controllers, and a bad controller).

And then the #1 issue is actual bad memory or bad power supply in the 
machine.   None of the actual cases I saw actually affected *ONLY* a 
single disk=they affected all of the disks on the controller, so 
whatever has to be done would almost have to be done a the filesystem 
level or the application level.    The typical corruption is not data 
off of the disk, the platters themselves (and the internals of the 
disk) appear to have very very good corruption detection and 
correction, it is really really unlikely for a bad sector read to not 
get caught.   The PCI bus only has parity (and likely parity errors on 
the PCI bus are not being monitored-unless you installed the edac_mc 
module) so 50% of the errors that happen get missed.    This was one 
of the bad PCI/MB interactions, one of the slots on a certain MB (all 
of the specific MB with a couple of different companies card) *HAD* to 
be throttled to not produce corrupt data every 1GB of reads or so.

And internally the controllers often have poor checking, and will miss 
things if the controller goes bad.   The disks themselves appear to 
have very good internal controls-I have never seen disk electronics 
screw up and corrupt data either.

Basically don't waste time worrying about the single disk corrupting 
data silently, worry about everything after the disk first as that is 
the weakest link of everything and is far far more likely to bite you.

