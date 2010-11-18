From: Phil Turmel <philip@turmel.org>
Subject: Re: Boot from degraded MD array
Date: Thu, 18 Nov 2010 12:39:55 -0500
Message-ID: <4CE564EB.8080507@turmel.org>
References: <9181E99F41C081478B455A70FC1D01CB0A4C3E6B@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9181E99F41C081478B455A70FC1D01CB0A4C3E6B@inbmail01.lsi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "G, Sushma" <Sushma.G@lsi.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/18/2010 10:25 AM, G, Sushma wrote:
> Hi,
> 
> I wanted to know if there is a way to activate a degraded array be default.
> 
>  In a scenario where OS is installed on a MD R1 array, with no spares configured, if a physical drive fails is there a way to still boot in to OS, without having to configure a hot spare?
> Also, is R5 different in any way, in the same scenario mentioned above ( R5 in degraded mode)?"
> 
> Setup: 
> Create a R1 using 2 sata disks, using mdadm with SLES 11 SP1 Operating system.
> Once OS is installed, shut down the system and fail a drive.  now try to boot up the OS.
> 
> OS boot fails because the RAID is inactive as the VD is degraded.

Look at the kernel command line options for MD, particularly "md-mod.start_dirty_degraded".

HTH,

Phil
