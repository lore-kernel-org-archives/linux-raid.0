From: Mark Watts <mrwatts@fast24.co.uk>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 10:51:00 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408011051.00300.mrwatts@fast24.co.uk>
References: <Pine.LNX.4.44.0408011110400.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408011110400.7382-100000@uplift.swm.pp.se>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Sun, 1 Aug 2004, Gordon Henderson wrote:
> > What I find amusing these days is trying to work out the "boundary" point
> > between a "traditional" server with an (external) RAID controller and say
> > a Linux server with software RAID in a purely fileserving environment
> > (eg. NFS/Samba, not used for local operations at all) ... Both systems as
> > a unit provide the same services - ie. filespace at the end of the Ether,
> > but what are the advantages of one over the other, and why would I ever
> > want a hardware RAID controller in a PCI slot in a Server PC?
> >
> > Discuss... ;-)
>
> Let's say you have a database server with a large RAID1+0 array. If you do
> this in software, you have to transfer data over the PCI bus twice if you
> do the raid in software, not so if you do it in hardware.
>
> But I agree, it's like "what is the best car?" It all depends on your
> needs and budget. A Porsche 911 is perfect for people who need to go
> places fast, it's useless for people who need to haul things.
>
> You always have to optimize everything after your needs, do you need
> highspeed sequencial access, do you need low latency small accesses, do
> you need a lot of fast low latency writes, etc. All these require
> different solutions.

Ok, I understand that for many areas, a software raid-5 will thrash the pants 
off of a hardware one.

This doesn't help explain why some of us are experiencing crap performance and 
un-responsive systems whereas others are having none of these problems  with 
the same 3Ware cards.

We have the hardware so we'd like to use it to the best of its ability. 
Obviously something isn't right with our systems - does anyone have any 
insight as to what this might be?

Mark.
