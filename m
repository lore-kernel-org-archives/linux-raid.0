From: "Sujit Karataparambil" <sjt.kar@gmail.com>
Subject: Re: Device naming and raid1
Date: Wed, 27 Aug 2008 19:38:43 +0530
Message-ID: <921ca19c0808270708v5d0b9854ved991f13a2c3b35d@mail.gmail.com>
References: <48B42226.3020702@emitony.com>
	 <A20315AE59B5C34585629E258D76A97C01A506E3@34093-C3-EVS3.exchange.rackspace.com>
	 <48B554CA.4010804@emitony.com>
	 <921ca19c0808270631r784b5cx36d4636d63692e97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0808270631r784b5cx36d4636d63692e97@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

http://www.gagme.com/greg/linux/raid-lvm.php

you can try this with the spare drives you have.

basically what you have to do is to check whether the drive
now linked to another device name, is the reason for this
problem.

once it shows unplugged or failed you can, use your new
replacement drive and reboot.

Kindly read the comments to this article, Which is very
usefull.

On 8/27/08, Sujit Karataparambil <sjt.kar@gmail.com> wrote:
> > Thanks much for the reply.  For the purposes of this discussion you can
> > assume that I've already re-established confidence in the drive, the
> > cable, and the controller and that the data on the drives is worthless
> > and I just want to get maximum uptime without causing a raid assemble
> > problem on the next reboot.
>
> Good.
>
> >
> > Any idea on my original question?  If I re-add the drive using the
> > /dev/sdc name will I have problems on the next boot when the drive is
> > named /dev/sda?
>
> Since this seems to be block device it really does not matter.
>
> > Based on my experience with Linux and other software raid
> > implementations, I'm strongly inclined to think that the device naming
> > doesn't matter - the system will scan the drives at boot looking for
>
> Kindly read some decent kernel documentation before you jump up and
> say this. Kindly surf the net and read some decent article's before you
> do any precious upgrades for now.
>
> Sujit
>
> --
> --linux(2.4/2.6),bsd(4.5.x+),solaris(2.5+)
>


-- 
--linux(2.4/2.6),bsd(4.5.x+),solaris(2.5+)
