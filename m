From: Krekna Mektek <krekna@gmail.com>
Subject: Re: RAID 5 inaccessible - continued
Date: Wed, 15 Feb 2006 10:35:14 +0100
Message-ID: <8b24c8b10602150135l15b3da13s@mail.gmail.com>
References: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
	 <8b24c8b10602140035t5ca2e41cv@mail.gmail.com>
	 <17393.42370.394254.464935@cse.unsw.edu.au>
	 <8b24c8b10602140235s7a4ef1fam@mail.gmail.com>
	 <43F1FFE1.2010107@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F1FFE1.2010107@h3c.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried this one yesterday, with 2.6.15 that is. The same thing
happened, at the bad block sectors it tried and skipped some but after
a minute or two it stopped again.

Hmmmz.

Krekna

2006/2/14, Mike Hardy <mhardy@h3c.com>:
>
>
> Krekna Mektek wrote:
>
> > The dd actually succeeded, and did finish the job in about one day.
> > The badblocks were found after about the first 7 Gigs.
>
> Is this a 3-disk raid5 array? With two healthy disks and one bad disk?
>
> If so, then what you really want is a new kernel (2.6.15+? 2.6.14+?)
> that has raid5 read-error-handling code in it. Neil just coded that up.
>
> If it's missing a disk and has a disk with bad sectors, then you've
> already lost data, but you could use a combination of smart tests and dd
> to zero out those specific sectors (and only those sectors...) then sync
> a new disk up with the array...
>
> -Mike
>
