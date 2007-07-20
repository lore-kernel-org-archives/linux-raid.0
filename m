From: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:54 +0300
Message-ID: <200707201429.54241.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

James Lamanna wrote:
> On 7/19/07, Al Boldi <a1426z@gawab.com> wrote:
> > As always, a good friend of mine managed to scratch my partion table by
> > cat'ing /dev/full into /dev/sda.  I was able to push him out of the way,
> > but at least the first 100MB are gone.  I can probably live without the
> > first partion, but there are many partitions after that, which I hope
> > should easily be recoverable.
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
>
> Tried gpart?
> http://www.stud.uni-hannover.de/user/76201/gpart/

This definitely looks like the ticket.  And also rescuept from util-linux.  
There is only one small problem; I have been regularly adding / deleting / 
resizing partitions, which kind of confuses the scanner.  But still, it's 
better than nothing.

Anton Altaparmakov wrote:
> parted and its derivatives are pile of crap...  They cause corruption
> to totally healthy systems at the best of times.  Don't go near them.
>
> Use TestDisk (http://www.cgsecurity.org/wiki/TestDisk) and be happy.
> (-:

This one really worked best, without getting confused about older partitions.


Thanks everybody!


BTW, what's a partion table?

--
Al

