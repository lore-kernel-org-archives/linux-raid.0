From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: sata_nv and RAID1
Date: Wed, 15 Jun 2005 21:32:06 +0200
Message-ID: <62b0912f05061512324c532ecd@mail.gmail.com>
References: <62b0912f050614153092c01c0@mail.gmail.com>
	 <Pine.LNX.4.44.0506151512140.13609-100000@coffee.psychology.mcmaster.ca>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0506151512140.13609-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
> > > > unplugging both SATA and PATA devices Just Works (tm).  I'm having a
> > > > hard time figuring how this works: there's enough people supporting
> > > > Linux to build a complete web-enabled SCM system (git) in a couple of
> > > > weeks,
> > >
> > > SW engineering
> 
> and a real and urgent need.  and also the fact that it's easier.

Easier?  Why?
People need the operating system to cope with unplugging and/or
hotplugging devices under Windows but not Linux?  How do you figure?

> > > > but noone has bothered to fix this glaring flaw for the past 5
> > > > years?
> > > >
> > > HW engineering
> >
> > Aha.  And how would you explain that this currently works under Windows?
> 
> someone paid to get it to work under windows.  also, the quality requirement
> for windows is basically non-existent (redmond will not tell you you have
> crap code in your driver).

I've never had a crash in the IDE subsystem in Windows, I've had a ton in Linux.
Guess our experiences differ.

> I think the main issue is that there's not that much demand for ata-hotplug
> under linux.  it is, after all, an unusual thing to do, mainly involving
> crashes.  perhaps linux experiences fewer crashes.

"Perhaps it did 10 years ago, perhaps that's hardly a valid statement anymore."

> but if you're so upset about this, why not either go back to windows,

You don't have anything constructive to say and you can't provide any
answers, but you'd like to tell me to shut up...  Ok..

> or do something constructive (program or pay someone to program for you)?

For starters, I've asked Jeff Garzik (earlier in this thread) for what
details needed to be sorted out in order to make this work.  I'm still
eagerly awaiting his response.

And this thread itself could hopefully serve to make someone come
forward with some REAL arguments, or tell about current efforts, or
such.

I consider it constructive.  Perhaps it's just you that have an
attitude problem.
