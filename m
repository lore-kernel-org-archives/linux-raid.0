From: Willy Tarreau <w@1wt.eu>
Subject: Re: [RFH] Partion table recovery
Date: Sat, 21 Jul 2007 21:40:28 +0200
Message-ID: <20070721194027.GH943@1wt.eu>
References: <200707200813.03553.a1426z@gawab.com> <4FEA8E81-3BA7-4F8C-AFD2-6B93487A9AD5@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FEA8E81-3BA7-4F8C-AFD2-6B93487A9AD5@cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 20, 2007 at 08:35:45AM +0100, Anton Altaparmakov wrote:
> On 20 Jul 2007, at 06:13, Al Boldi wrote:
> >As always, a good friend of mine managed to scratch my partion  
> >table by
> >cat'ing /dev/full into /dev/sda.  I was able to push him out of the  
> >way, but
> >at least the first 100MB are gone.  I can probably live without the  
> >first
> >partion, but there are many partitions after that, which I hope should
> >easily be recoverable.
> >
> >I tried parted, but it's not working out for me.  Does anybody know  
> >of a
> >simple partition recovery tool, that would just scan the disk for lost
> >partions?
> 
> parted and its derivatives are pile of crap...  They cause corruption  
> to totally healthy systems at the best of times.  Don't go near them.
> 
> Use TestDisk (http://www.cgsecurity.org/wiki/TestDisk) and be happy.   
> (-:

Thanks for this link Anton, it looks awesome and I'll add it to my
collection :-)

I mostly use vche (virtual console hex editor) to look for strings, find
offsets and/or fix data by hand. This should make me save some time !

Regards,
Willy

