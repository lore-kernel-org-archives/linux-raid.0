From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 05:44:10 +0000
Message-ID: <a8e1da0707192244n345100cdub8ef6168cf348c8c@mail.gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <20070720053526.GG943@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070720053526.GG943@1wt.eu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

>On 7/20/07, Willy Tarreau <w@1wt.eu> wrote:
> On Fri, Jul 20, 2007 at 08:13:03AM +0300, Al Boldi wrote:
> > As always, a good friend of mine managed to scratch my partion table by
> > cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but
> > at least the first 100MB are gone.  I can probably live without the first
> > partion, but there are many partitions after that, which I hope should
> > easily be recoverable.
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
>
> The best one is simply "fdisk", because you can manually enter your
> cylinders numbers. You have to find by hand the beginning of each partition,
> and for this, you have to remember what filesystems you used and see how to
> identify them (using a magic). Then with an hex editor, you scan the disk to
> find such entries and note the possible sectors on a paper. Then comes fdisk.
> You create the part, exit and try to mount it. If it fails, fdisk again and
> try other values.
One more possible solution about this, you can find the filesystem
magic position, if ext2/ext3 , /dev/sda can be mounted with option
sb=blocknumber
>
> I've saved many disks that way, it may sound harder than it really is. It
> should not take you more than half an hour to get the first part. Knowing
> your approximate partitions size will help too.
>
> Good luck!
> Willy
