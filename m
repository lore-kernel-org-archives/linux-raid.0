From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: raid 5 read performance
Date: Sun, 21 May 2006 10:19:07 -0700
Message-ID: <e9c3a7c20605211019i19dc1010r1abb45cb8a51b7d5@mail.gmail.com>
References: <5d96567b0605210210wc3925ek6161f427944f8b7@mail.gmail.com>
	 <17520.12342.245437.75779@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17520.12342.245437.75779@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Please read
>
> http://www.spinics.net/lists/raid/msg11838.html
>
> and ask if you have further questions.
>
Does this implementation also need to do delayed updates to the stripe
cache?  I.e. we bypass the cache and get the requester the data it
needs but then schedule that data to also be copied into the cache by
the work queue.  The thinking being to reduce the read penalties
associated with subsequent writes to the stripe.

Dan
