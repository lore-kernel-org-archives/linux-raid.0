From: SoulBlazer <soul@lamp-post.net>
Subject: Re: 2 HBA's and Multipath.
Date: Mon, 8 Apr 2002 15:03:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020408200445Z313701-22651+2147@vger.kernel.org>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020408191622.GB21055@colombina.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-Reply-To: <20020408191622.GB21055@colombina.comedia.it>
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What about write balancing ?

I would also be interested in discussing a possible patch to the raid code to 
do write/read balancing over N hba's if it is that trivial.

On April 8, 2002 03:16 pm, Luca Berra wrote:
> On Mon, Apr 08, 2002 at 02:02:56PM -0500, SoulBlazer wrote:
> > Question,
> >
> > I have 2 Qlogic Fiberchannel HBA's (2100F's) connected directly to both
> > FCAL ports on my Sun A5200 22 Disk disk array.  If I enable multipath, do
> > I get twice the throughput between my linux box and the array ? Or is
> > multipath purely for failover.
> >
> > Additionally do I get twice the bandwidth anyhow since both HBA's see the
> > same disk ?  How can I tell if either one or the other or both hba's are
> > being utilized...
>
> multipath does not do any read-balancing (see code below),
> while i don't think it would be difficult to implement (cut&paste from
> raid1.c) i did not have any time to try
>
> only way i found to do read-balancing at the moment is if you have multiple
> luns on your array you can create md configs with alternating channel
> order.
>
> regards,
> Luca
>
> ------- from 2.4.18-rc1/drivers/md/multipath.c
> static int multipath_read_balance (multipath_conf_t *conf)
> {
>         int disk;
>
>         for (disk = 0; disk < conf->raid_disks; disk++)
>                 if (conf->multipaths[disk].operational)
>                         return disk;
>         BUG();
>         return 0;
> }
