From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: PATA in Promise 378 & troubles with Promise 378...
Date: Thu, 3 Jun 2004 23:07:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040603210743.GF11107@hvs.envisage.co.za>
References: <20040223141636.20fed6ba@hantst.kabel.utwente.nl> <20040223133539.GO6255@hvs.envisage.co.za> <403AA6FC.2080408@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <403AA6FC.2080408@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 23, 2004 at 08:21:00PM -0500, Jeff Garzik wrote:
> Hendrik Visage wrote:
> >On Mon, Feb 23, 2004 at 02:16:36PM +0100, Anton Starikov wrote:
> >>If now, why? Is there some religious reasons?  ;) 
> >
> >Elsewhere the answer is: Promise haven't provided the needed information 
> >yet.
> 
> I have the info (NDA, alas) but not the time, ATM.
> 
> 	Jeff

Hi Jeff,

 How have you progressed on this?

 I'm seeing a problem on x86_64 + 2.6.5 (vanilla, -mm and -gentoo) with the
MSI K8T Neo when pushing the onboard Realtek R8169 (just at 100 FDX) and 
dumping it to the SATA disks (Tested with EVM2 DM raid0, but also seen with
a straight "ping -f -s 1024" and dd of=/dev/promisesata if=/dev/viaPATA)

The interesting things are:
 I don't have troubles while pushing the ethernet and the Via PATA  and or the
Via SATA drives.
 I don't see the hangs when I move data between the Via [SP]ATA and the Promise
SATA while the network is "idle"
 The Promise SATA, Via SATA and Realtek GigEther all uses the same IRQ line.

Any specific ideas to try out??

HEndrik
