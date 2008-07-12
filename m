From: Neil Brown <neilb@suse.de>
Subject: Re: resync'ing - what is going on
Date: Sat, 12 Jul 2008 20:44:48 +1000
Message-ID: <18552.35616.626230.236249@notabene.brown>
References: <20080710165459.GA17542@rap.rap.dk>
	<18550.59093.835573.290313@notabene.brown>
	<20080711222927.GA10862@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Saturday July 12
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 12, keld@dkuug.dk wrote:
> I took the information here and made something for the wiki.
> Comments welcome.  /keld

Thanks for doing that.  I'm not motivated to work on the wiki myself,
but I'm more than happy for anyone to take any secrets I divulge in
emails and publish them there.

> 
> = recovery and resync =
> 
> The following is a recollection of what Neil Brown and others have
> written 
> on the linux-raid mailing list.
> 
> "resync" and "recovery" are handled very differently in raid10.
> "check" and "repair" are special cases of "resync".
> 
> == recovery ==
> 
> The purpose of the recovery process is to fill a new disk with the
> relevant 
> information from a running array.
> 
> The assumption is that all data do the new disk needs to be written.
> 
> "recovery" walks addresses from the start to the end of the component
> drives.
...
> 
> == resync ==
...
> 
> "resync" walks the addresses from the start to end of the array.

It's probably worth noting that this difference between recovery and
resync in specific to raid10.

recovery always follows the address space of component drives.

resync:
  on raid10, follows the address space of the array
  on raid4/5/6, follows the address space of component drives.
  on raid1, the two address spaces are the same.

Another way to say it is that raid10-resync follows the address space
of the array, everything else follows the component drives.

NeilBrown
