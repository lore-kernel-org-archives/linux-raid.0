From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Wed, 3 Mar 2010 13:03:16 +0100
Message-ID: <20100303120316.GA4745@lazy.lzy>
References: <20100228080949.GA30574@maude.comedia.it>
 <20100302160100.621f9811@notabene.brown>
 <20100302073624.GA28827@maude.comedia.it>
 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
 <20100302110232.GA14131@maude.comedia.it>
 <4B8D5581.8070509@shiftmail.org>
 <20100302185216.GB2243@lazy.lzy>
 <4B8D9EDD.2080300@shiftmail.org>
 <20100303091314.GA3730@lazy.lzy>
 <4B8E4B38.9070702@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8E4B38.9070702@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> >I've a bunch of RAID-6 volumes, made of USB disks, i.e. using
> >PATA<->USB bridges.
> Don't your bridges ever drop out or break?

never had problems of broken bridges, but other problems
I had, like unreliable transfer under certain conditions.

> What is the brand/model?

The best I could find were from Digitus, they've a pretty
standard chipset, JMicron I guess, but they seem to be build
better than others, still with JMicron.
No problems, so far.

I've other two brands, same chipset, which seem reliable
for the SATA part, but the PATA does not work properly.

All the other, from different vendors with different
chipset, had never problems.

I can imagine that the PSU that comes together might be a
weak point, I saw real poor quality units.

On the other hand, it's a bunch of RAID-6 for a reason... :-)

> Years ago I broke alot of those, just by using the disks
> intensively. They probably kinda overheated then failed. They
> couldn't last 2 days on intense disk activity... They were chinese
> stuff bought on ebay though.

My use case is an offline storage, so I'll not use the
box for two days, but for several hours I used it.
 
> 48MB/sec can be good for 1 disk, but it's bad for many disks
> attached separately to USB ports...

Well, maybe I forgot to mention that the HDDs are going to
the PC thru an USB HUB (three 4-1 USB, to be precise), i.e.
one single USB connection.
This can do, in theory, 60MB/s, in practice I never saw
more than 50MB/s, in ideal conditions.
So, in my view, 48MB/s is pretty much the max you can get.

> Might your LVM or partition within it be not aligned, or you didn't
> set readahead?

LVM takes care to align itself, this is in the new version,
and also the readahead seems to be automagically set.

Nevertheless, the LUKS is aligned, by hand.

> http://www.beowulf.org/archive/2007-May/018359.html
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg10804.html
> People using LVM on arrays giving hundreds of MB/sec see slowdowns
> of the order of percent
> http://article.gmane.org/gmane.linux.raid/18302

Thanks for the links, I'll have a look.
 
> >I've also RAID-10 on LVM and never got mismatches, while the
> >plain RAID-10 got sometimes.
> >
> This fact needs further investigation methinks...
> We could ask to the LVM people if LVM really copies the buffer.

Or, in general, if they have any explanation for this
observation of ours.

Thanks,

bye,

-- 

piergiorgio
