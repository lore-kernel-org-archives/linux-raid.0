From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: XP RAID vs md
Date: Wed, 2 Apr 2003 15:35:52 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030402153552.A10159@newbox.localdomain>
References: <3E8AD562.6090707@webmail.co.za> <20030402152731.GE7364@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030402152731.GE7364@marowsky-bree.de>; from lmb@suse.de on Wed, Apr 02, 2003 at 05:27:31PM +0200
To: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lars Marowsky-Bree on Wed  2/04 17:27 +0200:
> > Wow... I hope that one of the maintainers will comment
> > on this, I didn't even know that XP had a sw RAID
> > implementation. Up to 100% more on read and 60% more on
> > write is quite a significant margin. Is there anything
> > in favour of the md driver if this is true?
> 
> However, with RAID1 for example, I got approximately twice
> the read speed [...]
> 
> I have a really hard time imagining a 100% read boost;
> that would simply exceed disk bandwidth [...]

isn't "100%" the same as double? If you get "approximately
twice" then you are getting 100% already...
