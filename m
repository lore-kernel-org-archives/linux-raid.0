From: Bernd Schubert <Bernd.Schubert@tc.pci.uni-heidelberg.de>
Subject: Re: Double failure on RAID-5 array
Date: Wed, 18 Jun 2003 18:50:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030618165010.GA31334@tc.pci.uni-heidelberg.de>
References: <20030616161848.M47561@liquid-nexus.net> <20030618071323.M50246@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030618071323.M50246@liquid-nexus.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

> I'm hoping my move to 2.4 series wasn't a mistake - I have a lot of data on 
> this array!
> 

Unless you have created 2.4 and above filesystem specific things (e.g.
reiserfs 3.6, etc), downgrading to 2.2 shouldn't be that difficult,
should it ?

> Appreciate any help. 
> 
> Jun 16 19:26:22 xerces kernel: hde: timeout waiting for DMA
> Jun 16 19:26:22 xerces kernel: ide_dmaproc: chipset supported ide_dma_timeout 
> func only: 14
> Jun 16 19:26:22 xerces kernel: hde: status error: status=0x50 { DriveReady 
[...]

Looks like a drive hardware problem. You could try to run some drive
tests using smartctl.
On the other hand it could be one of the ide-kernel bugs as well, I
would upgrade to 2.4.21 in any case.

Bernd
