From: Michel Bellais <michel@ket.kth.se>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: Sat, 12 Jul 2003 18:06:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307121806.11944.michel@ket.kth.se>
References: <Pine.LNX.4.43.0307121548180.6220-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0307121548180.6220-100000@unicorn.drogon.net>
Content-Disposition: inline
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

it sounds tricky to me! 
But if some manufacturer inverts the partition order, that would be good for 
linux: usually windows is installed first and takes the best place on the 
drive, the penguin coming second.

On Saturday 12 July 2003 05:20 pm, Gordon Henderson wrote:
> On Sat, 12 Jul 2003, Michel Bellais wrote:
> > You're right, I thought about it too, but the fastest array is built with
> > partitions closer to the centre of the disk, so it should be the slowest
> > indeed.
> > The disks are big (180 Gb), the partitions represent less than 10% of it
> > and follow each others.  It cannot explain 30% difference in performance.
> >
> > I have created a third array on the disk, which is a copy of the slowest
> > array. It has the same content. This last array shows much better
> > performance than the original. And it is even closer to the centre...
> > So i really don't understand.
>
> Just a thought: What if modern disk manufacturers write from the inside
> out, rather than traditionally from the outside in?
>
> CD's are read from the inside out so we can have different size discs.
>
> Or maybe the hard disk manufacturers cottoned on to the fact that most
> people would benchmark freshly partitioned disks hoping the file would be
> at the "start" so they make it on the inside and get a better benchmark?
>
> Who knows! And I guess without taking one to bits to watch it work it's
> going to be hard to find out...
>
> Gordon
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

