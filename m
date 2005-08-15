From: Pallai Roland <dap@mail.index.hu>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11
Date: Mon, 15 Aug 2005 15:50:11 +0200
Message-ID: <1124113811.10436.139.camel@localhost.localdomain>
References: <1124050204.3810.28.camel@localhost.localdomain>
	 <ddpuau$nv8$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ddpuau$nv8$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mon, 2005-08-15 at 13:29 +0200, Mario 'BitKoenig' Holbe wrote:
> Pallai Roland <dap@mail.index.hu> wrote:
> >  this is a feature patch that implements 'proactive raid5 disk
> > replacement' (http://www.arctic.org/~dean/raid-wishlist.html),
> > that could help a lot on large raid5 arrays built from cheap sata
> ...
> >  linux software raid is very fragile by default, the typical (nervous)
> 
> What I'm wondering about is how does your patch make the whole system
> behave in case of more harmful errors?
> The read errors you are talking about are quite harmless regarding
> subsequent access to the device. Unfortunately there *are* errors (even
> read errors, too), especially when you are talking about cheap IDE (ATA,
> SATA) equipment, where subsequent access to the device results in
> infinite (bus-)lockups. I think, this is the reason why Software-RAID
> does never ever touch a failing drive again. If you are changing this
> behaviour in general, you risk lock-ups of the raid-device just because
> one of the drives got locked up.
 yes, I understand your point, but I think the low level ATA driver must
be fixed if that lets a drive to lock up. as I know, the SCSI layer send
an abort/reset to the device driver if a request not served within a
timeout value ("hey, give me some kind of result, now!"), it's a good
operation, only a really braindead driver ignores that alarm..
 as I saw it in practice, modern sata drivers doesn't let a drive to
lock up, others should be teached about "timeout"

 unfortunately, bad blocks are often served slowly from damaged disks
and the array tries to access those periodically in this way, it could
slow down the array. I think about it, and would be a good starting
practice to build a table called 'this disk is bad for this stripe', an
insert occurs after a read error, a delete after if stripe is rewritten
to the disk. it reduces error lines in dmesg about bad sectors too

> What I did not find in your patch is some differentiation between the
> harmless and harmful error conditions. I'm not even sure, if this is
> possible at all.
 currently it doesn't tolerate write errors, if a write fails, the drive
gets kicked immediately, so a fully failed disk will not be accessed
forever.. anyway, it's really hard to determine what's a harmful error
(at this layer we've got a bit for that:), maybe we should to compute a
success-fail ratio (%) for a time, or scan the 'this disk is bad for
this stripe' table for errors and disable the disk if count of bad
blocks is over a user-defined threshold

summary (todo..!):
 - I think, we shouldn't care about drive lockups
 - would be good a 'this disk is bad for this stripe' table to speed up
array with partially failed drives, easy to implement it
 - make a switch to choose 'partially failed' feature on per-array basis
after the patch is being applied (eg. to remain compatible with buggy -
forever locking- device drivers)

 well?


-- 
 dap

