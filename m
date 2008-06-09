From: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: RAID1 over aoe devices freezes cp-procs on failure of one aoe
	device
Date: Mon, 9 Jun 2008 13:32:44 -0400
Message-ID: <20080609173244.GA10348@coraid.com>
References: <20080605162502.09856f38.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080605162502.09856f38.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars T??uber <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org, sah@coraid.com
List-Id: linux-raid.ids

On Thu, Jun 05, 2008 at 04:25:02PM +0200, Lars T??uber wrote:
> Hi there.
> 
> please let me explain a problem i struggle with here with a self build SAN.
> 
> If of one of two AoE-devices of a RAID1 fails any process copying to the mounted RAID freezes.

The md driver might just be waiting for the I/O to fail or succeed
while the AoE command times out.  You can adjust aoe_deadsecs if you
like, so that I/O to an unavailable component is failed more quickly.

There is an aoetools-discuss mailing list at the sourceforge
"aoetools" project.  There you can talk to other people doing Linux
Software RAID 1 over AoE targets.

-- 
  Ed L Cashin <ecashin@coraid.com>
