From: Pavel Machek <pavel@suse.cz>
Subject: Re: RAID-6 support in kernel?
Date: Tue, 4 Jun 2002 15:49:05 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <adj71k$enu$2@main.gmane.org>
References: <Pine.LNX.4.33.0206031020290.30424-100000@mail.pronto.tv> <Pine.GSO.4.21.0206030213510.23709-100000@gecko.roadtoad.net> <20020603113128.C13204@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020603113128.C13204@ucw.cz>; from vojtech@suse.cz on Mon, Jun 03, 2002 at 11:31:28AM +0200
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Derek Vadala <derek@cynicism.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

Hi!

> > > It'll waste 9 drives, giving me a total capacity of 7n instead of 14n. 
> > > And, by definition, RAID-6 _can_ withstand _any_ two-drive failure.
> > 
> > This is certainly not true. 
> > 
> > Combining N RAID-5 into a stripe wastes on N disks. 
> > 
> > If you combine two it wastes 2 disks, etc.
> > 
> > That is, for each RAID-5 you waste a single disk worth of storage for
> > partiy. I don't know what equation you're using where you get 9 drives
> > from.
> 
> He was thinking "mirror", not "stripe". Mirror of 2 RAID-5 arrays (would
> be probably called RAID-15 (when there is a RAID-10 for mirrored stripe
> arrays)), can withstand any two disks failing anytime. Even more for

RAID-1 over two RAID-5s should withstand any three failures, AFAICS.

You could do RAID-5 over RAID-5. That should survive any 2 failures and
still be reasonably efficient.
								Pavel
-- 
Philips Velo 1: 1"x4"x8", 300gram, 60, 12MB, 40bogomips, linux, mutt,
details at http://atrey.karlin.mff.cuni.cz/~pavel/velo/index.html.

