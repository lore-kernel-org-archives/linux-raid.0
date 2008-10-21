From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 16:11:35 +0200
Message-ID: <gdknuo$2qp$1@ger.gmane.org>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com>
 <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com>
 <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com>
 <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe <david@santools.com> wrote:
> S.M.A.R.T. does not, has not, will not, ever ... identify bad blocks.

Well, as you state yourself later, S.M.A.R.T. defines self-tests which
are able to identify bad blocks. Though, they have to be triggered.

> Both families of disks provide for some self-test commands, but these
> commands do not scan the
> entire surface of the disk

This is not true. The long self-test scans the entire surface of the
disk at least for ATA devices, I don't know if it does that for SCSI
devices too.
ATA does also know about selective self-tests which are able to scan
defineable surface areas - which is, at first, quite nice to identify
more than one bad sector, and which is, at second, quite nice on bigger
devices as well... my ST31500341AS take about 4.5 hours for a long
self-test.

> new bad block.  They report if you have a bad block if one is found in
> the extremely small sample
> of I/O it ran.

And, at least ATA devices report the LBA_of_first_error in the self-test
log, so you can identify the first bad sector.


regards
   Mario
-- 
Singing is the lowest form of communication.
                         -- Homer J. Simpson

