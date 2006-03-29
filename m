From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: question : raid bio sector size
Date: Wed, 29 Mar 2006 11:21:25 +0000
Message-ID: <5d96567b0603290321q7dce9525o22fe191531abed8c@mail.gmail.com>
References: <5d96567b0603270849v6546a760oe3a703cb8bad3b3e@mail.gmail.com>
	 <17448.27848.37751.899817@cse.unsw.edu.au>
	 <5d96567b0603290157g5cfcc7d1p27e221a6ac06ad0@mail.gmail.com>
	 <17450.24364.454485.762623@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17450.24364.454485.762623@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

man .. very very good.
blockdev --getsz says 512.


On 3/29/06, Neil Brown <neilb@suse.de> wrote:
> On Wednesday March 29, raziebe@gmail.com wrote:
> > I was refering to bios reaching make_request in raid5.c .
> > I would be more precise.
> > I am dd'ing " dd if=/dev/md1 of=/dev/zero bs=1M count=1 skip=10"
> > I have added the following printk in make_request "printk ("%d:",bio->bi_size)"
> > I am getting sector sizes. 512:512:512:512:512....
> > I suppose they gathered in the elevator,
> > but still why so small ?
>
> Odd.. When I try that I get 4096 repeatedly.
> Which kernel are you using?
> What does
>    blockdev --getbsz /dev/md1
> say?
> Do you have a filesystem mounted on /dev/md1?  If so, what sort of
> filesystem.
>
> NeilBrown
>


--
Raz
