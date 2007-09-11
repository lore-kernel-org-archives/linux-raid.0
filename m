From: Iustin Pop <iusty@k1024.org>
Subject: Re: RAID1 and load-balancing during read
Date: Tue, 11 Sep 2007 05:44:17 +0200
Message-ID: <20070911034417.GA20596@teal.hq.k1024.org>
References: <200709102229.30655.jimis@gmx.net> <20070910193530.GB2597@teal.hq.k1024.org> <200709102251.37976.jimis@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200709102251.37976.jimis@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 10, 2007 at 10:51:37PM +0300, Dimitrios Apostolou wrote:
> On Monday 10 September 2007 22:35:30 Iustin Pop wrote:
> > On Mon, Sep 10, 2007 at 10:29:30PM +0300, Dimitrios Apostolou wrote:
> > > Hello list,
> > >
> > > I just created a RAID1 array consisting of two disks. After experiments
> > > with processes *reading* from the device (badblocks, dd) and the iostat
> > > program, I can see that only one disk is being utilised for reading. To
> > > be exact, every time I execute the command one of the two disks is being
> > > randomly used, but the other one has absolutely no activity.
> > >
> > > My question is: why isn't load balancing happening? Is there an option
> > > I'm missing? Until now I though it was the default for all RAID1
> > > implementations.
> >
> > Did you read the archives of this list? This question has been answered,
> > like, 4 times already in the last months.
> >
> > And yes, the driver does do load balancing. Just not as RAID0 does,
> > since it's not RAID0.
> 
> Of course I did a quick search in the archives but couldn't find anything. 
Hmm, it's true that searching does not point out an easy to find
response.

> I'll search better, thanks anyway. Moreover, I think I found the answer in 
> the code after posting. There is a comment somewhere in read_balance() 
> saying "Don't change to another disk for sequential reads". I have to study 
> it a bit to figure out *why* you chose that way. 
Well, from what I understand, you cannot make a mirror behave like a
stripe, plain and simple. There is no simple algorithm that makes
sequential raid behave better.

OTOH, random I/O or multiple threads are being sped up by raid1. And
people have said on the list that using the raid10 module with only two
disks and (IIRC) in offset or far mode will give better read
performance, albeit it reduces write performance.

Hmmm, I think a patch is needed to md.4 in order to explain this right
at the source of the confusion.

thanks,
iustin
