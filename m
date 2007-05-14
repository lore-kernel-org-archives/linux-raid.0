From: evoltech@2inches.com
Subject: Re: /proc/mdstat showing a device missing from array
Date: Mon, 14 May 2007 12:42:11 -0700
Message-ID: <1179171731.4648bb938d688@mail.2inches.com>
References: <1179081234.46475a12d46ba@mail.2inches.com> <17991.46650.304434.640289@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17991.46650.304434.640289@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Neil Brown <neilb@suse.de>:

> On Sunday May 13, evoltech@2inches.com wrote:
> > 
> > 
> > Hello all,
> > 
> > I just set up a new raid 5 array of 4 750G disks and am having a strange
> > experience where /proc/mdstat is showing that one device is missing from
> the
> > array.  The output from a "--detail" shows that there is some unnamed
> device
> > that has been removed from the array and I don't understand why or how to
> fix
> > it.  Can someone please shed some light?
> 
> A raid5 is always created with one missing device and one spare.  This
> is because recovery onto a spare is faster than resync of a brand new
> array.

This is unclear to me.  Do you mean that is how mdadm implements raid5 creation
 or do you mean that is how raid5 is designed?  I havn't read about this in any
raid5 documentation or mdadm documentation.  Can you point me in the right
direction?

> 
> The real problem here is that recovery has not started.
> If you 
>   mdadm -S /dev/md2
>   mdadm -A /dev/md2 /dev/sd[def]
>   mdadm /dev/md2 -a /dev/sdg
> it will start recovery.
> 
> This bug was fixed in mdadm-2.5.2

The recovery of the array has started, thanks!

Sincerely,
Dennison Williams
