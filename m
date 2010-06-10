From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 10 Jun 2010 12:58:52 -0700
Message-ID: <20100610195851.GA8408@libra.CS.Berkeley.EDU>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100611005231.401529c0@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your response, Roman.

On Fri, Jun 11, 2010 at 12:52:30AM +0600, Roman Mamedov wrote:
> > I have been using RAID5 on a desktop machine using a couple of 500
> > GB drives.  My original intent was to grow the array by adding more
> > drives, as the need arises.
> 
> Do you currently run RAID5 with just 2 drives, in degraded mode, or
> maybe you meant something else?

No, it is not degraded, it's a clean 2-drive RAID5. I know it doesn't
make much sense as it is ;-)  the intent was to grow the array later,
relying on mdadm's grow feature. Right now, I'm guessing that it
operates like a RAID1 for all practical purposes.

Gilad
