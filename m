From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: And again help on deciphering an error (continued)
Date: Fri, 14 Nov 2008 21:53:30 -0600
Message-ID: <491E47BA.1060204@shaw.ca>
References: <4907A5FA.7050903@rabbit.us> <491DC218.9010301@rabbit.us> <alpine.DEB.1.10.0811141456550.22161@p34.internal.lan> <491DDA43.4030600@sauce.co.nz> <alpine.DEB.1.10.0811141505400.22451@p34.internal.lan> <alpine.DEB.1.10.0811141510470.22451@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811141510470.22451@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Here are some more:
> 
> Jul 14 05:54:55 p34 kernel: [478107.751877] ata4.00: exception Emask 0x0 
> SAct 0x0 SErr 0x0 action 0x0
> Jul 14 05:54:55 p34 kernel: [478107.751883] ata4.00: irq_stat 0x40000001
> Jul 14 05:54:55 p34 kernel: [478107.751889] ata4.00: cmd 
> 25/00:f8:08:b0:ee/00:00:22:00:00/e0 tag 0 dma 126976 in
> Jul 14 05:54:55 p34 kernel: [478107.751890]          res 
> 51/40:f8:47:b0:ee/00:00:22:00:00/e0 Emask 0x9 (media error)
> Jul 14 05:54:55 p34 kernel: [478107.751895] ata4.00: status: { DRDY ERR }
> Jul 14 05:54:55 p34 kernel: [478107.751898] ata4.00: error: { UNC }

Drive reporting an uncorrectable error on a read command.

> Nov  9 09:25:19 p34 kernel: [ 3686.460568] ata4.00: exception Emask 0x0 
> SAct 0x0 SErr 0x0 action 0x0
> Nov  9 09:25:19 p34 kernel: [ 3686.460574] ata4.00: irq_stat 0x40000001
> Nov  9 09:25:19 p34 kernel: [ 3686.460579] ata4.00: cmd 
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Nov  9 09:25:19 p34 kernel: [ 3686.460580]          res 
> 51/10:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x81 (invalid argument)
> Nov  9 09:25:19 p34 kernel: [ 3686.460585] ata4.00: status: { DRDY ERR }
> Nov  9 09:25:19 p34 kernel: [ 3686.460589] ata4.00: error: { IDNF }

Flush cache returned ID not found (drive couldn't find a sector)

> Nov  9 09:25:24 p34 kernel: [ 3691.461173] ata4.00: qc timeout (cmd 0xec)
> Nov  9 09:25:24 p34 kernel: [ 3691.461183] ata4.00: failed to IDENTIFY 
> (I/O error, err_mask=0x5)
> Nov  9 09:25:24 p34 kernel: [ 3691.461187] ata4.00: revalidation failed 
> (errno=-5)
> Nov  9 09:25:24 p34 kernel: [ 3691.461192] ata4: hard resetting link
> Nov  9 09:25:24 p34 kernel: [ 3691.766178] ata4: SATA link up 3.0 Gbps 
> (SStatus 123 SControl 300)
> Nov  9 09:25:24 p34 kernel: [ 3691.803834] ata4.00: configured for UDMA/133
> Nov  9 09:25:24 p34 kernel: [ 3691.803846] end_request: I/O error, dev 
> sdd, sector 586067135
> Nov  9 09:25:24 p34 kernel: [ 3691.803849] md: super_written gets 
> error=-5, uptodate=0
> Nov  9 09:25:24 p34 kernel: [ 3691.803853] raid5: Disk failure on sdd1, 
> disabling device.
> Nov  9 09:25:24 p34 kernel: [ 3691.803854] raid5: Operation continuing 
> on 8 devices.
> 
> Nov 12 01:22:28 p34 kernel: [64894.610696] ata9.00: exception Emask 0x0 
> SAct 0x0 SErr 0x0 action 0x0
> Nov 12 01:22:28 p34 kernel: [64894.610703] ata9.00: irq_stat 0x00020002, 
> device error via D2H FIS
> Nov 12 01:22:28 p34 kernel: [64894.610708] ata9.00: cmd 
> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Nov 12 01:22:28 p34 kernel: [64894.610709]          res 
> 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
> Nov 12 01:22:28 p34 kernel: [64894.610714] ata9.00: status: { DRDY ERR }
> Nov 12 01:22:28 p34 kernel: [64894.610718] ata9.00: error: { ABRT }

Flush cache returned command aborted, presumably because the write to 
media failed.

Looks like some sick drives, or some other more global problem (power, 
temperature, etc.) to me..

