From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: RE: Scrub?
Date: Fri, 6 Aug 2004 14:58:56 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408061454420.2050@twinlark.arctic.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153143@otce2k03.adaptec.com>
 <Pine.LNX.4.55.0408060941560.14130@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0408060941560.14130@umi.cfht.hawaii.edu>
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 6 Aug 2004, Kanoa Withington wrote:

> On Fri, 6 Aug 2004, Salyzyn, Mark wrote:
> > Just reading the entire array should correct the bad blocks, so reverse
> > the sense of the dd:
> >
> > 	dd if=/dev/md0 of=/dev/null bs=200b
> >
> > to find and replace the bad blocks (making the assumption that md works
> > like the H/W RAID cards).
>
> In this case software RAID does not work like the H/W cards. Finding
> an unreadable block that way in a software array would cause it to go
> into a degraded state.

if the disks support SMART (i.e. they're less than a few years old) then
try running the smart long selftest... it can be done online and on many
disks it will force sector reallocation (and produce a SMART log event so
you know it happenned).

get smartmontools and run "smartctl -a" to see info on your drive, and
"smartctl -t long" to launch the long test.  man page has more examples.

i run smart long tests on each my disks once a week (staggerred over many
nights)... see /etc/smartd.conf.

-dean
