From: "George Spelvin" <linux@horizon.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 04:36:55 -0400
Message-ID: <20080502083656.28029.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: alex14641@yahoo.com
Cc: linux@horizon.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can you explain what you mean, exactly?

Do you just mean having two partitions on the same drive used as part
of other RAID arrays?  That works fine.

Having two heavilty used partitions on the same drive causes some
performance issues, but no correctness ones.  And there's nothing
special about RAID for this consideration; it would apply with
non-RAID partitions as well.

But I have mirrored swap striped across all drives; I don't
use swap a lot and it's not worth getting dedicated drives.

Likewise, /boot is a 6-way RAID-1 emergency rescue partition.
I can boot off any drive, and I have a basic text-mode install
with all the disaster recovery tools.  Again, not heavily used.

If you're doing serious database work, it's common to split the
system, log, and database across different spindles.  But that's
independent of whether RAID is used for any of them.


But there are other possible interpretations of "sharing among multiple
RAIDs", like hot spares and the like.  Could you be more specific?
Obviously, having the same partition active in multiple different
arrays would be an unmitigated disaster, but I don't think you mean that.
(And I don't think mdadm lets you do it, either.)

One thing that's very nice about Linux software RAID is that you *don't*
have to RAID whole drives.  It took me a while to understand Intel's
"Matrix RAID" feature because it had never occurred to me that a RAID
array *couldn't* be set up that way.
