From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 8 Jul 2010 13:05:06 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
 <20100708104422.GA32564@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100708104422.GA32564@cthulhu.home.robinhill.me.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 8 Jul 2010, Robin Hill wrote:

> It would look like ata14 is the equivalent of scsi13 then - lsscsi or 
> "cat /proc/scsi" should show you the drives connected on controller 13 
> (or look in /sys/class/scsi_disk/13*/device/block).

Oki, yes, that's true, but the mapping from scsi13 to sdj isn't really my 
problem, I can find that out in quite a few ways. It's the mapping of 
ata14.00 to scsi13 that I can say is likely (from dmesg), but not certain.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
