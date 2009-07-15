From: David Lethe <david@santools.com>
Subject: Re: Chassis manager?
Date: Wed, 15 Jul 2009 15:46:01 -0500
Message-ID: <C683AA39.B563%david@santools.com>
References: <4A5E2D6F.3080000@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A5E2D6F.3080000@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: "J.H." <warthog9@kernel.org>
List-Id: linux-raid.ids

Assuming you enclosure is SES or SAF-TE compliant, then we've got a $90
package that does this.

Full environmental reporting (Fan speed, drive bays, temperature, voltage,
power supply, audible alarms, LEDs, etc ... as well as manipulation and
diagnostics.

But some gotchas --- in particular with drive failures. Only a catastriphic
failure will cause an enclosure to light a drive slot.  I.e, a head crash
won't necessarily result in a drive by let up. It is not the  job of an
enclosure to monitor drive health. SAS/FC/SCSI controller cards won't
necessarily do this either as, depending on the architecture, they send
the command to light up a drive to the disk, which is ignored by the
enclosure.

Our code will let you programmatically manipulate everything, but per the
spec, not every enclosure is obligated to support all that you wish to do.
No matter what, you'll need to set up a daemon that monitors whatever you
consider to be good enough reason to light up a drive bay, and there is no
"best" way that fits everything.

The SES spec also allows for lighting up a LED to indicate a drive needs to
be replaced in addition to a fault LED, but not all enclosures have this.
SAF-TE, used for SCSI-attached enclosures is quite dumb and likely won't let
you programmatically do anything but report basic info.

The manual is: http://www.santools.com/smart/unix/manual

Best to take this offline, feel free to contact me directly. It  is my
company, and I wrote most of the code
David  @ santools dot com


On 7/15/09 2:26 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:

> Hi all,
> 
> Does anyone happen to know of a chassis manager for Linux softraid?
> What I mean with that is something that can provide the user interface
> that hardware RAID provides for a co-lo'd server: light up the error
> light on a dead disk, have a tech walk up and swap the drive (without
> administrator intervention; the tech does not have or need access to the
> system), and then automatically start the rebuild?
> 
> -hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


