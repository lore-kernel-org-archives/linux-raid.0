From: linas@austin.ibm.com
Subject: Re: Root Drive Mirroring and LVM.
Date: Wed, 4 Feb 2004 12:23:17 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040204122317.K27780@forte.austin.ibm.com>
References: <868055F9-5045-11D8-8066-00039382032A@mindspring.com> <200401270801.i0R81HdT022197@kruuna.Helsinki.FI> <16407.4986.950905.135422@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16407.4986.950905.135422@notabene.cse.unsw.edu.au>; from neilb@cse.unsw.edu.au on Wed, Jan 28, 2004 at 12:42:18PM +1100
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Atro.Tossavainen@helsinki.fi, linuxppc-dev@lists.linuxppc.org, linux-raid@vger.kernel.org, tas@mindspring.com
List-Id: linux-raid.ids

On Wed, Jan 28, 2004 at 12:42:18PM +1100, Neil Brown wrote:
> solution and is (I think) the preferred long-term solution. However
> you can also boot from raid with kernel-parameters like:
> 
>    md=0,/dev/hda1,/dev/hdc1 boot=/dev/md0
> 
> where '0' indicated which md device (md0 in this case), and the
> remaining words are the devices to assemble it from.
> 
> I personally think auto-detect is the wrong approach and have no
> desire to extend it to other partition types (I cannot remove it from
> DOS partitions as that breaks back-compatability).
> Just use "md=..."

What's wrong with autodetect?  Its saved my butt a number of times.

My recurring nightmare is involves a failed ide controller.  If the 
failed controller is on the motherboard, then plugging in a store-bought
ide controller causes the BIOS to "randomly" renumber to hard drives.
(yes, sorry this is a PC issue, but I would guess that similar issues 
lurk in open firmware, etc). 

Thus, any sort of mounting that explictly references /dev/hdanything
is guarenteed to screw up (sometimes catastrophically) when trying
to recover from failed controllers (and sometimes even failed disks,
if you are trying to bootstrap your way through by temporarily putting 
the replacement disk somewhere other than its permanent home). 

And I'm a comp sci geek who wrote the original linux RAID HOWTO,
I pity the mere mortal sysadmin who has to go through this ... 

So what's wrong with autodetect, again?

--linas

