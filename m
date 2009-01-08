From: whollygoat@letterboxes.org
Subject: Re: RAID5 (mdadm) array hosed after grow operation
Date: Wed, 07 Jan 2009 20:19:05 -0800
Message-ID: <1231388345.19357.1293603883@webmail.messagingengine.com>
References: <1231144738.2997.1293010001@webmail.messagingengine.com>
 <alpine.DEB.1.10.0901050913470.3359@p34.internal.lan>
 <18786.34570.756734.253596@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18786.34570.756734.253596@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 6 Jan 2009 09:17:46 +1100, "Neil Brown" <neilb@suse.de> said:
> On Monday January 5, jpiszcz@lucidpixels.com wrote:
> > cc linux-raid
> > 
> > On Mon, 5 Jan 2009, whollygoat@letterboxes.org wrote:
> > 
> > > 

[snip]

> > > The RAID reassembled fine at each boot as the drives
> > > were replaced one by one.  After the last drive was
> > > partitioned and added to the array, I issued the
> > > command
> > >
> > >   "mdadm -G /dev/md/0 -z max"
> > >

[snip]

> 
> You cannot grow an array with an active bitmap... or at least you
> shouldn't be able to.  Maybe 2.6.18 didn't enforce that.  Maybe that
> is what caused the problem - not sure.
> 

I've decided to swap the smaller drives back in and start the upgrade 
process over again.  Seems that might be the fastest way to fix the 
problem.

How should I have done the grow operation if not as above?  The only
thing I see in man mdadm is the "-S" switch which seems to disassemble
the array.  Maybe this is because I've only tried it on the degraded 
array this problem has left with.  At any rate, after 

    mdadm -S /dev/md/0

running

    mdadm -D /dev/md/0

gave me an error something to the effect the array didn't exist or 
couldn't be found or something like that.

Or maybe do I need to add "--bitmap=none" to remove the bitmap 
when running the above grow command?

Hope you can help,

Thanks

goat
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - Same, same, but different...

