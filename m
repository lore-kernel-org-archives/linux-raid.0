From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: RE: Scrub?
Date: Sat, 7 Aug 2004 13:19:28 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408071312470.25286@twinlark.arctic.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153199@otce2k03.adaptec.com>
 <Pine.LNX.4.55.0408070950250.13168@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0408070950250.13168@umi.cfht.hawaii.edu>
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

at least two of my older maxtor disks (model 4G120J6) reallocated a sector
during a long self test.  or maybe i didn't run enough of a controlled
experiment... but smartctl -a before and after diffs showed
"Reallocated_Sector_Ct"  increase by 1, and one of the two disks wasn't in
any use at the time.  (the other was in light use, and may have tripped up
the normal write-reallocate path.)

i have a cronjob run smartctl -a every day, and diff the output with the
previous day; and smartd runs the self tests once a week.

not that i'm disagreeing with the need for improvements to md in this
area... see <http://arctic.org/~dean/raid-wishlist.html> :)

-dean

On Sat, 7 Aug 2004, Kanoa Withington wrote:

> Furthermore, drives (including those with SMART support) only
> reallocate bad blocks following write errors. A scrub/verify tool
> would be looking for read errors and would need to actively replace
> the unreadable block with rudundant data from a _different_ drive.
>
> Actually, I guess it would be kind of complicated. A scan for
> unreadable blocks would need to occur outside of the md layer (to
> prevent the errors from triggering a degraded state), yet the block
> replacement would need to occur through the md layer, since only md
> knows how to recreate the block from parity. It would probably be a
> easier for a RAID 1 array where the disks are symetric and you could
> guess the location of the redundant block on the second volume. You
> would probably need to use md on a RAID 5 array.
>
> -Kanoa
>
> On Sat, 7 Aug 2004, Salyzyn, Mark wrote:
>
> > Problem with running the relocation is that the RAID-5 will now be
> > corrupt. The RAID-5 algorithm needs to be in-touch with disk block
> > relocation so that it can correct the parity and the data.
> >
> > Sincerely -- Mark Salyzyn
> >
> > -----Original Message-----
> > From: dean gaudet [mailto:dean-list-linux-raid@arctic.org]
> > Sent: Friday, August 06, 2004 5:59 PM
> > To: Kanoa Withington
> > Cc: Salyzyn, Mark; Derek Listmail Acct; linux-raid@vger.kernel.org
> > Subject: RE: Scrub?
> >
> > On Fri, 6 Aug 2004, Kanoa Withington wrote:
> >
> > > On Fri, 6 Aug 2004, Salyzyn, Mark wrote:
> > > > Just reading the entire array should correct the bad blocks, so
> > reverse
> > > > the sense of the dd:
> > > >
> > > > 	dd if=/dev/md0 of=/dev/null bs=200b
> > > >
> > > > to find and replace the bad blocks (making the assumption that md
> > works
> > > > like the H/W RAID cards).
> > >
> > > In this case software RAID does not work like the H/W cards. Finding
> > > an unreadable block that way in a software array would cause it to go
> > > into a degraded state.
> >
> > if the disks support SMART (i.e. they're less than a few years old) then
> > try running the smart long selftest... it can be done online and on many
> > disks it will force sector reallocation (and produce a SMART log event
> > so
> > you know it happenned).
> >
> > get smartmontools and run "smartctl -a" to see info on your drive, and
> > "smartctl -t long" to launch the long test.  man page has more examples.
> >
> > i run smart long tests on each my disks once a week (staggerred over
> > many
> > nights)... see /etc/smartd.conf.
> >
> > -dean
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
