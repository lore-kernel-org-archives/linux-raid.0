From: Alex Davis <alex14641@yahoo.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 04:07:03 -0700 (PDT)
Message-ID: <432288.71787.qm@web50205.mail.re2.yahoo.com>
References: <20080502083656.28029.qmail@science.horizon.com>
Reply-To: alex14641@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080502083656.28029.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 5/2/08, George Spelvin <linux@horizon.com> wrote:

> From: George Spelvin <linux@horizon.com>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: alex14641@yahoo.com
> Cc: linux@horizon.com, linux-raid@vger.kernel.org
> Date: Friday, May 2, 2008, 4:36 AM
> Can you explain what you mean, exactly?
As an example, you have disks /dev/sd[abc]. /dev/md0 would be made 
from /dev/sda1, /dev/sdb1, and /dev/sdc1; /dev/md1 would be made  from /dev/sda2, /dev/sdb2, and /dev/sdc2.

> Do you just mean having two partitions on the same drive
> used as part
> of other RAID arrays?  That works fine.
> Having two heavilty used partitions on the same drive
> causes some
> performance issues, 
In this case they are heavily used.

>but no correctness ones.  And
> there's nothing
> special about RAID for this consideration; it would apply
> with
> non-RAID partitions as well.
> 
> But I have mirrored swap striped across all drives; I
> don't
> use swap a lot and it's not worth getting dedicated
> drives.
> 
> Likewise, /boot is a 6-way RAID-1 emergency rescue
> partition.
> I can boot off any drive, and I have a basic text-mode
> install
> with all the disaster recovery tools.  Again, not heavily
> used.
> 
> If you're doing serious database work, it's common
> to split the
> system, log, and database across different spindles.  But
> that's
> independent of whether RAID is used for any of them.
> 
> 
> But there are other possible interpretations of
> "sharing among multiple
> RAIDs", like hot spares and the like.  Could you be
> more specific?
> Obviously, having the same partition active in multiple
> different
> arrays would be an unmitigated disaster, but I don't
> think you mean that.
> (And I don't think mdadm lets you do it, either.)
> 
> One thing that's very nice about Linux software RAID is
> that you *don't*
> have to RAID whole drives.  It took me a while to
> understand Intel's
> "Matrix RAID" feature because it had never
> occurred to me that a RAID
> array *couldn't* be set up that way.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
