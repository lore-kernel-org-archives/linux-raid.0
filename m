From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: RE: Scrub?
Date: Sat, 7 Aug 2004 13:12:34 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408071310380.25286@twinlark.arctic.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153199@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153199@otce2k03.adaptec.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Kanoa Withington <kanoa@cfht.hawaii.edu>, Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

no, that's not how it works.  i'm referring to the hard disk itself
relocating a sector -- it's transparent to the host/raid.  the only thing
the raid software might see is that the disk will be less snappy while
it's running the SMART long test.  (mind you i do this on live busy
systems and i don't really tend to notice it -- although on particularly
busy weeks, some disks can take several days to complete their self test
in the few spare cycles they find.)

-dean

On Sat, 7 Aug 2004, Salyzyn, Mark wrote:

> Problem with running the relocation is that the RAID-5 will now be
> corrupt. The RAID-5 algorithm needs to be in-touch with disk block
> relocation so that it can correct the parity and the data.
>
> Sincerely -- Mark Salyzyn
>
> -----Original Message-----
> From: dean gaudet [mailto:dean-list-linux-raid@arctic.org]
> Sent: Friday, August 06, 2004 5:59 PM
> To: Kanoa Withington
> Cc: Salyzyn, Mark; Derek Listmail Acct; linux-raid@vger.kernel.org
> Subject: RE: Scrub?
>
> On Fri, 6 Aug 2004, Kanoa Withington wrote:
>
> > On Fri, 6 Aug 2004, Salyzyn, Mark wrote:
> > > Just reading the entire array should correct the bad blocks, so
> reverse
> > > the sense of the dd:
> > >
> > > 	dd if=/dev/md0 of=/dev/null bs=200b
> > >
> > > to find and replace the bad blocks (making the assumption that md
> works
> > > like the H/W RAID cards).
> >
> > In this case software RAID does not work like the H/W cards. Finding
> > an unreadable block that way in a software array would cause it to go
> > into a degraded state.
>
> if the disks support SMART (i.e. they're less than a few years old) then
> try running the smart long selftest... it can be done online and on many
> disks it will force sector reallocation (and produce a SMART log event
> so
> you know it happenned).
>
> get smartmontools and run "smartctl -a" to see info on your drive, and
> "smartctl -t long" to launch the long test.  man page has more examples.
>
> i run smart long tests on each my disks once a week (staggerred over
> many
> nights)... see /etc/smartd.conf.
>
> -dean
>
