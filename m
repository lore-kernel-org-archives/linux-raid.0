From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: some IDE trays are bad (was Re: SW-RAID 1 and kernel 2.4.18)
Date: 03 Dec 2002 14:10:16 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1038953416.1917.19.camel@peecee.linuxweasel.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC029@HW_MAIL>
	 <20021203160141.GA7990@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021203160141.GA7990@apartia.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2002-12-03 at 08:01, Louis-David Mitterrand wrote:
> On Tue, Nov 26, 2002 at 02:56:41PM +0100, SCHEP. - Schepke, Arnt wrote:
> > The system seems to work correctly. But i get some errors. In the file
> > messages i found: 
> > 
> > linux kernel: hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error } 
> > linux kernel: hdc: dma_intr: error=0x84 { DriveStatusError BadCRC }
> 
> I've just had the same problem. My setup: 4 Maxtor 160G connected to a
> Promise 133TX2 card, one of them was in an Icy Dock removable rack, the
> three remaining were directly connected to the IDE cable. 
> 
> The tray-connected disk would always give us the BadCRC error upon
> resynching with the raid5 array. That kind of error is typical of bad
> cabling.
> 
> It seems the additionnal connectors and cable-length in these IDE trays
> is too much to bear for picky/sensitive ATA133 drives. In any case the
> BadCRC disappeared the moment the drive was directly connected the IDE
> ribbon.

It's probably far more the quality of the connectors and such than the
length of the cables.  

> hdparm -t /dev/md1 gives me over 100MB/s on IDE raid5. Incredible! Over
> twice what a top-of-the-line 15k scsi drive gives me.

Are you saying that a RAID 5 array gives you better performance than a
single disk?  Make sense to me.  I'd be far more interested in a real
benchmark, rather than hdparm.  Across given runs on a single disk, I've
found it to be reasonably reliable, but from one disk to another, not
necessarily.  
	Greg

-- 
Gregory Leblanc <gleblanc@linuxweasel.com>

