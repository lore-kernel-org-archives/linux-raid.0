From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: Promise FastTrak TX4 losing interrupts (with apic mode)
Date: Thu, 6 Feb 2003 19:30:03 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302061928520.17629@ddx.a2000.nu>
References: <Pine.SGI.4.32.0302060924010.93623-100000@surfer.sbm.temple.edu>
 <Pine.LNX.4.53.0302061907550.17629@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302061907550.17629@ddx.a2000.nu>
To: AU <au@surfer.sbm.temple.edu>
Cc: Hans-Peter Jansen <hp@lisa-gmbh.de>, Shawn Evans <shawnwe@hotmail.com>, linux-raid@vger.kernel.org, Andre Hedrick <andre@linux-ide.org>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 6 Feb 2003, Stephan van Hienen wrote:

> On Thu, 6 Feb 2003, AU wrote:
>
> > Try to boot with apic=no or acpi=oldboot
> like i do now with append noapic, it works ok

does it 'hurt' running in noapic mode?
or is it only for more irq's available for devices ?
