From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 10:34:17 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0307281024000.15708@router.windsormachine.com>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net>
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 28 Jul 2003, mjstumpf wrote:

> Perhaps off topic or FAQ.  My apologies, seemed like best forum.
>
> I need to expand an x86-based fileserver that's already stacked with 11
> drives.  Where have you folks found reasonably-priced very very large ATX
> cases?  I need to go to 20 or so drives, but I'd like to hear the upper
> limit you have all found..
>
> Are there other means of packing more drives into a small space -- IE, has
> anyone actually fabricated a bracket that would take multiple vertical
> 5.25" form factor spaces, and let you mount 3.5" drives sideways
> [vertically] to pack 4 drives into the space of 3.. etc..

Yes, there's carriers to let you do this, I've seen 3 3.5 in 2
5.25(normal orientation), and 4-5 3.5" in 3 5.25"(on their side).

Try googling for 3in2 ide.

Most of these are very expensive if they're hotswappable and all that, I
found a very cheap(30 dollar) bracket about two years ago, but don't
recall the url.

You do have to really watch your cooling though, because you're taking
away any space around the drives.

Most of these carriers are designed for SCSI.

You should set your scsi drives to power on by scsi id.(drive 0 powers up
immediately, id 1 powers up 7(12) seconds later, scsi id 15 powers up
7(12) * 15 seconds later.

Else the spinup current may overwhelm your power supply even if the PS can
normally handle that many drives.

If you need something to plug IDE drives into, the 3ware 7500-12 works
quite nicely in Linux, along with it's 7500-8 8 port brother.  This will
also let you hotswap drives.  These cards do raid0,1,10,5,etc, or
alternatively let you just use the drives normally.

Something like a 12 5.25" bay case, such as the high end Antec 1500(can't
remember exact model) could theorectically hold 20 scsi drives.  Cabling
and power will become fun at that point though.

Don't bother with IDE in the antec case unless you want to drill a hole
through the motherboard plate, as 18" ide cables are not long enough to
reach around except for the very bottom or top 5.25" bays.  The Antec 1500
is a nice case otherwise though.  I have a system with 4 15krpm cheetah's,
a jaz drive, cdrom, and a dds-3 mounted without having to actively cool
the cheetahs.  There's enough airflow to keep them at barely warm.  Then
again, with 1 80mm + 9 92mm fans, (4 front, 6 back) I'd hope so!

Yes, it's loud.

Mike
