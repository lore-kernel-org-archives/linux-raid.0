From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: invalid superblock - *again*
Date: Tue, 22 Aug 2006 13:26:42 +0200
Message-ID: <200608221326.42776.Dexter.Filmore@gmx.de>
References: <200608210104.17274.Dexter.Filmore@gmx.de> <200608220302.23412.Dexter.Filmore@gmx.de> <17642.23419.119010.518798@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17642.23419.119010.518798@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Dienstag, 22. August 2006 03:18 schrieb Neil Brown:
> >
> > Most notable: [   38.536733] md: kicking non-fresh sdd1 from array!
> > What does this mean?
>
> It means that the 'event' count on sdd1 is old compared to that on
> the other partitions.  The most likely explanation is that when the
> array was last running, sdd1 was not part of it.

Event count - so: a certain command or set of instructions was sent to all 
disks, but one didn't get it, hence the raid module can't ensure that the 
data on that disk is consistent with the rest of the array?

> > What's happening here? What can I do? Do I have to readd sdd and resync?
> > Or is there an easier way out? What causes these issues?
>
> Yes, you need to add sdd1 back to the array and it will resync.

Ok, if that's what it takes.

> I would need some precise recent history of the array to know why this
> happened.  That might not be easy to come by.

Depends on what exactly you mean. Disk age? smart data? Hardware types? Logs? 
OS?

I don't have more than a few vague guesses about what might have happened. 
First of all it might be possible that the file systems on the array were not 
unmounted properly during shutdown because a remote NFS mount was hogging 
them. If that be the case, LVM couldn't have shut down properly, then the md 
device wouldn't have stopped and the machine just powered down.
That would explain it.
Slackware has no raid runlevel scripts out of the box, I wrote them myself.
Maybe such conditions are not handled properly.

What speaks against that theory is that nfsd is stopped before lvm and raid is 
handled.

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
