From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 17:30:18 +0200
Message-ID: <gdksib$nap$1@ger.gmane.org>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
 <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com>
 <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com>
 <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com>
 <gdknuo$2qp$1@ger.gmane.org>
 <A20315AE59B5C34585629E258D76A97C025BF23B@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe <david@santools.com> wrote:
> is correctly called the "SMART selective
> self-test routine".   By the way, this is an OFF-LINE scan.  

short, long, conveyance and selective tests are all offline.

> So bottom line, Mario is correct in that there is a way to get a PARTIAL
> list of bad blocks, if you have a disk
> that supports this command, and you're willing to run an off-line scan
> (not practical or a parity-protected RAID 
> environment).

Most modern (ATA) disks support "Suspend Offline collection upon new
command". Well, the tests take notably longer on a loaded disk and
(low-frequent) requests to that disk take notably longer as well
(high-frequent requests just keep the test suspended), but it works.

> It is possible that some vendor has implemented a SATA ON-LINE bad block
> scanning mechanism that reports results and
> doesn't kill I/O performance.  It would have to give full list of bad
> blocks, or at least startingblock + range.
>
> That would be wonderful as you could just read the list on regular
> interval and rebuild stripes as necessary. You'd have
> Self-healing parity.

echo check > /sys/block/mdx/md/sync_action

That's indeed way more powerful than any attempt to rely on any
S.M.A.R.T. thingy.


regards
   Mario
-- 
I thought the only thing the internet was good for was porn.  -- Futurama

