From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Sat, 29 May 2010 15:44:12 -0500
Message-ID: <20100529204412.GA7501@flews.lairds.us>
References: <20100529190751.GM2167@flews.lairds.us>
 <4C016F17.4050709@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C016F17.4050709@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 29, 2010 at 03:46:31PM -0400, Berkey B Walker wrote:

> To me, things do not look good for a quick fix.  It kinda looks like
> you killed it.  Any info about the details of how things died,

I used smartctl multiple times on all drives in quick succession.

> and
> exactly what you did after things atarted going south?

I collected information.
	http://lairds.us/temp/ucmeng_md/mdstat_0

> What are you
> using for a controller? 

	http://lairds.us/temp/ucmeng_md/lspci
	03:00.0 SCSI storage controller: LSI Logic / Symbios Logic
	SAS1068E PCI-Express Fusion-MPT SAS (rev 04)

> It sounds like it is ready for the dump.
> Any messages from the controller, itself?

I didn't capture any before the reboot.

Thank you.

--kyler
