From: Ross Biro <rossb@google.com>
Subject: Re: Promise FastTrak TX4 losing interrupts (with apic mode)
Date: Thu, 06 Feb 2003 09:09:15 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E4296BB.2000407@google.com>
References: <F14meUdm8TihuWkpKyG0001ebd3@hotmail.com> <20011031162116.AF5A41018@shrek.lisa.de> <Pine.LNX.4.53.0302060313490.9702@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Stephan van Hienen <raid@a2000.nu>
Cc: Hans-Peter Jansen <hp@lisa-gmbh.de>, Shawn Evans <shawnwe@hotmail.com>, linux-raid@vger.kernel.org, Andre Hedrick <andre@aslab.com>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

>
>
>>>    ide7: BM-DMA at 0xb408-0xb40f, BIOS settings: hdo:pio, hdp:pio
>>>hda: WDC WD800BB-00BSA0, ATA DISK drive
>>>hdc: YAMAHA CRW2100E, ATAPI CD/DVD-ROM drive
>>>hdi: WDC WD800BB-00BSA0, ATA DISK drive
>>>hdk: WDC WD800BB-00BSA0, ATA DISK drive
>>>hdm: WDC WD800BB-00BSA0, ATA DISK drive
>>>hdo: WDC WD800BB-00BSA0, ATA DISK drive
>>>      
>>>

Don't know if it's related, but I believe these WD drives sometimes stop 
sending interrupts.  WD is aware of the problem and tells me they are 
working on a fix.

    Ross

