From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 08 Jan 2013 17:03:00 -0600
Message-ID: <50ECA5A4.1040400@hardwarefreak.com>
References: <1357610701.16366.13.camel@corn.betterworld.us>  <50EBAC5D.8080000@hardwarefreak.com>  <1357628351.16366.86.camel@corn.betterworld.us>  <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>  <1357631996.16366.139.camel@corn.betterworld.us>  <3D8A55DE-C4A8-4639-A662-CD3FF228230F@colorremedies.com> <1357682055.3484.34.camel@markov.biostat.ucsf.edu>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357682055.3484.34.camel@markov.biostat.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Boylan <ross@biostat.ucsf.edu>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/8/2013 3:54 PM, Ross Boylan wrote:

> I am less excited about that since discovering the message about sdb
> does not mean it's running at over 100 degrees celsius (the raw value is
> around 45).

You must ignore the VALUE and WORST columns for drive temp.  These are
"normalized" values only the smartmon idiots understand.  The actual
temp of 45C is a bit high, but well within the operating range for that
drive.  The WDC drives have a max temp (failure) of 80C IIRC, and a
normal max operating temp of 65C.  So you don't need to worry about this
drive's temp.

> The logs from the restart show
> Jan  7 17:19:09 markov kernel: [    2.928055] ata2.00: SATA link down (SStatus 0 SControl 0)
> Jan  7 17:19:09 markov kernel: [    2.928102] ata2.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Jan  7 17:19:09 markov kernel: [    2.944459] ata2.01: ATA-8: WDC WD2003FYYS-02W0B1, 01.01D02, max UDMA/133

> Jan  7 17:19:09 markov kernel: [    2.220056] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Jan  7 17:19:09 markov kernel: [    2.220103] ata1.01: SATA link down (SStatus 0 SControl 310)
> Jan  7 17:19:09 markov kernel: [    2.228670] ata1.00: ATA-8: ST3750330NS, SN05, max UDMA/133

> the SATA link down messages
> sound a little odd.

No mystery here.  These ports (links) are down because no drives are
connected to them, apparently.  Show full dmesg output, and tell us the
SAS/SATA controller and port count on each for the system in question.

-- 
Stan

