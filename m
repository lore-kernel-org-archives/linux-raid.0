From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 16:01:00 +1100
Message-ID: <20100302160100.621f9811@notabene.brown>
References: <20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
	<20100225083936.07cd48ad@notabene.brown>
	<20100228080949.GA30574@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100228080949.GA30574@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 28 Feb 2010 09:09:49 +0100
Luca Berra <bluca@comedia.it> wrote:

> On Thu, Feb 25, 2010 at 08:39:36AM +1100, Neil Brown wrote:
> >On Wed, 24 Feb 2010 11:12:09 -0500
> >"Martin K. Petersen" <martin.petersen@oracle.com> wrote:
> >
> >> So realistically both disk blocks are wrong and there's a window until
> >> the new, correct block is written.  That window will only cause problems
> >> if there is a crash and we'll need to recover.  My main concern here is
> >> how big the discrepancy between the disks can get, and whether we'll end
> >> up corrupting the filesystem during recovery because we could
> >> potentially be matching metadata from one disk with journal entries from
> >> another.
> >
> >After a crash, md will only read from one of the devices (the first) until a
> >resync has completed.  So there should be no room for more confusion than you
> >would expect on a single device.
> 
> After thinking more about this i could come up with another concern
> about write ordering.
> 
> example
> app writes block A, B, C
> md writes A on both disks
> md writes B on disk1
> app writes B again (B')
> md writes B' on disk2
> now md would write B' again on both disks, but the system crashes
> (note, C is never written due to crash)
> 
> Disk 1 contains A and B in the correct order, it is missing C and B' but we
> dont care, app should be able to recover from a crash
> 
> Disk 2 contains A and B', but they are wrongly ordered because C is
> missing
> 
> If in the above case A and C are data blocks and B contains a journal
> related to A and C, booting from disk 2 could result in inconsistent
> data.
> 
> can the above really happen?
> would using barriers remove the above concern?
> am i missing something else?

These is no inconsistency here that a filesystem would not equally expect
from a single device.
After the crash-while-writing B', it should expect to see either B or B',
and it does, depending on which device is primary.

Nothing to see here.

NeilBrown
