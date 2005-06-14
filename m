From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: sata_nv and RAID1
Date: Tue, 14 Jun 2005 23:11:07 +0200
Message-ID: <62b0912f05061414116f7afedc@mail.gmail.com>
References: <200506111613.42962.dvadell@lantech.com.ar>
	 <20050611192606.GA4055@pentafluge.infradead.org>
	 <42AB49BC.50104@tls.msk.ru> <42AD2B85.30303@pobox.com>
	 <42AD74BD.8050704@tls.msk.ru>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AD74BD.8050704@tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> Without proper error handling [...]
> linux SATA subsystem isn't ready for production,
> and people should not rely on it *now*.

As long as disks aren't removed, it's OK for production..

But I'll agree with anyone who says that IDE under Linux just sucks
donkey ass compared to IDE under Windows.  With Windows 2K and later,
unplugging both SATA and PATA devices Just Works (tm).  I'm having a
hard time figuring how this works: there's enough people supporting
Linux to build a complete web-enabled SCM system (git) in a couple of
weeks, but noone has bothered to fix this glaring flaw for the past 5
years?  What gives?
