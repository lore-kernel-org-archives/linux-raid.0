From: Neil Brown <neilb@suse.de>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Wed, 10 Oct 2007 07:52:41 +1000
Message-ID: <18187.63529.526020.305681@notabene.brown>
References: <20071008211313.6cd8bbb5@absurd>
	<470A846B.9090805@sauce.co.nz>
	<20071009002550.12b9b26d@absurd>
	<20071009004636.112c886e@absurd>
	<18186.63033.185101.385806@notabene.brown>
	<Pine.LNX.4.64.0710090752570.11772@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Tuesday October 9
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday October 9, babydr@baby-dragons.com wrote:
>  	Hello Neil ,
> 
> On Tue, 9 Oct 2007, Neil Brown wrote:
> > On Tuesday October 9, janek_listy@wp.pl wrote:
> >>
> >> Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
> >> grow an array to a degraded array (non existant disc). Is it possible?
> >
> > Why not experiment with loop devices on files and find out?
> >
> > But yes:  you can grow to a degraded array providing you specify a
> > --backup-file.
>  	Is there an estimate of how large this file can get ?
>  	It's probably a calculation based on disk & array parameters .
>  	But I was unable to find a reference on it from the manpage .
> 
>  		Tia ,  JimL

I think:

   chunk-size * old-ndisks * new-ndisks * 2 + 1K

It might be smaller than that, but it shouldn't be larger.

NeilBrown
