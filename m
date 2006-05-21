From: Neil Brown <neilb@suse.de>
Subject: Re: raid 5 read performance
Date: Mon, 22 May 2006 08:38:43 +1000
Message-ID: <17520.60403.55872.255838@cse.unsw.edu.au>
References: <5d96567b0605210210wc3925ek6161f427944f8b7@mail.gmail.com>
	<17520.12342.245437.75779@cse.unsw.edu.au>
	<e9c3a7c20605211019i19dc1010r1abb45cb8a51b7d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Sunday May 21
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 21, dan.j.williams@gmail.com wrote:
> > Please read
> >
> > http://www.spinics.net/lists/raid/msg11838.html
> >
> > and ask if you have further questions.
> >
> Does this implementation also need to do delayed updates to the stripe
> cache?  I.e. we bypass the cache and get the requester the data it
> needs but then schedule that data to also be copied into the cache by
> the work queue.  The thinking being to reduce the read penalties
> associated with subsequent writes to the stripe.
> 

I doubt that would be worth the effort.  I don't think data lives very
long in the stripe cache, and so a lot of the copying would be wasted.
Also, I gather that modern drives have a reasonable cache and if data
was read recently for a read, then reading it again for a write might
be very quick.

I think the gains you get on the read side will more than offset any
small loss on the write side.

NeilBrown
