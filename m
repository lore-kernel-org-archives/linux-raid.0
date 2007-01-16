From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 20:16:23 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701152011480.16472@twinlark.arctic.org>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com>
 <45ABAA43.2000902@robinbowes.com> <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
 <45AC1DD9.9070402@panix.com> <Pine.LNX.4.64.0701151643270.16472@twinlark.arctic.org>
 <Pine.LNX.4.64.0701151938060.11250@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701151938060.11250@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 15 Jan 2007, Mr. James W. Laferriere wrote:

> 	Hello Dean ,
> 
> On Mon, 15 Jan 2007, dean gaudet wrote:
> ...snip...
> > it should just be:
> > 
> > echo check >/sys/block/mdX/md/sync_action
> > 
> > if you don't have a /sys/block/mdX/md/sync_action file then your kernel is
> > too old... or you don't have /sys mounted... (or you didn't replace X with
> > the raid number :)
> > 
> > iirc there were kernel versions which had the sync_action file but didn't
> > yet support the "check" action (i think possibly even as recent as 2.6.17
> > had a small bug initiating one of the sync_actions but i forget which
> > one).  if you can upgrade to 2.6.18.x it should work.
> > 
> > debian unstable (and i presume etch) will do this for all your arrays
> > automatically once a month.
> > 
> > -dean
> 
> 	Being able to run a 'check' is a good thing (tm) .  But without a
> method to acquire statii & data back from the check ,  Seems rather bland .
> Is there a tool/file to poll/... where data & statii can be acquired ?

i'm not 100% certain what you mean, but i generally just monitor dmesg for 
the md read error message (mind you the message pre-2.6.19 or .20 isn't 
very informative but it's obvious enough).

there is also a file mismatch_cnt in the same directory as sync_action ... 
the Documentation/md.txt (in 2.6.18) refers to it incorrectly as 
mismatch_count... but anyhow why don't i just repaste the relevant portion 
of md.txt.

-dean

...

Active md devices for levels that support data redundancy (1,4,5,6)
also have

   sync_action
     a text file that can be used to monitor and control the rebuild
     process.  It contains one word which can be one of:
       resync        - redundancy is being recalculated after unclean
                       shutdown or creation
       recover       - a hot spare is being built to replace a
                       failed/missing device
       idle          - nothing is happening
       check         - A full check of redundancy was requested and is
                       happening.  This reads all block and checks
                       them. A repair may also happen for some raid
                       levels.
       repair        - A full check and repair is happening.  This is
                       similar to 'resync', but was requested by the
                       user, and the write-intent bitmap is NOT used to
                       optimise the process.

      This file is writable, and each of the strings that could be
      read are meaningful for writing.

       'idle' will stop an active resync/recovery etc.  There is no
           guarantee that another resync/recovery may not be automatically
           started again, though some event will be needed to trigger
           this.
        'resync' or 'recovery' can be used to restart the
           corresponding operation if it was stopped with 'idle'.
        'check' and 'repair' will start the appropriate process
           providing the current state is 'idle'.

   mismatch_count
      When performing 'check' and 'repair', and possibly when
      performing 'resync', md will count the number of errors that are
      found.  The count in 'mismatch_cnt' is the number of sectors
      that were re-written, or (for 'check') would have been
      re-written.  As most raid levels work in units of pages rather
      than sectors, this my be larger than the number of actual errors
      by a factor of the number of sectors in a page.

