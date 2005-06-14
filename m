From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: sata_nv and RAID1
Date: Wed, 15 Jun 2005 00:26:53 +0200
Message-ID: <62b0912f0506141526358647d0@mail.gmail.com>
References: <200506111613.42962.dvadell@lantech.com.ar>
	 <20050611192606.GA4055@pentafluge.infradead.org>
	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>
	 <42AD74BD.8050704@tls.msk.ru>
	 <62b0912f05061414116f7afedc@mail.gmail.com>
	 <42AF4E17.2040900@tls.msk.ru>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF4E17.2040900@tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Molle Bestefich wrote:
> > Michael Tokarev wrote:
> >
> > > Without proper error handling [...]
> > > linux SATA subsystem isn't ready for production,
> > > and people should not rely on it *now*.
> 
> Note there was an "if" in that [...] -- "IF I/O errors are
> *really* not handled properly, linux SATA subsystem isn't
> ready etc"

Oh, ok.  Didn't seem relevant.  Sorry.


> > As long as disks aren't removed, it's OK for production..
> >
> > But I'll agree with anyone who says that IDE under Linux just sucks
> > donkey ass compared to IDE under Windows.  With Windows 2K and later,
> > unplugging both SATA and PATA devices Just Works (tm).  I'm having a
> > hard time figuring how this works: there's enough people supporting
> > Linux to build a complete web-enabled SCM system (git) in a couple of
> > weeks, but noone has bothered to fix this glaring flaw for the past 5
> > years?  What gives?
> 
> Well.. I don't want to start a flamewar, but I tend to disagree.
> I for one don't care (for now) about SATA and hot[un]plug for
> harddrives.

So you don't care that your Linux system will deadlock if a PATA disk
is removed, for instance?  Just an example, one that I've seen happen
a couple of times.  Never seen it with Windows, it just tells you that
the disk is gone.

>  But ol'good IDE works under linux just fine, together
> with proper

I disagree..

> (fsvo "proper", which isn't still proper for alot of
> IDE drives, but that's hardware and linux can't do anything there)

I'll agree to that one.

> error handling and stuff.  And with out-of-the-box toolset
> (smartmontools, hdparm), the support is better than win* --
> I have more options to monitor my drives, to reallocate bad
> blocks, to watch for drives dying, to control several h/w
> aspects of devices than on win*.

I'll have to disagree again.
For instance, SMART monitoring is not available for SATA devices under
Linux, while it is ready, available, working etc. under Windows.  I'm
unsure where those "more options" you're talking about is hiding.

> Well, ok, (and oh, it's
> another hot flamewar topic), I'm trying to avoid usage of
> IDE drives due to various limitations and defeciencies, and
> tend to use SCSI devices if at all possible...  And ok, ok,
> IDE != SATA... ;)

Let's not get into that, then ;-).
