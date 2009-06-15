From: Kyler Laird <kyler-keyword-linuxraid.6e1399@lairds.com>
Subject: Re: "cannot start dirty degraded array"
Date: Mon, 15 Jun 2009 11:57:37 -0400
Message-ID: <20090615155737.GU18313@lairds.com>
References: <20090610200310.GF18313@lairds.com> <4A366EAE.9010706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A366EAE.9010706@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 15, 2009 at 11:54:22AM -0400, Bill Davidsen wrote:

> Just a thought, when multiple units have errors at the same time, I  
> suspect a power issue. And if these are real SCSI drives, it's possible  
> for a drive to fail in such a way that it glitches the SCSI bus and  
> causes the controller to think that multiple drives doing concurrent  
> seeks have failed. I saw this often enough to have a script to force the  
> controller to mark drives good and then test them one at a time when I  
> was running ISP servers.

The X4540 has 48 SATA drives.  We've had a couple X4500s (similar) in
similar service for awhile with no problems.  I hadn't considered power
being a potential problem but I'll keep it in mind.

Thank you.

--kyler
