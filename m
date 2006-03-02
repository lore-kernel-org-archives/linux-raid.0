From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: NCQ general question
Date: Thu, 2 Mar 2006 10:14:53 +0200
Message-ID: <5d96567b0603020014p62d73dc3uc3e67c300110f373@mail.gmail.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com>
	 <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca>
	 <4405C41F.5060504@yahoo.de> <20060301160554.GD4816@suse.de>
	 <4405C9CA.9020500@pobox.com> <20060301185312.GI4816@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060301185312.GI4816@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Gentoopower <gentoopower@yahoo.de>, Mark Lord <liml@rtr.ca>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

i can see the NCQ realy bother people.

i am using a promise card sata TX4 150.
does any of you has a patch for the driver
so it would support NCQ ?

On 3/1/06, Jens Axboe <axboe@suse.de> wrote:
> On Wed, Mar 01 2006, Jeff Garzik wrote:
> > Jens Axboe wrote:
> > >On Wed, Mar 01 2006, Gentoopower wrote:
> > >>P.S. Just waiting to see NCQ support for my nforce system in libata:-)
> > >
> > >
> > >Don't hold your breath, it's unlikely to get supported as nvidia wont
> > >open the specs. ahci is a really really nice controller, if you want ncq
> > >I suggest going with that. sil is probably the next in line for ncq
> > >support.
> >
> >
> > Actually.....
> >
> > * Old-nvidia is ADMA, and I have docs under NDA
> >
> > * nvidia themselves say they are uninterested in NCQ support for their
> > older ADMA controllers, though they don't mind if I implement it
>
> So it's up to you if it'll happen or not. I'm sure people would
> appreciate nforce NCQ support :-)
>
> > * New-nvidia is AHCI, and thus will support NCQ when AHCI does
>
> Great! The sane choice, for both producer and consumer.
>
> > * slight correction to the above:  sil24 will do NCQ, I don't think sil does
>
> Ok, it was more of an umbrella sil label, I haven't looked into specific
> models.
>
> --
> Jens Axboe
>
>


--
Raz
