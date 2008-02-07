From: Neil Brown <neilb@suse.de>
Subject: Re: raid10 on three discs - few questions.
Date: Thu, 7 Feb 2008 13:21:24 +1100
Message-ID: <18346.27428.521186.423248@notabene.brown>
References: <20080203235043.3dbb6433@szpak>
	<18342.18975.229866.860765@notabene.brown>
	<47A9FFE1.5070001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 6, davidsen@tmr.com wrote:
> >
> >   
> >> 4. Would it be possible to later '--grow' the array to use 4 discs in
> >>    raid10 ? Even with far=2 ?
> >>
> >>     
> >
> > No.
> >
> > Well.... if by "later" you mean "in five years", then maybe.  But the
> > code doesn't currently exist.
> >   
> 
> That's a reason to avoid raid10 for certain applications, then, and go 
> with a more manual 1+0 or similar.

Not really.  You cannot reshape a raid0 either.

> 
> Can you create a raid10 with one drive "missing" and add it later? I 
> know, I should try it when I get a machine free... but I'm being lazy today.

Yes, but then the array would be degraded and a single failure could
destroy your data.

NeilBrown
