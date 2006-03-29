From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: question : raid bio sector size
Date: Wed, 29 Mar 2006 09:57:36 +0000
Message-ID: <5d96567b0603290157g5cfcc7d1p27e221a6ac06ad0@mail.gmail.com>
References: <5d96567b0603270849v6546a760oe3a703cb8bad3b3e@mail.gmail.com>
	 <17448.27848.37751.899817@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17448.27848.37751.899817@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

I was refering to bios reaching make_request in raid5.c .
I would be more precise.
I am dd'ing " dd if=/dev/md1 of=/dev/zero bs=1M count=1 skip=10"
I have added the following printk in make_request "printk ("%d:",bio->bi_size)"
I am getting sector sizes. 512:512:512:512:512....
I suppose they gathered in the elevator,
but still why so small ?

thank you
raz.

On 3/27/06, Neil Brown <neilb@suse.de> wrote:
> On Monday March 27, raziebe@gmail.com wrote:
> > i have playing with raid5 and i noticed that the arriving bios  sizes
> > are 1 sector.
> > why is that  and where is it set ?
>
> bios arriving from where?
>
> bios from the filesystem to the raid5 device will be whatever size the
> fs wants to make them.
>
> bios from the raid5 device to the component devices will always be 1
> page (typically 8 sectors).  This is the size used by the stripe cache
> which is used to synchronise everything.
>
> NeilBrown
>


--
Raz
