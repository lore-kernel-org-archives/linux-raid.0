From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: sata_nv and RAID1
Date: Wed, 15 Jun 2005 01:18:58 +0200
Message-ID: <62b0912f050614161875a4913c@mail.gmail.com>
References: <200506111613.42962.dvadell@lantech.com.ar>
	 <20050611192606.GA4055@pentafluge.infradead.org>
	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>
	 <42AD74BD.8050704@tls.msk.ru>
	 <62b0912f05061414116f7afedc@mail.gmail.com>
	 <42AF4E17.2040900@tls.msk.ru>
	 <62b0912f0506141526358647d0@mail.gmail.com> <42AF631C.1050806@tmr.com>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF631C.1050806@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Molle Bestefich wrote:
> > So you don't care that your Linux system will deadlock if a PATA disk
> > is removed, for instance?  Just an example, one that I've seen happen
> > a couple of times.  Never seen it with Windows, it just tells you that
> > the disk is gone.
> 
> Actually I suspect most Linux users are smart enough not to pull a PATA
> drive out while in use, and it works just fine if you offline the drive
> before removal.

That's not a good argument, other things can happen to throw a disk offline.
Flaky IDE or power cables and disk failure come to mind.
