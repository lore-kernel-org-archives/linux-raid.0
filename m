From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 03:22:14 -0500
Message-ID: <20090405082217.VGMW1944.cdptpa-omta02.mail.rr.com@Leslie>
References: <49D85AE8.7090701@sauce.co.nz>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D85AE8.7090701@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > In my original message I already said these are 1T SATA drives spread
> across
> > three different port multipliers.
> 
> Are these Seagates? 

Two of them are, but they are somewhat older drives, and they didn't have
this problem before.  The problem started immediately the last time I
rebuilt the array and formatted it as Reiserfs, after moving the drives out
of the old RAID chassis.

> If so, possibly you are hitting their recent firmware troubles, which I
> believe caused significant delays in drive operation.
> 
> Whilst this link refers to 1.5TB drives, I think I have seen reference
> elsewhere to 1TB drives also.
> 
> http://techreport.com/discussions.x/15863

I couldn't reach the link, but I've heard of this before, or something to
the effect.  It's possible, but to me this is looking ever less and less
like a problem at the drive level.

