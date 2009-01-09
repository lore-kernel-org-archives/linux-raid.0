From: whollygoat@letterboxes.org
Subject: Re: Alex Samad Re: RAID5 (mdadm) array hosed after grow operation
Date: Thu, 08 Jan 2009 18:41:26 -0800
Message-ID: <1231468886.24549.1293797183@webmail.messagingengine.com>
References: <1231144738.2997.1293010001@webmail.messagingengine.com>
 <alpine.DEB.1.10.0901050913470.3359@p34.internal.lan>
 <18786.34570.756734.253596@notabene.brown>
 <1231388345.19357.1293603883@webmail.messagingengine.com>
 <20090108101218.GI25654@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090108101218.GI25654@samad.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: debian-user@lists.debian.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 8 Jan 2009 21:12:18 +1100, "Alex Samad" <alex@samad.com.au>
said:
> On Wed, Jan 07, 2009 at 08:19:05PM -0800, whollygoat@letterboxes.org
> wrote:
> > 
> > On Tue, 6 Jan 2009 09:17:46 +1100, "Neil Brown" <neilb@suse.de> said:
> 
> [snip]
> 
> > How should I have done the grow operation if not as above?  The only
> > thing I see in man mdadm is the "-S" switch which seems to disassemble
> > the array.  Maybe this is because I've only tried it on the degraded 
> > array this problem has left with.  At any rate, after 
> > 
> >     mdadm -S /dev/md/0
> > 
> 
> [snip]
> 
> > 
> > Hope you can help,
> 
> Hi
> 
> I have grown raid5 arrays either by disk number or disk size, I have
> only ever used --grow and never used the -z option
> 
> I would re copy the info over from the small drives to the large drives
> (if you can have all the drives in at one time that might be better.
> 
> increase the partition size and then run --grow on the array. I have
> done this going from 250G -> 500G -> 750g -> 1T. although when I have
> done it, I fail one drive and then add the new drive, expand the
> partition size and re add it back into the array, once I have done all
> the drives I then ran the grow.
> 

I'm not sure I uderstand what you mean.  When you copy the info over and
then increase the partition size, are you doing something like dd
if=smalldrive
of=bigdrive, then using a tool like parted to resize the partition?  

I put the large drives in (as hot spares) with a single raid partition 
(type fd) that uses the entire disk, so I can't increase their size any. 
Then when I failed the drive the data it contained was rebuilt to the
larger
hot spare.

But anyway, I don't think that is going to matter.  The issue I am
trying to 
solve is how to de-activate the bitmap. It was suggested on the
linux-raid 
list that my problem may have been caused by running the grow op on an
active 
bitmap and I can't see from "man mdadm" how to de-activate the bit map.

The only thing I see about deactivation is --stop and that disassembles
the
array, in which case I can't run the grow command.  I read how to remove
the bitmap, but then I guess I would have to readd it after the grow op.
 In
any case, I would like to get the figured out without too much
experimentation
because swapping drives in and out and rebuilding is pretty time
consuming so I 
would really like to avoid fudging this up again.

Thanks for you help

goat
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

