From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: Status of Promise drivers?
Date: Sat, 10 Jan 2004 16:14:29 +0100
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20040110161429.B6153@nettis.grimsta>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta> <3FF1D8AE.2000107@pobox.com> <20031230211826.F14399@nettis.grimsta> <3FF1DF2B.3000501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1DF2B.3000501@pobox.com>; from jgarzik@pobox.com on Tue, Dec 30, 2003 at 03:25:15PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2003 at 03:25:15PM -0500, Jeff Garzik wrote:
> For VIA SATA, neither IDE nor libata program the chipset 100%, so I'm 
> not surprised you're seeing failures.  I'm working with VIA to get more 
> details as we speak.  They've been helpful so far.  I would recommend 
> sata_via over the generic IDE driver, but that's sorta a toss-up at present.

I've made some tests with 2.6.1 and 2.6.1-mm2.

Good news: RAID1 works on two SATA disks with the IDE VIA
driver (via82cxxx).  At least after a while (see below).

Bug 1: Doing a "modprobe via82cxxx" fails, since it tries to
aquire ide0 and ide1 even though they are used by other drivers.
Statically linked, it takes ide2 and ide3, just as it should.
My ide0 and ide1 are PATA connectors that I'd like to keep
even though the SATA connectors are activated.  The siimage
driver behaves correctly here, but only with the -mm2 version.

Bug 2: Using the RAID1 array while it is being synced causes
data corruption.  When the sync is complete, everything seems
to work fine.

/Basic

