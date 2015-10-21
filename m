From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 12:05:29 -0400
Message-ID: <5627B7C9.1050700@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org> <5627BAB4.7010402@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5627BAB4.7010402@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, andras@tantosonline.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Wols,

I glad you've got the big picture correct, but some details need to be
addressed:

On 10/21/2015 12:17 PM, Wols Lists wrote:

> tl;dr summary ...
> 
> Desktop drives are spec'd as being okay with one soft error per 10TB
> read - that's where a read fails, you try again, and everything's okay.

No, this isn't correct.

That spec is for *unrecoverable* read errors.  For desktop drives,
typically spec'd as one such error every 1e14 bits read, on average.
These are failures where you really have lost the sector contents.  Such
sectors are marked as "Pending Relocations" in drive firmware.  But the
recording surface might still be good, so the drive waits for a write to
that pending sector, which it then verifies, before deciding to relocate
or not.

When MD raid receives a read error, whether in normal operation or a
scrub, it will reconstruct the missing data and write it back, closing
this loop immediately.  Where "normal operation" means "read errors are
reported by the drive before the driver times out".

> A resync will scan the array from start to finish - if you have 10TB's
> worth of disk, you MUST be prepared to handle these errors.
> 
> By default, mdadm will assume a disk is faulty and kick it after about
> 10secs, but a desktop drive will hang for maybe several minutes before
> reporting a problem.

MD raid has no timeout, and does not kick drives out for occassional
read errors.  The timeout is in the per-device drivers (SCSI, SATA,
whatever).  Which defaults to 30 seconds.  Desktop drives typically keep
trying to read a bad sector for 120 seconds or more, ignoring the world
while they do so.  Drives with default SCTERC support typically report a
read error within four to seven seconds.

With a desktop drive, the linux device driver bails after 30 seconds and
resets the link to the drive -- which gets ignored.  And keeps getting
ignored until the original read retry cycle finishes.  During this time,
MD has reconstructed the data and told the driver to write the fixed
sector.  That *write* also fails (because the driver is failing to
reset) and that *write error* kicks the drive out of the array.

Anyways, please consider reading the threads I pointed Andras at :-)

Phil
