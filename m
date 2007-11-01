From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: Implementing low level timeouts within MD
Date: Thu, 01 Nov 2007 00:08:09 -0500
Message-ID: <1193893689.3649.19.camel@w100>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
	 <1193765984.10336.519.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193765984.10336.519.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Samuel Tardieu <sam@rfc1149.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2007-10-30 at 13:39 -0400, Doug Ledford wrote:
> 
> Really, you've only been bitten by three so far.  Serverworks PATA
> (which I tend to agree with the other person, I would probably chock

3 types of bugs is too many, it basically affected all my customers
with  multi-terabyte arrays. Heck, we can also oversimplify things and 
say that it is really just one type and define everything as kernel type
problems (or as some other kernel used to say... general protection
error).

I am sorry for not having hundreds of RAID servers from which to draw
statistical analysis. As I have clearly stated in the past I am trying
to come up with a list of known combinations that work. I think my
data points are worth something to some people, specially those 
considering SATA drives and software RAID for their file servers. If
you don't consider them important for you that's fine, but please don't
belittle them just because they don't match your needs.

> this up to Serverworks, not PATA), USB storage, and SATA (the SATA stack
> is arranged similar to the SCSI stack with a core library that all the
> drivers use, and then hardware dependent driver modules...I suspect that
> since you got bit on three different hardware versions that you were in
> fact hitting a core library bug, but that's just a suspicion and I could
> well be wrong).  What you haven't tried is any of the SCSI/SAS/FC stuff,
> and generally that's what I've always used and had good things to say
> about.  I've only used SATA for my home systems or workstations, not any
> production servers.

The USB array was never meant to be a full production system, just to 
buy some time until the budget was allocated to buy a real array. Having
said that, the raid code is written to withstand the USB disks getting
disconnected as far as the driver reports it properly. Since it doesn't,
I consider it another case that shows when not to use software RAID
thinking that it will work.

As for SCSI I think it is a greatly proved and reliable technology, I've
dealt with it extensively and have always had great results. I know deal
with it mostly on non Linux based systems. But I don't think it is
affordable to most SMBs that need multi-terabyte arrays.

> 
> > I'll repeat my plea one more time. Is there a published list
> > of tested combinations that respond well to hardware failures
> > and fully signals the md code so that nothing hangs?
> 
> I don't know of one, but like I said, I've not used a lot of the SATA
> stuff for production.  I would make this one suggestion though, SATA is
> still an evolving driver stack to a certain extent, and as such, keeping
> with more current kernels than you have been using is likely to be a big
> factor in whether or not these sorts of things happen.

OK, so based on this it seems that you would not recommend the use
of SATA for production systems due to its immaturity, correct? Keep in
mind that production systems are not able to be brought down just to
keep up with kernel changes. We have some tru64 production servers with
1500 to 2500 days uptime, that's not uncommon in industry.

Alberto

