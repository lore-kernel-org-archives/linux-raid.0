From: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFH] Partition table recovery
Date: Fri, 20 Jul 2007 14:29:24 +0300
Message-ID: <200707201429.24594.a1426z@gawab.com>
References: <200707200813.03553.a1426z@gawab.com> <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a8e1da0707192220x264d6675ie739b12f7ce81453@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Dave Young wrote:
> >On 7/20/07, Al Boldi <a1426z@gawab.com> wrote:
> > As always, a good friend of mine managed to scratch my partion table by
> > cat'ing /dev/full into /dev/sda.  I was able to push him out of the way,
> > but
>
> /dev/null ?
>
> > at least the first 100MB are gone.  I can probably live without the
> > first partion, but there are many partitions after that, which I hope
> > should easily be recoverable.
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
>
> The best way is to backup you partition table before destroyed.

Very true! 

# sfdisk -d 

is a real saviour.  But make sure you don't save it on the same disk you are 
trying to recover.


Thanks!

--
Al

